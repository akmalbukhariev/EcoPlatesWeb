import 'dart:js';
import 'dart:js';

import 'package:ecoplates_web/src/data/http_response/response_change_deletion_status.dart';
import 'package:ecoplates_web/src/data/model/change_user_status.dart';
import 'package:ecoplates_web/src/data/model/pagination_info.dart';
import 'package:ecoplates_web/src/presentation/widgets/simple_account_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../constant/user_or_company_status.dart';
import '../../constant/constants.dart';
import '../../data/data_provider/http_service_user.dart';
import '../../data/http_response/response_change_user_status.dart';
import '../../data/http_response/response_user_info.dart';
import '../../data/http_response/user_data_response.dart';
import '../../data/model/change_user_deletion_status.dart';
import 'AppAlertDialogYesNo.dart';
import 'build_summary_card.dart';
import 'loading_overlay_widget.dart';

class UserDashBoard extends StatefulWidget{
  const UserDashBoard({super.key});

  @override
  State<UserDashBoard> createState()  => _UserDashBoard();
}

class _UserDashBoard extends State<UserDashBoard> {
  UserDataResponse? resultData;
  bool? isLoading;

  Future<void> refreshDashboard() async {
    setState(() {
      isLoading = true;
    });
    await fetchUserInfo();
  }

  Future<void> fetchUserInfo() async {
    try {
      Paginationinfo data = Paginationinfo(pageSize: 10, offset: 0);
      ResponseUserInfo? response = await HttpServiceUser.getUserInfo(
          data: data);

      setState(() {
        isLoading = false;
      });

      if (response != null && response.resultData != null) {
        setState(() {
          resultData = response.resultData;
        });
      } else {
        print('Failed to fetch user data: ${response?.resultMsg}');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    isLoading = true;
    fetchUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                            value: "${resultData?.total ?? 0}",
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
                            value: "${resultData?.activeUsers ?? 0}",
                            percentage: resultData?.activePercentage ?? "0%",
                            percentageColor: Colors.green,
                            description: "The number of active users",
                          ),
                        ),
                        SizedBox(
                          width: cardWidth,
                          child: buildSummaryCard(
                            title: "Inactive Users",
                            titleColor: Colors.orange,
                            value: "${resultData?.inactiveUsers ?? 0}",
                            percentage: resultData?.inactivePercentage ?? "0%",
                            percentageColor: Colors.orange,
                            description: "The number of inactive users",
                          ),
                        ),
                        SizedBox(
                          width: cardWidth,
                          child: buildSummaryCard(
                            title: "Banned Users",
                            titleColor: Colors.red,
                            value: "${resultData?.bannedUsers ?? 0}",
                            percentage: resultData?.bannedPercentage ?? "0%",
                            percentageColor: Colors.red,
                            description: "The number of banned users",
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: UserGridView(
                    resultData: resultData,
                    onRefresh: refreshDashboard,
                  ),
                  //child: UserGridWidget(),
                ),
              ],
            ),
            if(isLoading!)
              const LoadingOverlayWidget()
          ],
        )
    );
  }
}

class UserGridView extends StatefulWidget{
  final UserDataResponse? resultData;
  final VoidCallback onRefresh;

  const UserGridView({super.key, this.resultData, required this.onRefresh});

  @override
  State<UserGridView> createState()  => _UserGridView();
}

class _UserGridView extends State<UserGridView> {
  late PlutoGridStateManager stateManager;

  List<PlutoColumn> columns = [];
  final List<PlutoRow> rows = [];

  List<PlutoRow> _buildRows() {
    final users = widget.resultData?.users ?? [];

    return users.map((user) {
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
    }).toList();
  }

  List<PlutoColumn> _buildColumns(BuildContext context) {
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
      PlutoColumn(
        title: Constants.BAN,
        field: 'col8',
        type: PlutoColumnType.text(),
        readOnly: true,
        enableFilterMenuItem: false,
        renderer: (rendererContext) {
          try {
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

                try {
                  final newStatus = isBanned
                      ? UserOrCompanyStatus.INACTIVE
                      : UserOrCompanyStatus.BANNED;
                  ChangeUserStatus data = ChangeUserStatus(
                    phoneNumber: phone,
                    status: newStatus,
                  );

                  ResponseChangeUserStatus? response = await HttpServiceUser
                      .changeUserStatus(data: data);

                  if (response != null) {
                    widget.onRefresh(); // Trigger the refresh
                  } else {
                    print(
                        'Failed to update user status: ${response?.resultMsg}');
                  }
                } catch (e) {
                  print('Error updating user status: $e');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isBanned ? Colors.red : Colors.green,
                foregroundColor: Colors.white,
              ),
              child: Text(isBanned ? Constants.BANNED : Constants.BAN),
            );
          }
          catch(e, stackTrace){
            print('Error rendering column: ${rendererContext.column.field}, Error: $e');
            print(stackTrace);
            return const Text("Error rendering");
          }
        },
      ),
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

          final bool isDeleted = rendererContext.cell.value == Constants.DELETED;
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

              try {
                ChangeUserDeletionStatus data = ChangeUserDeletionStatus(
                  phoneNumber: phone,
                  deleted: !isDeleted,
                );

                ResponseChangeUserDeletionStatus? response = await HttpServiceUser.changeUserDeletionStatus(data: data);

                if (response != null) {
                  widget.onRefresh();
                } else {
                  print('Failed to update user deletion status: ${response?.resultMsg}');
                }
              } catch (e) {
                print('Error updating user deletion status: $e');
              }
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
  }

  void _refreshGrid() {
    if (widget.resultData != null) {
      final newRows = _buildRows();

      // Clear existing rows and add new ones
      stateManager.removeAllRows();
      stateManager.appendRows(newRows);

      // Notify the grid to update
      stateManager.notifyListeners();
    }
  }

  @override
  void didUpdateWidget(UserGridView oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Refresh the grid if new data is provided
    if (oldWidget.resultData != widget.resultData) {
      _refreshGrid();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: PlutoGrid(
          columns: _buildColumns(context),
          rows: _buildRows(),
          configuration: const PlutoGridConfiguration(),
          onLoaded: (PlutoGridOnLoadedEvent event) async {
            stateManager = event.stateManager;
            stateManager.setShowColumnFilter(true);
          },
          onChanged: (PlutoGridOnChangedEvent event) {
            print("Row changed: ${event.row.cells}");
          },
          createFooter: (stateManager) {
            stateManager.setPageSize(100, notify: false);
            return PlutoPagination(stateManager);
          },
        ),
      ),
    );
  }
}