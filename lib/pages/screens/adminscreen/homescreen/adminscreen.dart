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
        title: const Text('Admin Dashboard',style: TextStyle(color: Colors.white,fontSize: 15),),
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
                mainAxisAlignment: MainAxisAlignment.center,
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
                mainAxisAlignment: MainAxisAlignment.center,
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
        alignment: Alignment.center,
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
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 16),
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Poppins',
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
