import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:unicons/unicons.dart';

class AdminScreen extends StatefulWidget {
  static const title = 'salomon_bottom_bar'; 
   AdminScreen({super.key});

  final user = FirebaseAuth.instance.currentUser;

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
   var _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
        bottomNavigationBar: SalomonBottomBar(
          backgroundColor: Colors.brown[300],  // Dark brown background
          selectedItemColor: Colors.brown[500],  // Teal for selected item icons/text
          unselectedItemColor: Colors.grey[900],  // Light grey for unselected item icons/text
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
           items: [
            /// Home
            SalomonBottomBarItem(
              icon: const FaIcon(
                FontAwesomeIcons.house, size: 30,),//Icon(FontAwesomeIcons.home, size: 30,),
              title: const Text("Home"),
              selectedColor: const Color.fromRGBO(32, 34, 36, 0.8),
              
            ),

            /// Likes
            SalomonBottomBarItem(
              icon: GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, '/quiz');
                },
                child: const FaIcon(
                  FontAwesomeIcons.graduationCap,size: 30),
                ),
              title: const Text(" School"),
              selectedColor: const Color.fromRGBO(32, 34, 36, 0.8),
              
            ),

            /// Search
            SalomonBottomBarItem(
              icon: GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, '/result');
                },
                child: const FaIcon(
                  FontAwesomeIcons.chartSimple,size: 30),
                ),
              title: const Text("Results"),
              selectedColor: const Color.fromRGBO(32, 34, 36, 0.8,),
            ),

            /// Profile
            SalomonBottomBarItem(
              icon: GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, '/profile');
                },
                child: const FaIcon(
                  FontAwesomeIcons.gear,size: 30),
                ),
              title: const Text("Profile"),
              selectedColor: const Color.fromRGBO(32, 34, 36, 0.8),
            ),
          ],
        ), 
        appBar: AppBar(
          backgroundColor: Colors.brown[300],
          title: Padding(
            padding: const EdgeInsets.only(left: 16.0,right: 16.0),
            child: Text('BrainBuster Quiz',
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
            padding: const EdgeInsets.only(left: 16.0,right: 16.0),
            child: GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, '/profile');
                },child: const Icon(UniconsLine.user,size: 24,),
                ),
            
          ),
          ], 
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 16.0,right: 16.0,top: 18),
          child: ListView(
            children: [Column(
              children: [
                const Text("admin/ admin sections"),
                Row(
                  children: [
                    Text("HI, ${widget.user?.email ?? 'User'}", style: GoogleFonts.comicNeue(
                      textStyle: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                 const Row(
                  children: [
                    Text("you have Exams pending"),
                  ],
                ),
                SizedBox(
                  height: 250,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Card(
                        shadowColor: Colors.transparent,
                        elevation: 20,
                        child: SizedBox(
                          height: 100,
                          width: 360,
                          child: Image.asset('assets/first.jpg',fit: BoxFit.fill,),
                        ),
                      ),
                      Card(
                        shadowColor: Colors.transparent,
                        elevation: 20,
                        child: SizedBox(
                          height: 100,
                          width: 360,
                          child: Image.asset('assets/secound.jpg'),
                        ),
                      ),
                    ],
                  ),
                ),const SizedBox(height: 20,),
                Row(
                  children: [
                    Text("Categories",style: GoogleFonts.newTegomin(fontSize: 25,fontWeight: FontWeight.bold),
                    ),
                  ],
                ),const SizedBox(height: 10,),
//card for categories
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 120,
                    height: 140,
                    child: Card(
                      color: Colors.deepOrange[400],
                      shadowColor: Colors.deepOrange[700],
                      surfaceTintColor: Colors.deepPurple[900],
                      // elevation: 20,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 5),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                           //text for ecah card in categories 
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 20),
                                    child: FaIcon(
                                      FontAwesomeIcons.mountain,color: Colors.black,),
                                  ),
                                  ),
                              ],
                            ),const SizedBox(height: 30,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Geography",style: GoogleFonts.poppins(fontSize: 15,),),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                 SizedBox(
                    width: 120,
                    height: 140,
                    child: Card(
                      color: Colors.cyan[700],
                      shadowColor: Colors.deepOrange[700],
                      surfaceTintColor: Colors.deepPurple[900],
                      // elevation: 20,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 5),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                           //text for ecah card in categories 
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: FaIcon(
                                      FontAwesomeIcons.virus,color: Colors.deepPurple[500],size: 35,),
                                  ),
                                  ),
                              ],
                            ),const SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Biology",style: GoogleFonts.poppins(fontSize: 15,),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  //third category card start here
                  SizedBox(
                    width: 120,
                    height: 140,
                    child: Card(
                      color: Colors.lightGreen[400],
                      shadowColor: Colors.deepOrange[700],
                      surfaceTintColor: const Color.fromARGB(255, 56, 38, 140),
                      // elevation: 20,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 5),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                           //text for ecah card in categories 
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: FaIcon(
                                      FontAwesomeIcons.code,color: Colors.deepOrange[500],size: 35,),
                                  ),
                                  ),
                              ],
                            ),const SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Programming", style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  // color: Colors.deepOrange[500],
                                ),
                              ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
               
              ],
            ),
          ],
          ),const SizedBox(height: 20,),
      
          SizedBox(
                    width: 120,
                    height: 140,
                    child: Card(
                      color: Colors.lightGreen[400],
                      shadowColor: Colors.deepOrange[700],
                      surfaceTintColor: Colors.deepPurple[900],
                      elevation: 20,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 5),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                           //text for ecah card in categories 
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 20),
                                    child: FaIcon(
                                      FontAwesomeIcons.calculator,color: Colors.black,size: 30,),
                                  ),
                                  ),
                              ],
                            ),const SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Mathematics",style: GoogleFonts.poppins(fontSize: 18,
                                ),
                                ), 
                                
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
           ],
        ),
     ),
     );
  }
}

