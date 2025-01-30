import 'package:brainbuster/pages/screens/adminscreen/managequizscreen/managequestion/mangequiz.dart';
import 'package:brainbuster/pages/screens/adminscreen/reportscreen/adminreport.dart';
import 'package:brainbuster/pages/screens/adminscreen/settinngsscreen/adminsettings.dart';
import 'package:brainbuster/pages/screens/adminscreen/usermangementscreen/usermangement.dart';
import 'package:flutter/material.dart';

class AdminnistratorDashboard extends StatelessWidget {
  const AdminnistratorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: const AdminDashboard(),
    );
  }
}

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

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
            onPressed: () {
              // Add logout action
            
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 200,left: 30,right: 30,top: 20),
        child: Column(
          children: [
            const Row(
              children: [
                Text("Welcome Back To BrainMagic!",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white),),
              ],
            ),
            const Row(
              children: [
                Text("Mr Admin",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white),),
              ],
            ),
            const SizedBox(height: 50,),
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
                              builder: (context) =>  const ReportsScreen(),
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
            // SizedBox(height: 50),

Icon(Icons.wechat_rounded,size: 50,color: Colors.brown[300],),
            
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
