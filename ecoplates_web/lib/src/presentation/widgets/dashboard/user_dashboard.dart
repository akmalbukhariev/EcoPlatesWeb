
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

class UserDashBoard extends StatefulWidget{
  const UserDashBoard({super.key});

  @override
  State<UserDashBoard> createState()  => _UserDashBoard();
}

class _UserDashBoard extends State<UserDashBoard> {

  late MainPageCubit userCubit;

  @override
  void initState() {
    super.initState();

    userCubit = context.read<MainPageCubit>();
    userCubit.fetchUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MainPageCubit, MainPageState>(
      listener: (context, state){
        if(state.refreshWindow){
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
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final availableWidth = constraints.maxWidth;
                      final cardWidth = availableWidth > 800
                          ? 200.0
                          : (availableWidth / 2) - 16;

                      return Wrap(
                        spacing: 16.0,
                        runSpacing: 16.0,
                        children: [
                          SizedBox(
                            width: cardWidth,
                            child: buildSummaryCard(
                              title: "Users",
                              titleColor: Colors.blue,
                              value: "${userCubit.state.userData?.total ?? 0}",
                              percentage: "",
                              percentageColor: Colors.transparent,
                              description: "The number of users",
                            ),
                          ),
                          SizedBox(
                            width: cardWidth,
                            child: buildSummaryCard(
                              title: "Active Users",
                              titleColor: Colors.green,
                              value: "${userCubit.state.userData?.activeUsers ?? 0}",
                              percentage: userCubit.state.userData?.activePercentage ?? "0%",
                              percentageColor: Colors.green,
                              description: "The number of active users",
                            ),
                          ),
                          SizedBox(
                            width: cardWidth,
                            child: buildSummaryCard(
                              title: "Inactive Users",
                              titleColor: Colors.orange,
                              value: "${userCubit.state.userData?.inactiveUsers ?? 0}",
                              percentage: userCubit.state.userData?.inactivePercentage ?? "0%",
                              percentageColor: Colors.orange,
                              description: "The number of inactive users",
                            ),
                          ),
                          SizedBox(
                            width: cardWidth,
                            child: buildSummaryCard(
                              title: "Banned Users",
                              titleColor: Colors.red,
                              value: "${userCubit.state.userData?.bannedUsers ?? 0}",
                              percentage: userCubit.state.userData?.bannedPercentage ?? "0%",
                              percentageColor: Colors.red,
                              description: "The number of banned users",
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16.0),
                  const Expanded(
                    child: UserGridView(),
                  ),
                ],
              ),
            ],
          )
      ),
    );
  }
}

class UserGridView extends StatefulWidget{
  const UserGridView({super.key});

  @override
  State<UserGridView> createState()  => _UserGridView();
}

class _UserGridView extends State<UserGridView> {
  late PlutoGridStateManager stateManager;

  late MainPageCubit userCubit;

  List<PlutoRow> buildRows() {
    final users = userCubit.state.userData?.users ?? [];

    return users.map((user) {
      return PlutoRow(cells: {
        'col1': PlutoCell(value: user.userId?.toString() ?? ''),
        'col2': PlutoCell(value: user.phoneNumber ?? 'No Phone'),
        'col3': PlutoCell(value: user.firstName ?? 'N/A'),
        'col4': PlutoCell(value: user.lastName ?? 'N/A'),
        'col5': PlutoCell(value: user.deleted == true ? Constants.DELETED.toUpperCase() : user.status.value ?? 'Unknown'),
        'col6': PlutoCell(value: user.formatDateTime(user.updatedAt) ?? ''),
        'col7': PlutoCell(value: user.formatDateTime(user.createdAt) ?? ''),
        'col8': PlutoCell(value: user.isBanned() ? Constants.BANNED : Constants.BAN),
        'col9': PlutoCell(value: user.deleted == true ? Constants.DELETED : Constants.DELETE),
      });
    }).toList();
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

              await userCubit.changeUserStatus(phone: phone, status: newStatus);
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

              await userCubit.changeUserDeletionStatus(phone: phone, deleted: !isDeleted);
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

  Future<PlutoLazyPaginationResponse> fetch(PlutoLazyPaginationRequest request) async {
    const pageSize = Constants.PAGE_SIZE;
    final offset = (request.page - 1) * pageSize;

    userCubit.setPageOffset(pageOffset: offset);
    await userCubit.fetchUserInfo();

    final users = userCubit.state.userData?.users ?? [];
    final rows = users.map((user) {
      return PlutoRow(cells: {
        'col1': PlutoCell(value: user.userId?.toString() ?? ''),
        'col2': PlutoCell(value: user.phoneNumber ?? 'No Phone'),
        'col3': PlutoCell(value: user.firstName ?? 'N/A'),
        'col4': PlutoCell(value: user.lastName ?? 'N/A'),
        'col5': PlutoCell(value: user.status.value ?? 'Unknown'),
        'col6': PlutoCell(value: user.formatDateTime(user.updatedAt) ?? ''),
        'col7': PlutoCell(value: user.formatDateTime(user.createdAt) ?? ''),
        'col8': PlutoCell(value: user.isBanned() ? Constants.BANNED : Constants.BAN),
        'col9': PlutoCell(value: user.deleted == true ? Constants.DELETED : Constants.DELETE),
      });
    }).toList() ?? [];

    final totalRows = userCubit.state.userData?.total ?? 0;
    final totalPage = (totalRows / pageSize).ceil();

    return PlutoLazyPaginationResponse(
      totalPage: totalPage,
      rows: rows,
    );
  }

  @override
  void initState(){
    super.initState();

    userCubit = context.read<MainPageCubit>();
  }

  void refreshGrid(){
    if (userCubit.state.userData != null) {

      final newRows = buildRows();

      stateManager.removeAllRows();
      stateManager.appendRows(newRows);

      stateManager.notifyListeners();
    }
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
          stateManager.setShowColumnFilter(true);
        },
        onChanged: (PlutoGridOnChangedEvent event) {
          print("Row changed: ${event.row.cells}");
        },
        /*createFooter: (stateManager) {
          stateManager.setPageSize(100, notify: false);
          return PlutoPagination(stateManager);
        },
        */
          createFooter: (stateManager) {
            return PlutoLazyPagination(
              initialPage: 1,
              initialFetch: true,
              fetchWithSorting: true,
              fetchWithFiltering: true,
              fetch: fetch,
              stateManager: stateManager,
            );
          }
      ),
    );
  }
}