import 'package:ecoplates_web/src/presentation/widgets/simple_account_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pluto_grid/pluto_grid.dart';

import 'build_summary_card.dart';

class User {
  final int userId;
  final String phoneNumber;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? fullName;
  final double locationLatitude;
  final double locationLongitude;
  final String? profilePictureUrl;
  final String passwordHash;
  final String? tokenMb;
  String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  bool? deleted;

  User({
    required this.userId,
    required this.phoneNumber,
    this.email,
    this.firstName,
    this.lastName,
    this.fullName,
    this.locationLatitude = 0.0,
    this.locationLongitude = 0.0,
    this.profilePictureUrl,
    required this.passwordHash,
    this.tokenMb,
    this.status = 'INACTIVE',
    this.createdAt,
    this.updatedAt,
    this.deleted = false,
  });

  bool isBanned(){
    return status == "BANNED";
  }

  void setBanned(bool yes){
    status = yes? "BANNED" : "INACTIVE";
  }

  String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) {
      return 'N/A'; // Handle null case
    }
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }
}

final List<User> userData = [
  User(
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
    status: 'ACTIVE',
    updatedAt: DateTime.now(),
    createdAt: DateTime.now(),
    deleted: false,
  ),
  User(
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
    status: 'INACTIVE',
    updatedAt: DateTime.now(),
    createdAt: DateTime.now(),
    deleted: false,
  ),
  User(
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
    status: 'BANNED',
    updatedAt: DateTime.now(),
    createdAt: DateTime.now(),
    deleted: false,
  ),
  User(
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
    status: 'ACTIVE',
    updatedAt: DateTime.now(),
    createdAt: DateTime.now(),
    deleted: false,
  ),
  User(
    userId: 5,
    phoneNumber: '+19876543210',
    email: 'jane.doe@example3.com',
    firstName: 'Akmal',
    lastName: 'Tillaev',
    fullName: 'Jane Doe',
    locationLatitude: 34.0522,
    locationLongitude: -118.2437,
    profilePictureUrl: 'https://via.placeholder.com/50',
    passwordHash: 'hash2',
    status: 'DELETED',
    updatedAt: DateTime.now(),
    createdAt: DateTime.now(),
    deleted: true,
  ),
];

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

  List<PlutoRow> generateRows() {
    return userData.map((user) {
      return PlutoRow(cells: {
        'col1': PlutoCell(value: user.userId.toString()),
        'col2': PlutoCell(value: user.firstName ?? ''),
        'col3': PlutoCell(value: user.lastName ?? ''),
        'col4': PlutoCell(value: user.status),
        'col5': PlutoCell(value: user.formatDateTime(user.updatedAt)),
        'col6': PlutoCell(value: user.formatDateTime(user.createdAt)),
        'col7': PlutoCell(value: user.isBanned() ? 'Banned' : 'Ban'),
        'col8': PlutoCell(value: user.deleted == true ? 'Deleted' : 'Delete'),
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
          final user = userData[ctx.rowIdx];
          Color textColor;

          // Determine text color based on the status value
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
              textColor = Colors.black;
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
        title: 'Ban',
        field: 'col7',
        type: PlutoColumnType.text(),
        readOnly: true,
        renderer: (rendererContext) {
          final user = userData[rendererContext.rowIdx];
          return ElevatedButton(
            onPressed: (user.deleted ?? false) ? null :  () {
              user.setBanned(!user.isBanned());
              rendererContext.stateManager.notifyListeners();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: user.isBanned() ? Colors.red : Colors.green,
              foregroundColor: Colors.white,
            ),
            child: Text(user.isBanned() ? 'Banned' : 'Ban'),
          );
        },
      ),
      PlutoColumn(
        title: 'Delete',
        field: 'col8',
        type: PlutoColumnType.text(),
        renderer: (rendererContext) {
          final user = userData[rendererContext.rowIdx];
          return ElevatedButton(
            onPressed: () {
              user.deleted = !(user.deleted ?? false);
              rendererContext.stateManager.notifyListeners();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: user.deleted == true ? Colors.grey : Colors.blueGrey,
              foregroundColor: Colors.white,
            ),
            child: Text(user.deleted == true ? 'Deleted' : 'Delete'),
          );
        },
      ),
    ]);
    rows = generateRows();
  }

  @override
  Widget build(BuildContext context) {
    return PlutoGrid(
      columns: columns,
      rows: rows, // Dynamically generate rows from userData
      configuration: const PlutoGridConfiguration(),
      createFooter: (stateManager) {
        stateManager.setPageSize(100, notify: false);
        return PlutoPagination(stateManager);
      },
      onLoaded: (PlutoGridOnLoadedEvent event) {
        stateManager = event.stateManager;
        stateManager.setShowColumnFilter(true);
      },
      onChanged: (PlutoGridOnChangedEvent event) {

      },
    );
  }
}