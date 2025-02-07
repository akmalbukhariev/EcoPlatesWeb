import 'dart:math';

import 'package:ecoplates_web/src/constant/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../constant/user_or_company_status.dart';
import '../../data/data_provider/http_service_company.dart';
import '../../data/http_response/company_data_response.dart';
import '../../data/http_response/response_change_deletion_status.dart';
import '../../data/http_response/response_change_user_status.dart';
import '../../data/http_response/response_company_info.dart';
import '../../data/model/change_user_deletion_status.dart';
import '../../data/model/change_user_status.dart';
import '../../data/model/pagination_info.dart';
import 'AppAlertDialogYesNo.dart';
import 'build_summary_card.dart';
import 'loading_overlay_widget.dart';

class CompanyDashBoard extends StatefulWidget{
  const CompanyDashBoard({super.key});

  @override
  State<CompanyDashBoard> createState()  => _CompanyDashBoard();
}

class _CompanyDashBoard extends State<CompanyDashBoard>{

  CompanyDataResponse? resultData;
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
      ResponseCompanyInfo? response = await HttpServiceCompany.getUserInfo(
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
                    final cardWidth = availableWidth > 800 ? 200.0 : (availableWidth / 2) - 16;

                    return Wrap(
                      spacing: 16.0,
                      runSpacing: 16.0,
                      children: [
                        SizedBox(
                          width: cardWidth,
                          child: buildSummaryCard(
                            title: "Companies",
                            titleColor: Colors.blue,
                            value: "${resultData?.total ?? 0}",
                            percentage: "",
                            percentageColor: Colors.transparent,
                            description: "The number of companies",
                          ),
                        ),
                        SizedBox(
                          width: cardWidth,
                          child: buildSummaryCard(
                            title: "Active Companies",
                            titleColor: Colors.green,
                            value: "${resultData?.activeUsers ?? 0}",
                            percentage: resultData?.activePercentage ?? "0%",
                            percentageColor: Colors.green,
                            description: "The number of active companies",
                          ),
                        ),
                        SizedBox(
                          width: cardWidth,
                          child: buildSummaryCard(
                            title: "Inactive Companies",
                            titleColor: Colors.orange,
                            value: "${resultData?.inactiveUsers ?? 0}",
                            percentage: resultData?.inactivePercentage ?? "0%",
                            percentageColor: Colors.orange,
                            description: "The number of inactive companies",
                          ),
                        ),
                        SizedBox(
                          width: cardWidth,
                          child: buildSummaryCard(
                            title: "Banned Companies",
                            titleColor: Colors.red,
                            value: "${resultData?.bannedUsers ?? 0}",
                            percentage: resultData?.bannedPercentage ?? "0%",
                            percentageColor: Colors.red,
                            description: "The number of banned companies",
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: CompanyGridView(
                    resultData: resultData,
                    onRefresh: refreshDashboard,
                  ),
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

class CompanyGridView extends StatefulWidget{
  final CompanyDataResponse? resultData;
  final VoidCallback onRefresh;

  const CompanyGridView({super.key, this.resultData, required this.onRefresh});

  @override
  State<CompanyGridView> createState()  => _CompanyGridView();
}

class _CompanyGridView extends State<CompanyGridView> {
  late PlutoGridStateManager stateManager;

  List<PlutoRow> _buildRows() {
    final companies = widget.resultData?.users ?? [];

    return companies.map((item) {
      return PlutoRow(cells: {
        'col1': PlutoCell(value: item.companyId.toString()),
        'col2': PlutoCell(value: item.companyName ?? ''),
        'col3': PlutoCell(value: item.phoneNumber ?? ''),
        'col4': PlutoCell(value: item.logoUrl ?? ''),
        'col5': PlutoCell(value: item.rating ?? ''),
        'col6': PlutoCell(value: item.workingHours ?? ''),
        'col7': PlutoCell(value: item.status.value),
        'col8': PlutoCell(value: item.formatDateTime(item.updatedAt)),
        'col9': PlutoCell(value: item.formatDateTime(item.createdAt)),
        'col10': PlutoCell(value: item.isBanned() ? Constants.BANNED : Constants.BAN),
        'col11': PlutoCell(value: item.deleted == true ?  Constants.DELETED : Constants.DELETE),
      });
    }).toList();
  }

  List<PlutoColumn> _buildColumns(BuildContext context){
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

                  try {
                    final newStatus = isBanned
                        ? UserOrCompanyStatus.INACTIVE
                        : UserOrCompanyStatus.BANNED;
                    ChangeUserStatus data = ChangeUserStatus(
                      phoneNumber: phone,
                      status: newStatus,
                    );

                    ResponseChangeUserStatus? response = await HttpServiceCompany
                        .changeUserStatus(data: data);

                    if (response != null) {
                      widget.onRefresh(); // Trigger the refresh
                    } else {
                      print(
                          'Failed to update company status: ${response?.resultMsg}');
                    }
                  } catch (e) {
                    print('Error updating company status: $e');
                  }

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

              try {
                ChangeUserDeletionStatus data = ChangeUserDeletionStatus(
                  phoneNumber: phone,
                  deleted: !isDeleted,
                );

                ResponseChangeUserDeletionStatus? response = await HttpServiceCompany
                    .changeUserDeletionStatus(data: data);

                if (response != null) {
                  widget.onRefresh();
                } else {
                  print('Failed to update company deletion status: ${response
                      ?.resultMsg}');
                }
              } catch (e) {
                print('Error updating company deletion status: $e');
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

      stateManager.removeAllRows();
      stateManager.appendRows(newRows);

      stateManager.notifyListeners();
    }
  }

  @override
  void didUpdateWidget(CompanyGridView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.resultData != widget.resultData) {
      _refreshGrid();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PlutoGrid(
      columns: _buildColumns(context),
      rows: _buildRows(),
      configuration: const PlutoGridConfiguration(),
      onLoaded: (PlutoGridOnLoadedEvent event) {
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
    );
  }
}