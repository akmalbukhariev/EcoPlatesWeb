import 'package:ecoplates_web/src/blocs/main_page_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../blocs/main_page_cubit.dart';
import '../../../constant/user_or_company_status.dart';
import '../../../constant/constants.dart';
import '../app_alert_dialog_yesno.dart';
import '../build_summary_card.dart';
import '../group_box_widget.dart';

class SearchDashBoard extends StatefulWidget{
  const SearchDashBoard({super.key});

  @override
  State<SearchDashBoard> createState()  => _SearchDashBoard();
}

class _SearchDashBoard extends State<SearchDashBoard> {

  late MainPageCubit cubit;

  @override
  void initState() {
    super.initState();

    cubit = context.read<MainPageCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MainPageCubit, MainPageState>(
      listener: (context, state) {
        if (state.refreshWindow) {
          setState(() {});
        }
      },
      child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      SizedBox(
                        height: 47,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                            backgroundColor: cubit.state.searchUserClicked ? Colors.blue : Colors.grey[300],
                            foregroundColor: cubit.state.searchUserClicked ? Colors.white : Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              cubit.setSearchClicked(clicked: true);
                            });
                          },
                          child: const Text("User"),
                        ),),
                      SizedBox(
                        height: 47,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                            backgroundColor: !cubit.state.searchUserClicked ? Colors.blue : Colors.grey[300], // Active/Inactive color
                            foregroundColor: !cubit.state.searchUserClicked ? Colors.white : Colors.black, // Text color
                          ),
                          onPressed: () {
                            setState(() {
                              cubit.setSearchClicked(clicked: false);
                            });
                          },
                          child: const Text("Company"),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: GroupBoxWidget(
                          onSearchPressed: (phoneNumber) {
                            if(cubit.state.searchUserClicked) {
                              cubit.searchUserInfo(phoneNumber: phoneNumber);
                            }
                            else{
                              cubit.searchCompanyInfo(phoneNumber: phoneNumber);
                            }
                          },
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Expanded(
                    child: cubit.state.searchUserClicked ? UserSearchGridView() : CompanySearchGridView()
                  ),
                ],
              ),
            ],
          )
      ),
    );
  }
}

class UserSearchGridView extends StatefulWidget{
  const UserSearchGridView({super.key});

  @override
  State<UserSearchGridView> createState()  => _UserSearchGridView();
}

class _UserSearchGridView extends State<UserSearchGridView> {
  late PlutoGridStateManager stateManager;

  late MainPageCubit cubit;

  List<PlutoRow> buildUserRow() {
    final user = cubit.state.searchUserData;

    if (user == null) {
      return [];
    }
    print("searchUserData is not null =====================================");

    return [
      PlutoRow(cells: {
        'col1': PlutoCell(value: user.userId?.toString() ?? ''),
        'col2': PlutoCell(value: user.phoneNumber ?? 'No Phone'),
        'col3': PlutoCell(value: user.firstName ?? 'N/A'),
        'col4': PlutoCell(value: user.lastName ?? 'N/A'),
        'col5': PlutoCell(value: user.deleted == true ? "DELETED" : user.status.value ?? 'Unknown'),
        'col6': PlutoCell(value: user.formatDateTime(user.updatedAt) ?? ''),
        'col7': PlutoCell(value: user.formatDateTime(user.createdAt) ?? ''),
        'col8': PlutoCell(value: user.isBanned() ? Constants.BANNED : Constants.BAN),
        'col9': PlutoCell(value: user.deleted == true ? Constants.DELETED : Constants.DELETE),
      })
    ];
  }

