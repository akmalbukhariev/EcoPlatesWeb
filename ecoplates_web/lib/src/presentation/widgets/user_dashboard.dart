import 'package:ecoplates_web/src/presentation/widgets/simple_account_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:scrollable_table_view/scrollable_table_view.dart';

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
    createdAt: DateTime.now(),
    deleted: false,
  ),
];

Widget userDashboard(String userCount) {
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
          child: testGridView()//UserGridWidget(),
        ),
      ],
    ),
  );
}

Widget testGridView() {
  final List<PlutoColumn> columns = <PlutoColumn>[
    PlutoColumn(
      title: 'Id',
      field: 'col1',
      type: PlutoColumnType.text(),
      readOnly: true,
      renderer: (rendererContext) {
        final user = userData[rendererContext.rowIdx!];
        return Text(user.userId.toString());
      },
    ),
    PlutoColumn(
      title: 'First name',
      field: 'col2',
      type: PlutoColumnType.text(),
      readOnly: true,
      renderer: (rendererContext) {
        final user = userData[rendererContext.rowIdx!];
        return Text(user.firstName ?? '');
      },
    ),
    PlutoColumn(
      title: 'Last name',
      field: 'col3',
      type: PlutoColumnType.text(),
      readOnly: true,
      renderer: (rendererContext) {
        final user = userData[rendererContext.rowIdx!];
        return Text(user.lastName ?? '');
      },
    ),
    PlutoColumn(
      title: 'Status',
      field: 'col4',
      type: PlutoColumnType.text(),
      readOnly: true,
      renderer: (rendererContext) {
        final user = userData[rendererContext.rowIdx!];
        Color textColor;

        switch (user.status) {
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
            textColor = Colors.black;
        }

        return Text(
          user.status,
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        );
      },
    ),
    PlutoColumn(
      title: 'Ban',
      field: 'col7',
      type: PlutoColumnType.text(),
      renderer: (rendererContext) {
        final user = userData[rendererContext.rowIdx!];
        return ElevatedButton(
          onPressed: () {
            user.setBanned(!user.isBanned());
            rendererContext.stateManager!.notifyListeners(); // Refresh grid
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: user.isBanned() ? Colors.red : Colors.blue,
          ),
          child: Text(user.isBanned() ? 'Unban' : 'Ban'),
        );
      },
    ),
    PlutoColumn(
      title: 'Delete',
      field: 'col8',
      type: PlutoColumnType.text(),
      renderer: (rendererContext) {
        final user = userData[rendererContext.rowIdx!];
        return ElevatedButton(
          onPressed: () {
            user.deleted = true;
            rendererContext.stateManager!.notifyListeners(); // Refresh grid
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
          ),
          child: user.deleted! ? const Text('Deleted') : const Text('Delete'),
        );
      },
    ),
  ];

  late final PlutoGridStateManager stateManager;
  final List<PlutoRow> placeholderRows = List.generate(
    userData.length,
        (index) => PlutoRow(cells: {
      'col1': PlutoCell(value: ''),
      'col2': PlutoCell(value: ''),
      'col3': PlutoCell(value: ''),
      'col4': PlutoCell(value: ''),
      'col7': PlutoCell(value: ''),
      'col8': PlutoCell(value: ''),
    }),
  );
  return PlutoGrid(
    columns: columns,
    rows: placeholderRows,
    onLoaded: (PlutoGridOnLoadedEvent event) {
      stateManager = event.stateManager;
      stateManager.setShowColumnFilter(true);
    },
    onChanged: (PlutoGridOnChangedEvent event) {
      print(event);
    },
  );
}

Widget buildSummaryCard({
  required String title,
  required Color titleColor, // New parameter for title color
  required String value,
  required String percentage,
  required Color percentageColor,
  required String description,
}) {
  return Container(
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8.0),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: titleColor),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              percentage,
              style: TextStyle(
                fontSize: 14,
                color: percentageColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ],
    ),
  );
}

class UserGridWidget extends StatefulWidget {
  const UserGridWidget({super.key});

  @override
  State<UserGridWidget> createState() => _UserGridWidgetState();
}

class _UserGridWidgetState extends State<UserGridWidget> {
  String selectedStatus = "Set status to";

  void _updateStatusForAll(String newStatus) {
    setState(() {
      for (var user in userData) {
        if (selectedUsers.contains(user)) {
          user.status = newStatus;
        }
      }
      selectedUsers.clear(); // Clear selection after update
    });
  }

  final List<User> selectedUsers = [];

  void _toggleSelection(User user) {
    setState(() {
      if (selectedUsers.contains(user)) {
        selectedUsers.remove(user);
      } else {
        selectedUsers.add(user);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Enable horizontal scrolling
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
        ),
        child: IntrinsicWidth(
          child: Column(
            children: [
              // Table Header
              Container(
                color: Colors.grey[200],
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                child: Row(
                  children: const [
                    SizedBox(width: 40, child: Text('Select')),
                    SizedBox(width: 10),
                    SizedBox(width: 80, child: Text('ID')),
                    SizedBox(width: 120, child: Text('FIRST NAME')),
                    SizedBox(width: 120, child: Text('LAST NAME')),
                    SizedBox(width: 200, child: Text('EMAIL')),
                    SizedBox(width: 100, child: Text('STATUS')),
                    SizedBox(width: 150, child: Text('CREATION DATE')),
                    SizedBox(width: 100, child: Text('Ban')),
                    SizedBox(width: 100, child: Text('Delete')),
                  ],
                ),
              ),
              // Table Rows
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: userData.map((user) {
                      final isSelected = selectedUsers.contains(user);

                      return Container(
                        color: user.deleted == true
                            ? Colors.grey[200] // Faded background for deleted users
                            : Colors.white, // Default background color
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                        child: Row(
                          children: [
                            // Checkbox for Selection
                            SizedBox(
                              width: 40,
                              child: Checkbox(
                                value: isSelected,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _toggleSelection(user);
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            // User Details
                            SizedBox(width: 80, child: Text(user.userId.toString())),
                            SizedBox(width: 120, child: Text(user.fullName?.split(" ").first ?? 'N/A')),
                            SizedBox(width: 120, child: Text(user.fullName?.split(" ").last ?? 'N/A')),
                            SizedBox(width: 200, child: Text(user.email ?? 'N/A')),
                            SizedBox(
                              width: 100,
                              child: Text(
                                user.status,
                                style: TextStyle(
                                  color: user.status == 'ACTIVE'
                                      ? Colors.green
                                      : user.status == 'BANNED'
                                      ? Colors.red
                                      : Colors.orange,
                                ),
                              ),
                            ),
                            SizedBox(width: 150, child: Text(user.createdAt?.toIso8601String().substring(0, 10) ?? 'N/A')),

                            // Ban Button
                            SizedBox(
                              width: 100,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    user.setBanned(!(user.isBanned() ?? false)); // Toggle banned status
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: user.isBanned() == true ? Colors.orange : Colors.green,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(50, 30),
                                ),
                                child: Text(user.isBanned() == true ? 'Banned' : 'Ban'),
                              ),
                            ),

                            // Delete Button
                            SizedBox(
                              width: 100,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    user.deleted = !(user.deleted ?? false); // Toggle deleted status
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: user.deleted == true ? Colors.grey : Colors.red,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(50, 30),
                                ),
                                child: Text(user.deleted == true ? 'Deleted' : 'Delete'),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}