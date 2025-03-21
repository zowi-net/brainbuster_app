import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class UserScreenDashBoard extends StatefulWidget {
  static const title = 'salomon_bottom_bar'; 
   UserScreenDashBoard({super.key});

  final user = FirebaseAuth.instance.currentUser;

  @override
  State<UserScreenDashBoard> createState() => _UserScreenDashBoardState();
}

class _UserScreenDashBoardState extends State<UserScreenDashBoard> {
   var _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: const Color.fromRGBO(221, 220, 220, 1),
    bottomNavigationBar: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        margin: const EdgeInsets.only(bottom: 7), // Adds space below the bar
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Adds padding inside
        decoration: BoxDecoration(
      color: const Color.fromRGBO(117, 74, 77, 1), // Dark brown background
      borderRadius: BorderRadius.circular(30), // Makes it curved
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 10,
          spreadRadius: 3,
        ),
      ],
        ),
        child: SalomonBottomBar(
      backgroundColor: Colors.transparent, // Matches container background
      selectedItemColor: Colors.brown[500],
      unselectedItemColor: Colors.grey[900],
      currentIndex: _currentIndex,
      onTap: (i) => setState(() => _currentIndex = i),
      items: [
        SalomonBottomBarItem(
          icon: const FaIcon(FontAwesomeIcons.house, size: 30),
          title: const Text("Home"),
          selectedColor: const Color.fromRGBO(32, 34, 36, 0.8),
        ),
        SalomonBottomBarItem(
          icon: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/braincategory');
            },
            child: const FaIcon(FontAwesomeIcons.graduationCap, size: 30),
          ),
          title: const Text("School"),
          selectedColor: const Color.fromRGBO(32, 34, 36, 0.8),
        ),
        SalomonBottomBarItem(
          icon: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/result');
            },
            child: const FaIcon(FontAwesomeIcons.chartSimple, size: 30),
          ),
          title: const Text("Results"),
          selectedColor: const Color.fromRGBO(32, 34, 36, 0.8),
        ),
        SalomonBottomBarItem(
          icon: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/setting');
            },
            child: const FaIcon(FontAwesomeIcons.gear, size: 30),
          ),
          title: const Text("Settings"),
          selectedColor: const Color.fromRGBO(32, 34, 36, 0.8),
        ),
      ],
        ),
      ),
    ),

      // bottomNavigationBar: SalomonBottomBar(
      //   backgroundColor: const Color.fromRGBO(117, 74, 77, 1),  // Dark brown background
      //   selectedItemColor: Colors.brown[500],  // Teal for selected item icons/text
      //   unselectedItemColor: Colors.grey[900],  // Light grey for unselected item icons/text
      //   currentIndex: _currentIndex,
      //   onTap: (i) => setState(() => _currentIndex = i),
      //     items: [
      //     /// Home
      //     SalomonBottomBarItem(
      //       icon: const FaIcon(
      //         FontAwesomeIcons.house, size: 30,),//Icon(FontAwesomeIcons.home, size: 30,),
      //       title: const Text("Home"),
      //       selectedColor: const Color.fromRGBO(32, 34, 36, 0.8),
            
      //     ),

      //     /// Likes
      //     SalomonBottomBarItem(
      //       icon: GestureDetector(
      //         onTap: (){
      //           Navigator.pushNamed(context, '/braincategory', );
      //         },
      //         child: const FaIcon(
      //           FontAwesomeIcons.graduationCap,size: 30),
      //         ),
      //       title: const Text(" School"),
      //       selectedColor: const Color.fromRGBO(32, 34, 36, 0.8),
            
      //     ),

      //     /// Search
      //     SalomonBottomBarItem(
      //       icon: GestureDetector(
      //         onTap: (){
      //           Navigator.pushNamed(context, '/result');
      //         },
      //         child: const FaIcon(
      //           FontAwesomeIcons.chartSimple,size: 30),
      //         ),
      //       title: const Text("Results"),
      //       selectedColor: const Color.fromRGBO(32, 34, 36, 0.8,),
      //     ),

      //     /// Profile
      //     SalomonBottomBarItem(
      //       icon: GestureDetector(
      //         onTap: (){
      //           Navigator.pushNamed(context, '/setting');
      //         },
      //         child: const FaIcon(
      //           FontAwesomeIcons.gear,size: 30),
      //         ),
      //       title: const Text("Settings"),
      //       selectedColor: const Color.fromRGBO(32, 34, 36, 0.8),
      //     ),
      //   ],
      // ), 
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes the default back button
        backgroundColor: const Color.fromRGBO(117, 74, 73, 3),
        title: Padding(
          padding: const EdgeInsets.only(left: 16.0,right: 16.0),
          child: Text('BrainBuster Quiz',
          style: GoogleFonts.rubik(
            textStyle: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(255, 255, 255, 2), 
            ), 
          ),
        ),
        ),
      ),
  body: Padding(
    padding: const EdgeInsets.only(left: 16.0,right: 16.0,top: 18),
    child: ListView(
      children: [Column(
        children: [
          Row(
            children: [
              Text("HI, ${widget.user?.email ?? 'User'}", style: GoogleFonts.comicNeue(
                textStyle: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 25,fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
            const Row(
            children: [
              Text("you have Exams pending",style: TextStyle(
                fontFamily: 'Nunito',
              ),),
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
          const Row(
            children: [
              Text("Categories",style: TextStyle(
                 fontFamily: 'Pacifico',
                fontSize: 25,fontWeight: FontWeight.bold),
              ),
            ],
          ),const SizedBox(height: 10,),
//card for categories
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(
              width: 120,
              height: 140,
              child: Card(
                color: Color.fromRGBO(238, 146, 30, 1),
                shadowColor: Color.fromRGBO(238, 146, 30, 1),
                surfaceTintColor: Color.fromRGBO(238, 146, 30, 1),
                elevation: 20,
                child: Padding(
                  padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 5),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //text for ecah card in categories 
                      Row(
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
                      ),SizedBox(height: 30,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Geography",style: TextStyle(
                             fontFamily: 'Poppins',
                            fontSize: 15,),),
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
                color: const Color.fromRGBO(244, 66, 53, 1),
                shadowColor: const Color.fromRGBO(244, 66, 53, 1),
                surfaceTintColor: const Color.fromRGBO(244, 66, 53, 1),
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
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Biology",style: TextStyle(
                             fontFamily: 'Poppins',
                            fontSize: 15,),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
 //third category card start here
            const SizedBox(
              width: 120,
              height: 140,
              child: Card(
                color: Color.fromRGBO(118, 164, 96, 1),
                shadowColor: Color.fromRGBO(118, 164, 96, 1),
                surfaceTintColor: Color.fromRGBO(118, 164, 96, 1),
                // elevation: 20,
                child: Padding(
                  padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 5),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //text for ecah card in categories 
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: FaIcon(
                                FontAwesomeIcons.code,color: Color.fromRGBO(243, 64, 33, 1),
                                size: 35,),
                            ),
                            ),
                        ],
                      ),SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Programming", style: TextStyle(
                             fontFamily: 'Poppins',
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
    ),
          const SizedBox(height: 20,),
            SizedBox(
              width: 120,
              height: 140,
              child: Card(
                color: const Color.fromRGBO(118, 164, 96, 1),
                shadowColor: Colors.deepOrange[700],
                surfaceTintColor: Colors.deepPurple[900],
                elevation: 20,
                child: const Padding(
                  padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 5),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //text for ecah card in categories 
                      Row(
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
                      ),SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Mathematics",style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
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

