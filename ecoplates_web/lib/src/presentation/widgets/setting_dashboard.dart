
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../constant/constants.dart';
import '../../data/data_provider/http_service_admin.dart';
import '../../data/http_response/response_all_admin_info.dart';
import '../../data/http_response/response_info.dart';
import '../../data/model/admin_info.dart';
import 'AppAlertDialogYesNo.dart';
import 'loading_overlay_widget.dart';

class SettingDashBoard extends StatefulWidget{
  const SettingDashBoard({super.key});

  @override
  State<SettingDashBoard> createState()  => _SettingDashBoard();
}

class _SettingDashBoard extends State<SettingDashBoard> {
  List<AdminInfo>? resultData;
  bool? isLoading;

  Future<void> refreshDashboard() async {
    setState(() {
      isLoading = true;
    });
    await fetchUserInfo();
  }

  Future<void> fetchUserInfo() async {
    try {
      //Paginationinfo data = Paginationinfo(pageSize: 10, offset: 0);
      ResponseAllAdminInfo? response = await HttpServiceAdmin.getAllAdmins();

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
      print('Error fetching admin data: $e');
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
                const SizedBox(height: 16.0),
                Expanded(
                  child: SettingGridView(
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

class SettingGridView extends StatefulWidget{
  final List<AdminInfo>? resultData;
  final VoidCallback onRefresh;

  const SettingGridView({super.key, this.resultData, required this.onRefresh});

  @override
  State<SettingGridView> createState()  => _SettingGridView();
}

class _SettingGridView extends State<SettingGridView> {
  late PlutoGridStateManager stateManager;

  List<PlutoRow> _buildRows() {
    return widget.resultData?.map((admin) {
      return PlutoRow(cells: {
        'col1': PlutoCell(value: admin.id?.toString() ?? ''),
        'col2': PlutoCell(value: admin.adminId),
        'col3': PlutoCell(value: admin.adminRole.name),
        'col4': PlutoCell(value: admin.formatDateTime(admin.updatedAt)),
        'col5': PlutoCell(value: admin.formatDateTime(admin.createdAt)),
        'col6': PlutoCell(value: admin.deleted == true ? Constants.DELETED : Constants.DELETE),
      });
    }).toList() ?? [];
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
        title: 'Admin Id',
        field: 'col2',
        type: PlutoColumnType.text(),
        readOnly: true,
      ),
      PlutoColumn(
        title: 'Admin role',
        field: 'col3',
        type: PlutoColumnType.text(),
        readOnly: true,
      ),
      PlutoColumn(
        title: 'Updated',
        field: 'col4',
        type: PlutoColumnType.text(),
        readOnly: true,
      ),
      PlutoColumn(
        title: 'Created',
        field: 'col5',
        type: PlutoColumnType.text(),
        readOnly: true,
      ),
      //Delete
      PlutoColumn(
        title: Constants.DELETE,
        field: 'col6',
        type: PlutoColumnType.text(),
        readOnly: true,
        enableFilterMenuItem: false,
        renderer: (rendererContext) {
          final phone = rendererContext.row.cells['col2']?.value as String?;
          if (phone == null || phone.isEmpty) {
            return const Text("No admin id");
          }

          final bool isDeleted = rendererContext.cell.value ==
              Constants.DELETED;
          const String confirmationText = "Do you really want to delete this admin?";

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
                ResponseInfo? response = await HttpServiceAdmin.deleteAdminById(adminId: "");

                if (response != null) {
                  widget.onRefresh();
                } else {
                  print('Failed to update user deletion status: ${response
                      ?.resultMsg}');
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

      stateManager.removeAllRows();
      stateManager.appendRows(newRows);

      stateManager.notifyListeners();
    }
  }

  @override
  void didUpdateWidget(SettingGridView oldWidget) {
    super.didUpdateWidget(oldWidget);

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