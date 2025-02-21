
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../blocs/main_page_cubit.dart';
import '../../../blocs/main_page_state.dart';
import '../loading_overlay_widget.dart';
import '../show_snack_bar.dart';

class NotificationDashBoard extends StatefulWidget{
  const NotificationDashBoard({super.key});

  @override
  State<NotificationDashBoard> createState() => _NotificationDashBoard();
}

class _NotificationDashBoard extends State<NotificationDashBoard> {

  late MainPageCubit cubit;

  @override
  void initState() {
    super.initState();

    cubit = context.read<MainPageCubit>();
  }

  Future<void> showNotificationDialog(BuildContext context) async {
    TextEditingController titleController = TextEditingController();
    TextEditingController messageController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocBuilder<MainPageCubit, MainPageState>(
            builder: (context, state){
              return Stack(
                children: [
                  AlertDialog(
                    title: const Text("New Message"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: titleController,
                          decoration: const InputDecoration(labelText: "Title"),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: messageController,
                          decoration: const InputDecoration(labelText: "Message"),
                          maxLines: 3,
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        child: const Text("Cancel"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      ElevatedButton(
                        child: const Text("Send"),
                        onPressed: () async {
                          String title = titleController.text;
                          String message = messageController.text;

                          if (title.isEmpty || message.isEmpty) {
                            ShowSnackBar(context: context, message: 'Please fill in all fields');
                          } else {
                            String strMsg = await cubit.sendNotification(title: title, message: message);
                            ShowSnackBar(context: context, message: strMsg);

                            Navigator.of(context).pop();
                          }
                        },
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white
                    ),
                    onPressed: (){
                      showNotificationDialog(context);
                    },
                    child: const Text('NEW MESSAGE'),
                  ),
                ),
                const SizedBox(height: 16.0),
                const Expanded(
                  child: NotificationGridView(),
                ),
              ],
            ),
          ],
        )
    );
  }
}

class NotificationGridView extends StatefulWidget{
  const NotificationGridView({super.key});

  @override
  State<NotificationGridView> createState()  => _NotificationGridView();
}

class _NotificationGridView extends State<NotificationGridView> {
  late PlutoGridStateManager stateManager;

  late MainPageCubit cubit;

  List<PlutoRow> buildRows() {
    final notify = cubit.state.notificationData ?? [];

    return notify.map((item) {
      return PlutoRow(cells: {
        'col1': PlutoCell(value: item.id?.toString() ?? ''),
        'col2': PlutoCell(value: item.message ?? ''),
        'col3': PlutoCell(value: item.status ?? 'N/A'),
        'col4': PlutoCell(value: item.formatDateTime(item.deliveryDate) ?? ''),
        'col5': PlutoCell(value: item.sends ?? ''),
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
        title: 'Message',
        field: 'col2',
        type: PlutoColumnType.text(),
        readOnly: true,
      ),
      PlutoColumn(
        title: 'Status',
        field: 'col3',
        type: PlutoColumnType.text(),
        readOnly: true,
        renderer: (PlutoColumnRendererContext ctx) {
          Color textColor;

          switch (ctx.cell.value) {
            case 'Completed':
              textColor = Colors.green;
              break;
            case 'Failed':
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
        title: 'Delivery date',
        field: 'col4',
        type: PlutoColumnType.text(),
        readOnly: true,
      ),
      PlutoColumn(
        title: 'Sends',
        field: 'col5',
        type: PlutoColumnType.text(),
        readOnly: true,
      ),
    ];
  }

  @override
  void initState(){
    super.initState();

    cubit = context.read<MainPageCubit>();
    cubit.fetchNotificationInfo();
  }

  void refreshGrid(){
    if (cubit.state.notificationData != null) {

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
          rows: buildRows(),
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