  List<PlutoColumn> buildColumns(BuildContext context) {
    return [
      PlutoColumn(
        title: 'Id',
        field: 'col1',
        type: PlutoColumnType.text(),
        readOnly: true,
      ),
      PlutoColumn(
        title: 'Phone number',
        field: 'col2',
        type: PlutoColumnType.text(),
        readOnly: true,
      ),
      PlutoColumn(
        title: 'First Name',
        field: 'col3',
        type: PlutoColumnType.text(),
        readOnly: true,
      ),
      PlutoColumn(
        title: 'Last Name',
        field: 'col4',
        type: PlutoColumnType.text(),
        readOnly: true,
      ),
      PlutoColumn(
        title: 'Status',
        field: 'col5',
        type: PlutoColumnType.text(),
        readOnly: true,
        renderer: (PlutoColumnRendererContext ctx) {
          Color textColor;

          switch (ctx.cell.value) {
            case 'ACTIVE':
              textColor = Colors.green;
              break;
            case 'INACTIVE':
              textColor = Colors.orange;
              break;
            case 'BANNED':
              textColor = Colors.red;
              break;
            case 'DELETED':
              textColor = Colors.grey;
              break;
            default:
              textColor = Colors.grey;
          }

          return Text(
            ctx.column.type.applyFormat(ctx.cell.value),
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          );
        },
      ),
      PlutoColumn(
        title: 'Updated',
        field: 'col6',
        type: PlutoColumnType.text(),
        readOnly: true,
      ),
      PlutoColumn(
        title: 'Created',
        field: 'col7',
        type: PlutoColumnType.text(),
        readOnly: true,
      ),
      //Ban
      PlutoColumn(
        title: Constants.BAN,
        field: 'col8',
        type: PlutoColumnType.text(),
        readOnly: true,
        enableFilterMenuItem: false,
        renderer: (rendererContext) {
          final phone = rendererContext.row.cells['col2']?.value as String?;
          if (phone == null || phone.isEmpty) {
            return const Text("No phone number");
          }

          final bool isDeleted = rendererContext.row.cells['col9']?.value ==
              Constants.DELETED;
          final bool isBanned = rendererContext.cell.value ==
              Constants.BANNED;

          final String confirmationText = isBanned
              ? "Do you really want to unban this user?"
              : "Do you really want to ban this user?";

          return ElevatedButton(
            onPressed: isDeleted ? null :
                () async {
              final bool? confirm = await AppAlertDialogYesNo.showAlert(
                context: context,
                title: "Confirmation",
                content: confirmationText,
                yesText: "Confirm",
                noText: "Cancel",
              );

              if (confirm != true) return;

              final newStatus = isBanned
                  ? UserOrCompanyStatus.INACTIVE
                  : UserOrCompanyStatus.BANNED;

              await cubit.changeUserStatus(phone: phone, status: newStatus);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isBanned ? Colors.red : Colors.green,
              foregroundColor: Colors.white,
            ),
            child: Text(isBanned ? Constants.BANNED : Constants.BAN),
          );
        },
      ),
      //Delete
      PlutoColumn(
        title: Constants.DELETE,
        field: 'col9',
        type: PlutoColumnType.text(),
        readOnly: true,
        enableFilterMenuItem: false,
        renderer: (rendererContext) {
          final phone = rendererContext.row.cells['col2']?.value as String?;
          if (phone == null || phone.isEmpty) {
            return const Text("No phone number");
          }

          final bool isDeleted = rendererContext.cell.value ==
              Constants.DELETED;
          final String confirmationText = isDeleted
              ? "Do you really want to restore this user?"
              : "Do you really want to delete this user?";

          return ElevatedButton(
            onPressed: () async {
              final bool? confirm = await AppAlertDialogYesNo.showAlert(
                context: context,
                title: "Confirmation",
                content: confirmationText,
                yesText: "Confirm",
                noText: "Cancel",
              );

              if (confirm != true) return;

              await cubit.changeUserDeletionStatus(phone: phone, deleted: !isDeleted);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isDeleted ? Colors.grey : Colors.blueGrey,
              foregroundColor: Colors.white,
            ),
            child: Text(isDeleted ? Constants.DELETED : Constants.DELETE),
          );
        },
      ),
    ];
  }

