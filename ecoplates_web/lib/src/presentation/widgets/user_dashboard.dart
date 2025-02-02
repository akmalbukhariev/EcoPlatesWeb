import 'package:ecoplates_web/src/data/model/pagination_info.dart';
import 'package:ecoplates_web/src/presentation/widgets/simple_account_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../constant/user_or_company_status.dart';
import '../../constant/constants.dart';
import '../../data/data_provider/http_service_user.dart';
import '../../data/http_response/response_user_info.dart';
import '../../data/http_response/user_data_response.dart';
import '../../data/model/user_info.dart';
import 'build_summary_card.dart';
import 'loading_overlay_widget.dart';

class UserDashBoard extends StatefulWidget{
  const UserDashBoard({super.key});

  @override
  State<UserDashBoard> createState()  => _UserDashBoard();
}

class _UserDashBoard extends State<UserDashBoard>{
  UserDataResponse? resultData;
  bool? isLoading;

  Future<void> fetchUserInfo() async {
    try {
      Paginationinfo data = Paginationinfo(pageSize: 10, offset: 0);
      ResponseUserInfo? response = await HttpServiceUser.getUserInfo(data: data);

      if (response != null && response.resultData != null) {
        setState(() {
          resultData = response.resultData;
          isLoading = false;
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
                  final cardWidth = availableWidth > 800 ? 200.0 : (availableWidth / 2) - 16;

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
                child: UserGridView(resultData: resultData),
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

  const UserGridView({super.key, this.resultData});

  @override
  State<UserGridView> createState()  => _UserGridView();
}

class _UserGridView extends State<UserGridView> {
  late PlutoGridStateManager stateManager;

  List<PlutoColumn> columns = [];

  /*
  Future<List<PlutoRow>> fetchUserInfo() async {
    final List<PlutoRow> result = [];

    try {
      //stateManager.setShowLoading(true);

      Paginationinfo data = Paginationinfo(pageSize: 10, offset: 0);
      ResponseUserInfo? response = await HttpServiceUser.getUserInfo(
          data: data);

      if (response != null && response.resultData != null) {

        final List<UserInfo> userInfoList = response.resultData!.users;

        result.addAll(
          userInfoList.map((user) {
            return PlutoRow(cells: {
              'col1': PlutoCell(value: user.userId.toString()),
              'col2': PlutoCell(value: user.firstName ?? ''),
              'col3': PlutoCell(value: user.lastName ?? ''),
              'col4': PlutoCell(value: user.status.value),
              'col5': PlutoCell(value: user.formatDateTime(user.updatedAt)),
              'col6': PlutoCell(value: user.formatDateTime(user.createdAt)),
              'col7': PlutoCell(
                  value: user.isBanned() ? Constants.BANNED : Constants.BAN),
              'col8': PlutoCell(
                  value: user.deleted == true ? Constants.DELETED : Constants
                      .DELETE),
            });
          }),
        );
      } else {
        print('Failed to fetch user data: ${response?.resultMsg}');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    } finally {
      //stateManager.setShowLoading(false);
    }

    return result;
  }
  */

  List<PlutoRow> _buildRows() {
    final users = widget.resultData?.users ?? [];
    return users.map((user) {
      return PlutoRow(cells: {
        'col1': PlutoCell(value: user.userId.toString()),
        'col2': PlutoCell(value: user.firstName ?? ''),
        'col3': PlutoCell(value: user.lastName ?? ''),
        'col4': PlutoCell(value: user.status.value),
        'col5': PlutoCell(value: user.formatDateTime(user.updatedAt)),
        'col6': PlutoCell(value: user.formatDateTime(user.createdAt)),
        'col7': PlutoCell(
            value: user.isBanned() ? Constants.BANNED : Constants.BAN),
        'col8': PlutoCell(
            value: user.deleted == true ? Constants.DELETED : Constants.DELETE),
      });
    }).toList();
  }

  @override
  void initState(){
    super.initState();

    columns.addAll([
      PlutoColumn(
        title: 'Id',
        field: 'col1',
        type: PlutoColumnType.text(),
        readOnly: true,
      ),
      PlutoColumn(
        title: 'First Name',
        field: 'col2',
        type: PlutoColumnType.text(),
        readOnly: true,
      ),
      PlutoColumn(
        title: 'Last Name',
        field: 'col3',
        type: PlutoColumnType.text(),
        readOnly: true,
      ),
      PlutoColumn(
        title: 'Status',
        field: 'col4',
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
        field: 'col5',
        type: PlutoColumnType.text(),
        readOnly: true,
      ),
      PlutoColumn(
        title: 'Created',
        field: 'col6',
        type: PlutoColumnType.text(),
        readOnly: true,
      ),
      PlutoColumn(
        title: Constants.BAN,
        field: 'col7',
        type: PlutoColumnType.text(),
        readOnly: true,
        enableFilterMenuItem: false,
        renderer: (rendererContext) {
          // Access the row's cells directly from the context
          final deleted = rendererContext.row.cells['deleted']?.value ?? false;  // Replace 'deleted' with your actual field
          final bool isBanned = rendererContext.cell.value == Constants.BANNED;

          return ElevatedButton(
            onPressed: (){

            },
            /*onPressed: deleted
                ? null  // Disable button if 'deleted' is true
                : () {
              // Toggle the banned status
              rendererContext.stateManager.changeCellValue(
                rendererContext.cell,
                isBanned ? Constants.BAN : Constants.BANNED,
              );
            },*/
            style: ElevatedButton.styleFrom(
              backgroundColor: isBanned ? Colors.red : Colors.green,
              foregroundColor: Colors.white,
            ),
            child: Text(isBanned ? Constants.BANNED : Constants.BAN),
          );
        },
      ),
      PlutoColumn(
        title: Constants.DELETE,
        field: 'col8',
        type: PlutoColumnType.text(),
        readOnly: true,
        enableFilterMenuItem: false,
        renderer: (rendererContext) {
          bool isDeleted = rendererContext.cell.value == Constants.DELETED;
          return ElevatedButton(
            onPressed: () {
              rendererContext.stateManager.changeCellValue(
                rendererContext.cell,
                isDeleted ? Constants.DELETE : Constants.DELETED,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isDeleted ? Colors.grey : Colors.blueGrey,
              foregroundColor: Colors.white,
            ),
            child: Text(isDeleted ? Constants.DELETED : Constants.DELETE),
          );
        },
      ),
    ]);
  }

  void _refreshGrid() {
    if (widget.resultData != null && stateManager != null) {
      final newRows = _buildRows();

      // Clear existing rows and add new ones
      stateManager.refRows.clear();
      stateManager.refRows.addAll(newRows);

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
          columns: columns,
          rows: _buildRows(),
          configuration: const PlutoGridConfiguration(),
          onLoaded: (PlutoGridOnLoadedEvent event) {
            stateManager = event.stateManager;
            stateManager.setShowColumnFilter(true);

            //stateManager.setShowLoading(true);
            /*
            fetchUserInfo().then((fetchedRows) {
              PlutoGridStateManager.initializeRowsAsync(
                columns,
                fetchedRows,
              ).then((value) {
                stateManager.refRows.addAll(value);

                //stateManager.setShowLoading(false);
              });
            });
            */
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