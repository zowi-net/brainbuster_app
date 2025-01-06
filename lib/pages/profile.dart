import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:brainbuster/services/database.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Database db = Database();
  final user = FirebaseAuth.instance.currentUser;

  void signUserOut() async {
    await FirebaseAuth.instance.signOut();
    // Navigator.pushReplacementNamed(context, '/loginpage');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.brown[300],
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'BrainBuster Quiz',
            style: GoogleFonts.rubik(
              textStyle: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(32, 34, 36, 0.8),
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GestureDetector(
              onTap: (){
                signUserOut();
                Navigator.pushReplacementNamed(context, '/loginpage');
              },             
              child: const FaIcon(
                FontAwesomeIcons.rightFromBracket, size: 24),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => const Divider(
                  color: Colors.grey, // Change color as needed
                  thickness: 1,       // Adjust thickness if desired
                  height: 20,         // Space around the divider
                ),
                itemCount: getTileData(context).length,
                itemBuilder: (context, index) {
                  final tile = getTileData(context)[index];
                  return buildHoverableTile(
                    context,
                    icon: tile['icon'] as IconData,
                    title: tile['title'] as String,
                    subtitle: tile['subtitle'] as String?,
                    onTap: tile['onTap'] as VoidCallback?,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHoverableTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.brown[100],
      hoverColor: Colors.brown[50], // Only works on desktop/web
      child: ListTile(
        leading: CircleAvatar(
          child: FaIcon(
            icon,
            color: Colors.deepOrange,
          ),
        ),
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: const FaIcon(FontAwesomeIcons.arrowRight),
      ),
    );
  }
}

// Mock data for the tiles
List<Map<String, dynamic>> getTileData(BuildContext context) {
  return [
    {
      'icon': FontAwesomeIcons.database,
      'title': "Add Questions",
      'subtitle': "Where you can add questions and answers",
      'onTap': (){
        Navigator.pushNamed(context, '/admin');
      }
    },
    {
      'icon': FontAwesomeIcons.envelope,
      'title': "Email",
      'subtitle': "user@example.com",
    },
    {
      'icon': FontAwesomeIcons.lock,
      'title': "Password",
      'subtitle': "Updated 2 days ago",
    },
    {
      'icon': FontAwesomeIcons.gear,
      'title': "App Settings",
    },
    {
      'icon': FontAwesomeIcons.question,
      'title': "Help Center",
      'onTap': () {
        Navigator.pushNamed(context, '/helpcenter');
      },
    },
    {
      'icon': FontAwesomeIcons.scroll,
      'title': "Privacy & Terms",
      'onTap': () {
        Navigator.pushNamed(context, '/privacy');
      },
    },
    {
      'icon': FontAwesomeIcons.comment,
      'title': "Feedback",
    },
    {
      'icon': FontAwesomeIcons.phone,
      'title': "Contact Us",
    },
  ];
}