  @override
  void initState(){
    super.initState();

    cubit = context.read<MainPageCubit>();
  }

  void refreshGrid() {
    final newRows = cubit.state.searchUserData != null ? buildUserRow() : <PlutoRow>[]; // Ensure empty list

    stateManager.removeAllRows();
    if (newRows.isNotEmpty) {
      stateManager.appendRows(newRows);
    }

    stateManager.notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MainPageCubit, MainPageState>(
      listener: (context, state){
        if(state.refreshWindow){
          refreshGrid();
        }
      },
      child: PlutoGrid(
          columns: buildColumns(context),
          rows: [],
          configuration: const PlutoGridConfiguration(),
          onLoaded: (PlutoGridOnLoadedEvent event) async {
            stateManager = event.stateManager;
            stateManager.setShowColumnFilter(false);
          },
          onChanged: (PlutoGridOnChangedEvent event) {
            print("Row changed: ${event.row.cells}");
          },
      ),
    );
  }
}

class CompanySearchGridView extends StatefulWidget{
  const CompanySearchGridView({super.key});

  @override
  State<CompanySearchGridView> createState()  => _CompanySearchGridView();
}

class _CompanySearchGridView extends State<CompanySearchGridView> {
  late PlutoGridStateManager stateManager;

  late MainPageCubit cubit;

  List<PlutoRow> buildRow() {
    final company = cubit.state.searchCompanyData;

    if (company == null) {
      return [];
    }

    return [
      PlutoRow(cells: {
        'col1': PlutoCell(value: company.companyId.toString()),
        'col2': PlutoCell(value: company.companyName ?? ''),
        'col3': PlutoCell(value: company.phoneNumber ?? ''),
        'col4': PlutoCell(value: company.logoUrl ?? ''),
        'col5': PlutoCell(value: company.rating ?? ''),
        'col6': PlutoCell(value: company.workingHours ?? ''),
        'col7': PlutoCell(value: company.status.value),
        'col8': PlutoCell(value: company.formatDateTime(company.updatedAt)),
        'col9': PlutoCell(value: company.formatDateTime(company.createdAt)),
        'col10': PlutoCell(
            value: company.isBanned() ? Constants.BANNED : Constants.BAN),
        'col11': PlutoCell(
            value: company.deleted == true ? Constants.DELETED : Constants.DELETE),
      })
    ];
  }

