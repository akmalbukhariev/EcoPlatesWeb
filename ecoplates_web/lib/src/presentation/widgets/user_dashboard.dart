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
import '../../data/model/user_info.dart';
import 'build_summary_card.dart';

/*
final List<UserInfo> userData = [
  UserInfo(
    userId: 1,
    phoneNumber: '+1234567890',
    email: 'john.doe@example.com',
    firstName: 'John',
    lastName: 'Doe',
    fullName: 'John Doe',
    locationLatitude: 37.7749,
    locationLongitude: -122.4194,
    profilePictureUrl: 'https://via.placeholder.com/50',
    passwordHash: 'hash1',
    status: UserOrCompanyStatus.ACTIVE,
    updatedAt: DateTime.now(),
    createdAt: DateTime.now(),
    deleted: false,
  ),
  UserInfo(
    userId: 2,
    phoneNumber: '+9876543210',
    email: 'jane.doe@example.com',
    firstName: 'Jane',
    lastName: 'Doe',
    fullName: 'Jane Doe',
    locationLatitude: 34.0522,
    locationLongitude: -118.2437,
    profilePictureUrl: 'https://via.placeholder.com/50',
    passwordHash: 'hash2',
    status: UserOrCompanyStatus.INACTIVE,
    updatedAt: DateTime.now(),
    createdAt: DateTime.now(),
    deleted: false,
  ),
  UserInfo(
    userId: 3,
    phoneNumber: '+29876543210',
    email: 'jane.doe@example2.com',
    firstName: 'Akmal',
    lastName: 'Buxariev',
    fullName: 'Jane Doe',
    locationLatitude: 34.0522,
    locationLongitude: -118.2437,
    profilePictureUrl: 'https://via.placeholder.com/50',
    passwordHash: 'hash2',
    status: UserOrCompanyStatus.BANNED,
    updatedAt: DateTime.now(),
    createdAt: DateTime.now(),
    deleted: false,
  ),
  UserInfo(
    userId: 4,
    phoneNumber: '+19876543210',
    email: 'jane.doe@example3.com',
    firstName: 'Akmal',
    lastName: 'Tillaev',
    fullName: 'Jane Doe',
    locationLatitude: 34.0522,
    locationLongitude: -118.2437,
    profilePictureUrl: 'https://via.placeholder.com/50',
    passwordHash: 'hash2',
    status: UserOrCompanyStatus.BANNED,
    updatedAt: DateTime.now(),
    createdAt: DateTime.now(),
    deleted: false,
  ),
  UserInfo(
    userId: 5,
    phoneNumber: '+19876543210',
    email: 'jane.doe@example3.com',
    firstName: 'Iqbol',
    lastName: 'Tillaev',
    fullName: 'Jane Doe',
    locationLatitude: 34.0522,
    locationLongitude: -118.2437,
    profilePictureUrl: 'https://via.placeholder.com/50',
    passwordHash: 'hash2',
    status: UserOrCompanyStatus.NONE,
    updatedAt: DateTime.now(),
    createdAt: DateTime.now(),
    deleted: true,
  ),
];
*/
class UserDashBoard extends StatefulWidget{
  const UserDashBoard({super.key});

  @override
  State<UserDashBoard> createState()  => _UserDashBoard();
}

class _UserDashBoard extends State<UserDashBoard>{
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
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
                      value: "4520",
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
                      value: "3200",
                      percentage: "70%",
                      percentageColor: Colors.green,
                      description: "The number of active users",
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: buildSummaryCard(
                      title: "Inactive Users",
                      titleColor: Colors.orange,
                      value: "1000",
                      percentage: "22%",
                      percentageColor: Colors.orange,
                      description: "The number of inactive users",
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: buildSummaryCard(
                      title: "Banned Users",
                      titleColor: Colors.red,
                      value: "320",
                      percentage: "8%",
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
            child: UserGridView(),
            //child: UserGridWidget(),
          ),
        ],
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

  final List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];

  Future<void> fetchUserInfo() async {
    if (stateManager == null) {
      print("State manager not initialized yet.");
      return;
    }

    stateManager.setShowLoading(true);

    try {
      Paginationinfo data = Paginationinfo(pageSize: 10, offset: 0);
      ResponseUserInfo? response = await HttpServiceUser.getUserInfo(data: data);

      if (response != null && response.resultData != null) {
        final List<UserInfo> userInfoList = response.resultData!.users;
        print("Response: ${userInfoList[1].firstName}");

        // Generate rows and log them before updating the state
        final generatedRows = generateRows(userInfoList);
        print("Generated ${generatedRows.length} rows");

        if (generatedRows.isNotEmpty) {
          print("Sample row data: ${generatedRows.first.cells}");
        }

        // Update the state and log the row data again
        setState(() {
          rows = generatedRows;
          stateManager.notifyListeners();
          print("SetState called. Rows updated. First row data: ${rows.first.cells}");
        });
      } else {
        print('Failed to fetch user data: ${response?.resultMsg}');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    } finally {
      stateManager.setShowLoading(false);
    }
  }

  List<PlutoRow> generateRows(List<UserInfo> userInfoList) {
    return userInfoList.map((user) {
      return PlutoRow(cells: {
        'col1': PlutoCell(value: user.userId.toString()),
        'col2': PlutoCell(value: user.firstName ?? ''),
        'col3': PlutoCell(value: user.lastName ?? ''),
        'col4': PlutoCell(value: user.status.value),
        'col5': PlutoCell(value: user.formatDateTime(user.updatedAt)),
        'col6': PlutoCell(value: user.formatDateTime(user.createdAt)),/*
        'col7': PlutoCell(value: user.isBanned() ? Constants.BANNED : Constants.BAN),
        'col8': PlutoCell(value: user.deleted == true ? Constants.DELETED : Constants.DELETE),*/
      });
    }).toList();
  }

  List<PlutoColumn> generateColumns(List<UserInfo> userInfoList) {
    return [
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
      /*
      PlutoColumn(
        title: Constants.BAN,
        field: 'col7',
        type: PlutoColumnType.text(),
        readOnly: true,
        enableFilterMenuItem: false,
        renderer: (rendererContext) {
          final user = userInfoList[rendererContext.rowIdx];
          bool isBanned = rendererContext.cell.value == Constants.BANNED;
          return ElevatedButton(
            onPressed: (user.deleted ?? false)
                ? null
                : () {
              rendererContext.stateManager.changeCellValue(
                rendererContext.cell,
                isBanned ? Constants.BAN : Constants.BANNED,
              );
            },
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
          final user = userInfoList[rendererContext.rowIdx];
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
      */
    ];
  }

  @override
  void initState(){
    super.initState();

    columns.addAll(generateColumns([]));
  }

  @override
  Widget build(BuildContext context) {
    print("Building grid with ${columns.length} columns and ${rows.length} rows");

    if (rows.isNotEmpty) {
      print("Sample row data in build: ${rows.first.cells}");
    }

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: PlutoGrid(
          columns: columns,
          rows: rows,
          configuration: const PlutoGridConfiguration(),
          onLoaded: (PlutoGridOnLoadedEvent event) {
            stateManager = event.stateManager;
            stateManager.setShowColumnFilter(true);

            print("State manager initialized. Fetching user info...");
            fetchUserInfo();
          },
          onChanged: (PlutoGridOnChangedEvent event) {
            print("Row changed: ${event.row.cells}");
          },
        ),
      ),
    );
  }
}