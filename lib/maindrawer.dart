import 'package:flutter/material.dart';
import '/otp_HomePage.dart';
import '/PostTripforDriver/post_Trip_For_Driver.dart';
import '/Profile/ProfilePage.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({super.key});
  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:  Drawer(
          child: Column(
            children: <Widget> [
              Container(
                color:Theme.of(context).primaryColor,
                width:double.infinity,
                child:Column(
                  children:  <Widget> [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfilePage(),
                        ),
                        );
                      },
                      child: Column (
                        children: <Widget> [
                          Container(
                            margin:EdgeInsets.only(top:30,bottom: 10),
                            width:85,
                            height:100,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image:NetworkImage("images/profille.jpg"),
                              ),
                            ),
                          ),
                          const Text(
                            "ABC",
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: const Text("Home",style: TextStyle(fontSize:17),),
                leading: Icon(Icons.home),
                onTap: () {
                  Navigator.push(context,MaterialPageRoute(builder: (c) => HomePage()));
                },
              ),
              ListTile(
                title: const Text("PostTrip For Drivers",style: TextStyle(fontSize:17),),
                leading: Icon(Icons.settings),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(context,MaterialPageRoute(builder: (c) => PostTripForDrivers()));
                },
              ),

              ListTile(
                title: const Text("Rides",style: TextStyle(fontSize:17),),
                leading: Icon(Icons.settings),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(context,MaterialPageRoute(builder: (c) => HomePage()));
                },
              ),

              ListTile(
                title: Text("Logout",style: TextStyle(fontSize:17),),
                leading: Icon(Icons.logout),
                onTap:null,
              ),


            ],
          ),
        )
    );
  }
}