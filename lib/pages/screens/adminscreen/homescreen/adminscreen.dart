import 'package:brainbuster/pages/screens/adminscreen/managequizscreen/managequestion/mangequiz.dart';
import 'package:brainbuster/pages/screens/adminscreen/reportscreen/adminreport.dart';
import 'package:brainbuster/pages/screens/adminscreen/settinngsscreen/adminsettings.dart';
import 'package:brainbuster/pages/screens/adminscreen/usermangementscreen/usermangement.dart';
import 'package:brainbuster/pages/security/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminnistratorDashboard extends StatelessWidget {
  const AdminnistratorDashboard({super.key});

  Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User logged out successfully.")),
      );

      // Ensure navigation happens after the frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  LoginPage()),
        );
      });
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error logging out: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimaryFixedVariant,
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 200, left: 30, right: 30, top: 20),
        child: Column(
          children: [
            const Row(
              children: [
                Text(
                  "Welcome Back To BrainMagic!",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                ),
              ],
            ),
            const Row(
              children: [
                Text(
                  "Mr Admin",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 50),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 180,
                      child: DashboardTile(
                        gradient: const LinearGradient(
                          colors: [Colors.purple, Colors.blue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        text: "Manage Quizzes",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ManageQuizzesScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: SizedBox(
                      height: 180,
                      child: DashboardTile(
                        gradient: const LinearGradient(
                          colors: [Colors.green, Colors.teal],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        ),
                        text: "User Management",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UserManagementScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 180,
                      child: DashboardTile(
                        gradient: const LinearGradient(
                          colors: [Colors.orange, Colors.red],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        text: "Reports",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ReportsScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: SizedBox(
                      height: 180,
                      child: DashboardTile(
                        gradient: const LinearGradient(
                          colors: [Colors.indigo, Colors.cyan],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        ),
                        text: "Settings",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingsScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.wechat_rounded,
              size: 50,
              color: Colors.brown[300],
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardTile extends StatelessWidget {
  final Gradient gradient;
  final String text;
  final VoidCallback onTap;

  const DashboardTile({
    super.key,
    required this.gradient,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 2,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}



// import 'package:brainbuster/pages/screens/adminscreen/managequizscreen/managequestion/mangequiz.dart';
// import 'package:brainbuster/pages/screens/adminscreen/reportscreen/adminreport.dart';
// import 'package:brainbuster/pages/screens/adminscreen/settinngsscreen/adminsettings.dart';
// import 'package:brainbuster/pages/screens/adminscreen/usermangementscreen/usermangement.dart';
// import 'package:brainbuster/pages/security/login_page.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class AdminnistratorDashboard extends StatelessWidget {
//   const AdminnistratorDashboard({super.key});

//   // Function to handle logout and show SnackBar
//   // Future<void> logout(BuildContext context) async {
//   //   try {
//   //     await FirebaseAuth.instance.signOut();
//   //     // Show SnackBar after successful logout
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       const SnackBar(content: Text("User logged out successfully.")),
//   //     );
//   //     // Navigate to login page after logout
//   //     Navigator.pushNamed(context, '/loginpage');
//   //   } catch (e) {
//   //     // Show SnackBar in case of an error
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(content: Text("Error logging out: $e")),
//   //     );
//   //   }
//   // }

//   Future<void> logout(ScaffoldMessengerState messenger, NavigatorState navigator) async {
//   try {
//     await FirebaseAuth.instance.signOut();

//     // Show SnackBar after successful logout
//     messenger.showSnackBar(
//       const SnackBar(content: Text("User logged out successfully.")),
//     );

//     // Navigate to login page after logout
//     navigator.pushNamed('/loginpage');
//   } catch (e) {
//     // Show SnackBar in case of an error
//     messenger.showSnackBar(
//       SnackBar(content: Text("Error logging out: $e")),
//     );
//   }
// }


//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(useMaterial3: true),
//       debugShowCheckedModeBanner: false,
//       home: const AdminDashboard(),
//     );
//   }
// }

// class AdminDashboard extends StatelessWidget {
//   const AdminDashboard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.onPrimaryFixedVariant,
//       appBar: AppBar(
//         title: const Text('Admin Dashboard'),
//         backgroundColor: Theme.of(context).colorScheme.primaryContainer,
//         automaticallyImplyLeading: false,
//         actions: [
//           IconButton(
//   icon: const Icon(Icons.logout),
//             onPressed: () async {
//             // Check if the user is logged in
//             bool isLoggedIn = FirebaseAuth.instance.currentUser != null;

//             // If logged in, proceed with logout
//             if (isLoggedIn) {
//               // Log the user out
//               await FirebaseAuth.instance.signOut();

//               // Show a SnackBar with the logout message
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text('Logged out'),
//                   duration: Duration(seconds: 2),
//                 ),
//               );

//               // Use WidgetsBinding to ensure this is called after the async operation
//               WidgetsBinding.instance.addPostFrameCallback((_) {
//                 // Navigate to the login page after the logout process
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => LoginPage(),
//                   ),
//                 );
//               });
//             } else {
//               // If the user is not logged in, show a message
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text('Not logged in'),
//                   duration: Duration(seconds: 2),
//                 ),
//               );
//             }
//           },

//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.only(bottom: 200, left: 30, right: 30, top: 20),
//         child: Column(
//           children: [
//             const Row(
//               children: [
//                 Text(
//                   "Welcome Back To BrainMagic!",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
//                 ),
//               ],
//             ),
//             const Row(
//               children: [
//                 Text(
//                   "Mr Admin",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 50),
//             Expanded(
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: SizedBox(
//                       height: 180,
//                       child: DashboardTile(
//                         gradient: const LinearGradient(
//                           colors: [Colors.purple, Colors.blue],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                         text: "Manage Quizzes",
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const ManageQuizzesScreen(),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 15),
//                   Expanded(
//                     child: SizedBox(
//                       height: 180,
//                       child: DashboardTile(
//                         gradient: const LinearGradient(
//                           colors: [Colors.green, Colors.teal],
//                           begin: Alignment.topRight,
//                           end: Alignment.bottomLeft,
//                         ),
//                         text: "User Management",
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const UserManagementScreen(),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 5),
//             Expanded(
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: SizedBox(
//                       height: 180,
//                       child: DashboardTile(
//                         gradient: const LinearGradient(
//                           colors: [Colors.orange, Colors.red],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                         text: "Question",
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const ReportsScreen(),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 15),
//                   Expanded(
//                     child: SizedBox(
//                       height: 180,
//                       child: DashboardTile(
//                         gradient: const LinearGradient(
//                           colors: [Colors.indigo, Colors.cyan],
//                           begin: Alignment.topRight,
//                           end: Alignment.bottomLeft,
//                         ),
//                         text: "Settings",
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const SettingsScreen(),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Icon(
//               Icons.wechat_rounded,
//               size: 50,
//               color: Colors.brown[300],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class DashboardTile extends StatelessWidget {
//   final Gradient gradient;
//   final String text;
//   final VoidCallback onTap;

//   const DashboardTile({
//     super.key,
//     required this.gradient,
//     required this.text,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: gradient,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 8,
//               spreadRadius: 2,
//               offset: const Offset(2, 4),
//             ),
//           ],
//         ),
//         child: Center(
//           child: Text(
//             text,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

