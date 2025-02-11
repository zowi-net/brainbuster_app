import 'package:brainbuster/pages/screens/adminscreen/usermangementscreen/edituserscreen/edituserscreen.dart';
import 'package:brainbuster/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final Database db = Database();

  void _deleteUser(String userId) {
    db.deleteUser(userId);
  }

  void _confirmDeleteUser(String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this user?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _deleteUser(userId);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _editUser(Map<String, dynamic> userData, String userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditUserScreen(userData: userData, userId: userId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Management',
                style: GoogleFonts.poppins(
                    fontSize: 20, 
                    color: Colors.brown[800],
                    wordSpacing: 1.5,
                  ),
                ),
        backgroundColor: Colors.grey[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: StreamBuilder<QuerySnapshot>(
          stream: db.readStudents(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}',
                      style: GoogleFonts.poppins(
                        fontSize: 16, 
                        color: Colors.brown[800],
                        wordSpacing: 1.5,
                      ),
                  ),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: Colors.deepPurple[500],),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text('No Users available',
                style: GoogleFonts.poppins(
                      fontSize: 16, 
                      color: Colors.brown[800],
                      wordSpacing: 1.5,
                    ),
                ),
              );
            }

            var users = snapshot.data!.docs;

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                final userData = user.data() as Map<String, dynamic>;

                String formattedDate = 'No Date Provided';
                if (userData['dateCreated'] != null) {
                  try {
                    final Timestamp timestamp = userData['dateCreated'];
                    final DateTime dateTime = timestamp.toDate();
                    formattedDate =
                        "${dateTime.day} ${_getMonthName(dateTime.month)} ${dateTime.year} at ${dateTime.hour}:${dateTime.minute}:${dateTime.second} UTC${dateTime.timeZoneOffset.inHours > 0 ? '+${dateTime.timeZoneOffset.inHours}' : dateTime.timeZoneOffset.inHours}";
                  } catch (e) {
                    formattedDate = 'Invalid Date';
                  }
                }

                return Card(
                  color: Theme.of(context).colorScheme.surface,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      '${userData['firstName'] ?? 'No First Name'} ${userData['lastName'] ?? ''}',
                      style: GoogleFonts.poppins(
                            fontSize: 16, 
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email: ${userData['email'] ?? 'No Email'}',
                          style: GoogleFonts.poppins(
                            fontSize: 13, 
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                          ),),
                        Text('Role: ${userData['role'] ?? 'No Role'}'),
                        const Text('Password: ********'), // Masked password
                        Text('Date Created: $formattedDate'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editUser(userData, user.id),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmDeleteUser(user.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return monthNames[month - 1];
  }
}




// import 'package:brainbuster/pages/screens/adminscreen/usermangementscreen/edituserscreen/edituserscreen.dart';
// import 'package:brainbuster/services/database.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class UserManagementScreen extends StatefulWidget {
//   const UserManagementScreen({super.key});

//   @override
//   State<UserManagementScreen> createState() => _UserManagementScreenState();
// }

// class _UserManagementScreenState extends State<UserManagementScreen> {
//   final Database db = Database();

//   void _deleteUser(String userId) {
//     // Delete user from Firestore
//     db.deleteUser(userId);
//   }

//   void _editUser(Map<String, dynamic> userData, String userId) {
//     // Navigate to edit user screen
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => EditUserScreen(userData: userData, userId: userId),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('User Management'),
//         backgroundColor: Theme.of(context).colorScheme.primaryContainer,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: StreamBuilder<QuerySnapshot>(
//           stream: db.readStudents(),
//           builder: (context, snapshot) {
//             if (snapshot.hasError) {
//               return const Center(
//                 child: Text('Something went wrong. Please try again later.'),
//               );
//             }

//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             }

//             if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
//               var users = snapshot.data!.docs;

//               return ListView.builder(
//                 itemCount: users.length,
//                 itemBuilder: (context, index) {
//                   final user = users[index];
//                   final userData = user.data() as Map<String, dynamic>;

//                   // Handle null or missing dateCreated
//                   String formattedDate = 'No Date Provided';
//                   if (userData['dateCreated'] != null) {
//                     final Timestamp timestamp = userData['dateCreated'];
//                     final DateTime dateTime = timestamp.toDate();
//                     formattedDate =
//                         "${dateTime.day} ${_getMonthName(dateTime.month)} ${dateTime.year} at ${dateTime.hour}:${dateTime.minute}:${dateTime.second} UTC${dateTime.timeZoneOffset.inHours > 0 ? '+${dateTime.timeZoneOffset.inHours}' : dateTime.timeZoneOffset.inHours}";
//                   }

//                   return Card(
//                     margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                     elevation: 4,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: ListTile(
//                       title: Text(
//                         '${userData['firstName'] ?? 'No First Name'} ${userData['lastName'] ?? ''}',
//                         style: const TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('Email: ${userData['email'] ?? 'No Email'}'),
//                           Text('Role: ${userData['role'] ?? 'No Role'}'),
//                           Text('Password: ${userData['password'] ?? 'No Password'}'),
//                           Text('Date Created: $formattedDate'),
//                         ],
//                       ),
//                       trailing: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           IconButton(
//                             icon: const Icon(Icons.edit),
//                             onPressed: () => _editUser(userData, user.id),
//                           ),
//                           IconButton(
//                             icon: const Icon(Icons.delete),
//                             onPressed: () => _deleteUser(user.id),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               );
//             }

//             return const Center(
//               child: Text('No Users available'),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   String _getMonthName(int month) {
//     const monthNames = [
//       'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'
//     ];
//     return monthNames[month - 1];
//   }
// }