  List<PlutoColumn> buildColumns(BuildContext context) {
    return [
      PlutoColumn(
        title: 'Id',
        field: 'col1',
        type: PlutoColumnType.text(),
        readOnly: true,
      ),
      PlutoColumn(
        title: 'Company name',
        field: 'col2',
        type: PlutoColumnType.text(),
        readOnly: true,
      ),
      PlutoColumn(
        title: 'Phone number',
        field: 'col3',
        type: PlutoColumnType.text(),
        readOnly: true,
      ),
      PlutoColumn(
        title: 'Logo',
        field: 'col4',
        type: PlutoColumnType.text(),
        readOnly: true,
      ),
      PlutoColumn(
        title: 'Rating',
        field: 'col5',
        type: PlutoColumnType.text(),
        readOnly: true,
      ),
      PlutoColumn(
        title: 'Working hours',
        field: 'col6',
        type: PlutoColumnType.text(),
        readOnly: true,
      ),
      PlutoColumn(
        title: 'Status',
        field: 'col7',
        type: PlutoColumnType.text(),
        readOnly: true,
        renderer: (PlutoColumnRendererContext ctx) {
          Color textColor;

          switch (ctx.cell.value) {
            case 'ACTIVE':
              textColor = Colors.green;
              break;
            case 'INACTIVE':
              textColor = Colors.orange;
              break;
            case 'BANNED':
              textColor = Colors.red;
              break;
            default:
              textColor = Colors.grey;
          }

          return Text(
            ctx.column.type.applyFormat(ctx.cell.value),
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          );
        },
      ),
      PlutoColumn(
        title: 'Updated',
        field: 'col8',
        type: PlutoColumnType.text(),
        readOnly: true,
      ),
      PlutoColumn(
        title: 'Created',
        field: 'col9',
        type: PlutoColumnType.text(),
        readOnly: true,
      ),
      //Ban
      PlutoColumn(
        title: Constants.BAN,
        field: 'col10',
        type: PlutoColumnType.text(),
        readOnly: true,
        enableFilterMenuItem: false,
        renderer: (rendererContext) {
          final phone = rendererContext.row.cells['col3']?.value as String?;
          if (phone == null || phone.isEmpty) {
            return const Text("No phone number");
          }

          final bool isDeleted = rendererContext.row.cells['col11']?.value ==
              Constants.DELETED;
          final bool isBanned = rendererContext.cell.value ==
              Constants.BANNED;

          final String confirmationText = isBanned
              ? "Do you really want to unban this company?"
              : "Do you really want to ban this company?";

          return ElevatedButton(
            onPressed: isDeleted ? null :
                () async {
              final bool? confirm = await AppAlertDialogYesNo.showAlert(
                context: context,
                title: "Confirmation",
                content: confirmationText,
                yesText: "Confirm",
                noText: "Cancel",
              );

              if (confirm != true) return;

              final newStatus = isBanned
                  ? UserOrCompanyStatus.INACTIVE
                  : UserOrCompanyStatus.BANNED;

              await cubit.changeCompanyStatus(
                  phone: phone, status: newStatus);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isBanned ? Colors.red : Colors.green,
              foregroundColor: Colors.white,
            ),
            child: Text(isBanned ? Constants.BANNED : Constants.BAN),
          );
        },
      ),
      //Delete
      PlutoColumn(
        title: Constants.DELETE,
        field: 'col11',
        type: PlutoColumnType.text(),
        readOnly: true,
        enableFilterMenuItem: false,
        renderer: (rendererContext) {
          final phone = rendererContext.row.cells['col3']?.value as String?;
          if (phone == null || phone.isEmpty) {
            return const Text("No phone number");
          }

          final bool isDeleted = rendererContext.cell.value ==
              Constants.DELETED;
          final String confirmationText = isDeleted
              ? "Do you really want to restore this company?"
              : "Do you really want to delete this company?";

          return ElevatedButton(
            onPressed: () async {
              final bool? confirm = await AppAlertDialogYesNo.showAlert(
                context: context,
                title: "Confirmation",
                content: confirmationText,
                yesText: "Confirm",
                noText: "Cancel",
              );

              if (confirm != true) return;

              await cubit.changeCompanyDeletionStatus(
                  phone: phone, deleted: !isDeleted);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isDeleted ? Colors.grey : Colors.blueGrey,
              foregroundColor: Colors.white,
            ),
            child: Text(isDeleted ? Constants.DELETED : Constants.DELETE),
          );
        },
      ),
    ];
  }

  @override
  void initState(){
    super.initState();

    cubit = context.read<MainPageCubit>();
  }

  void refreshGrid() {
    final newRows = cubit.state.searchCompanyData != null ? buildRow() : <PlutoRow>[]; // Ensure empty list

    stateManager.removeAllRows();
    if (newRows.isNotEmpty) {
      stateManager.appendRows(newRows);
    }

    stateManager.notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MainPageCubit, MainPageState>(
      listener: (context, state){
        if(state.refreshWindow){
          refreshGrid();
        }
      },
      child: PlutoGrid(
        columns: buildColumns(context),
        rows: [],
        configuration: const PlutoGridConfiguration(),
        onLoaded: (PlutoGridOnLoadedEvent event) async {
          stateManager = event.stateManager;
          stateManager.setShowColumnFilter(false);
        },
        onChanged: (PlutoGridOnChangedEvent event) {
          print("Row changed: ${event.row.cells}");
        },
      ),
    );
  }
}