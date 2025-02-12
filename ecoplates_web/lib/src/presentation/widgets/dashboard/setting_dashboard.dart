
import 'package:ecoplates_web/src/presentation/widgets/loading_overlay_widget.dart';
import 'package:ecoplates_web/src/presentation/widgets/show_snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../blocs/main_page_cubit.dart';
import '../../../blocs/main_page_state.dart';
import '../../../constant/constants.dart';
import '../app_alert_dialog_yesno.dart';

class SettingDashBoard extends StatefulWidget{
  const SettingDashBoard({super.key});

  @override
  State<SettingDashBoard> createState()  => _SettingDashBoard();
}

class _SettingDashBoard extends State<SettingDashBoard> {

  late MainPageCubit adminCubit;

  @override
  void initState() {
    super.initState();

    adminCubit = context.read<MainPageCubit>();
    adminCubit.fetchAllAdminInfo();
  }

  void showAddAdminPopup(BuildContext context) {
    final TextEditingController adminIdController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();
    String selectedRole = Constants.ADMIN_SUPER;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocBuilder<MainPageCubit, MainPageState>(
            builder: (context, state){
              return Stack(
                children: [
                  AlertDialog(
                    title: const Text('Add Admin'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: adminIdController,
                          decoration: const InputDecoration(
                            labelText: 'Admin ID',
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        /*DropdownButtonFormField<String>(
                          value: selectedRole,
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              selectedRole = newValue;
                            }
                          },
                          items: [Constants.ADMIN, Constants.ADMIN_SUPER]
                              .map((role) => DropdownMenuItem(
                            value: role,
                            child: Text(role),
                          ))
                              .toList(),
                          decoration: const InputDecoration(
                            labelText: 'Admin Role',
                          ),
                        ),*/
                        const SizedBox(height: 16.0),
                        TextField(
                          controller: passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 16.0),
                        TextField(
                          controller: confirmPasswordController,
                          decoration: const InputDecoration(
                            labelText: 'Confirm Password',
                          ),
                          obscureText: true,
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the popup
                        },
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          String adminId = adminIdController.text;
                          String password = passwordController.text;
                          String confirmPassword = confirmPasswordController.text;

                          if (adminId.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
                            ShowSnackBar(context: context, message: 'Please fill in all fields');
                          } else if (password != confirmPassword) {
                            ShowSnackBar(context: context, message: 'Passwords do not match');
                          } else {

                            String strMsg = await adminCubit.addAdmin(adminId: adminId, password: password, admin_role: selectedRole);
                            ShowSnackBar(context: context, message: strMsg);

                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                  if(state.isLoading)
                    const LoadingOverlayWidget()
                ],
              );
            }
        );
      },
    );
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
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: (){
                      showAddAdminPopup(context);
                    },
                    child: const Text('Add admin'),
                  ),
                ),
                const SizedBox(height: 16.0),
                const Expanded(
                  child: SettingGridView(),
                ),
              ],
            ),
          ],
        )
    );
  }
}

class SettingGridView extends StatefulWidget{
  const SettingGridView({super.key});

  @override
  State<SettingGridView> createState()  => _SettingGridView();
}

class _SettingGridView extends State<SettingGridView> {
  late PlutoGridStateManager stateManager;

  late MainPageCubit adminCubit;

  List<PlutoRow> _buildRows() {
    return adminCubit.state.adminData?.map((admin) {
      return PlutoRow(cells: {
        'col1': PlutoCell(value: admin.id?.toString() ?? ''),
        'col2': PlutoCell(value: admin.adminId),
        'col3': PlutoCell(value: admin.adminRole.name),
        //'col4': PlutoCell(value: admin.formatDateTime(admin.updatedAt)),
        'col5': PlutoCell(value: admin.formatDateTime(admin.createdAt)),
        'col6': PlutoCell(
            value: admin.deleted == true ? Constants.DELETED : Constants
                .DELETE),
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
      /*PlutoColumn(
        title: 'Updated',
        field: 'col4',
        type: PlutoColumnType.text(),
        readOnly: true,
      ),*/
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
          final id = rendererContext.row.cells['col2']?.value as String?;
          final admin_role = rendererContext.row.cells['col3']
              ?.value as String?;
          final isAdmin = admin_role == Constants.ADMIN;

          if (id == null || id.isEmpty) {
            return const Text("No admin id");
          }

          const String confirmationText = "Do you really want to delete this admin?";

          return ElevatedButton(
            onPressed: isAdmin ? null :
                () async {
              final bool? confirm = await AppAlertDialogYesNo.showAlert(
                context: context,
                title: "Confirmation",
                content: confirmationText,
                yesText: "Confirm",
                noText: "Cancel",
              );

              if (confirm != true) return;

              String msg = await adminCubit.deleteAdmin(adminId: id);
              ShowSnackBar(context: context, message: msg);

              /*try {
                ResponseInfo? response = await HttpServiceAdmin.deleteAdminById(
                    adminId: id);

                if (response != null) {
                  widget.onRefresh();
                } else {
                  ShowSnackBar(context: context,
                      message: 'Failed to update user deletion status: ${response
                          ?.resultMsg}');
                }
              } catch (e) {
                ShowSnackBar(context: context,
                    message: 'Error updating user deletion status: $e');
              }*/
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(Constants.DELETE),
          );
        },
      ),
    ];
  }

  @override
  void initState() {
    super.initState();

    adminCubit = context.read<MainPageCubit>();
  }

  void refreshGrid() {
    if (adminCubit.state.adminData != null) {
      final newRows = _buildRows();

      stateManager.removeAllRows();
      stateManager.appendRows(newRows);

      stateManager.notifyListeners();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MainPageCubit, MainPageState>(
        listener: (context, state) {
          if (state.refreshWindow) {
            refreshGrid();
          }
        },
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
          /*createFooter: (stateManager) {
            stateManager.setPageSize(100, notify: false);
            return PlutoPagination(stateManager);
          },*/
        )
    );
  }
}