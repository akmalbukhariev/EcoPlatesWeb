import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// User Class Representing the Data
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
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool deleted;

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
}

// Sample User Data
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
    padding: const EdgeInsets.all(16.0), // Add padding around the dashboard
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Align to start for consistency
      children: [
        Row(
          children: [
            // Summary Card: Total Users
            SizedBox(
              width: 200, // Static width for the card
              child: buildSummaryCard(
                title: "Users",
                value: userCount,
                percentage: "20%",
                percentageColor: Colors.green,
                description: "The number of users",
              ),
            ),
            const SizedBox(width: 16.0), // Add spacing between cards
            // Summary Card: Active Users
            SizedBox(
              width: 200, // Static width for the card
              child: buildSummaryCard(
                title: "Active Users",
                value: userCount,
                percentage: "20%",
                percentageColor: Colors.green,
                description: "The number of active users",
              ),
            ),
            const SizedBox(width: 16.0), // Add spacing before the filler
            // Spacer/Container
            Expanded(
              child: Container(
                color: Colors.black12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16.0), // Add spacing between the Row and UserGridWidget
        // User Grid
        Expanded(
          child: UserGridWidget(), // Make the grid take up remaining vertical space
        ),
      ],
    ),
  );
}

Widget buildSummaryCard({
  required String title,
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
      crossAxisAlignment: CrossAxisAlignment.start, // Aligns everything to the left
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        // Percentage and Description
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
            const SizedBox(height: 4), // Space between percentage and description
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


// Widget for the Data Grid
class UserGridWidget extends StatelessWidget {
  const UserGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'User List',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton.icon(
                onPressed: () {
                  // Export functionality
                },
                icon: const Icon(Icons.download, color: Colors.red),
                label: const Text(
                  'Export',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          // Table Header
          Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Row(
              children: const [
                Expanded(flex: 1, child: Text('USER ID')),
                Expanded(flex: 2, child: Text('PHONE NUMBER')),
                Expanded(flex: 3, child: Text('FULL NAME')),
                Expanded(flex: 2, child: Text('STATUS')),
                Expanded(flex: 2, child: Text('CREATED AT')),
              ],
            ),
          ),
          // Data Rows
          Expanded(
            child: ListView.separated(
              itemCount: userData.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final user = userData[index];
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(user.userId.toString(),
                            style: const TextStyle(fontSize: 14)),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(user.phoneNumber,
                            style: const TextStyle(fontSize: 14)),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(user.fullName ?? 'N/A',
                            style: const TextStyle(fontSize: 14)),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(user.status,
                            style: TextStyle(
                                fontSize: 14,
                                color: user.status == 'ACTIVE'
                                    ? Colors.green
                                    : user.status == 'BANNED'
                                    ? Colors.red
                                    : Colors.grey)),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          user.createdAt != null
                              ? user.createdAt!.toIso8601String().substring(0, 10)
                              : 'N/A',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}