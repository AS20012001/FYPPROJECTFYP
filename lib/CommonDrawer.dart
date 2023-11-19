import 'package:flutter/material.dart';
import '/HomePage.dart';
import '/HomePage.dart';
import '/MyDrawer.dart';
import '/Profile/ProfilePage.dart';
import '/Rides/Logout.dart';
import '/Rides/Ratings.dart';
import '/Rides/Ride.dart';
import '/Rides/User.dart';
import '/PostTripforDriver/post_Trip_For_Driver.dart';
import '/Rides/ChatPage.dart';

class CommonDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            color: Theme.of(context).primaryColor,
            width: double.infinity,
            child: Column(
              children: <Widget>[
                // Profile Section
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ProfilePage()),
                    );
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 30, bottom: 10),
                        width: 85,
                        height: 100,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage("images/profille.jpg"),
                          ),
                        ),
                      ),
                      const Text(
                        "ABC",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        "Email@gmail.com",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // List of ListTiles
          ListTile(
            title: const Text("Home", style: TextStyle(fontSize: 17)),
            leading: Icon(Icons.home),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (c) => MyDrawer()));
            },
          ),
          ListTile(
            title: const Text("PostTrip For Drivers", style: TextStyle(fontSize: 17)),
            leading: Icon(Icons.local_taxi),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(context, MaterialPageRoute(builder: (c) => PostTripForDrivers()));
            },
          ),
          ListTile(
            title: const Text("Rides", style: TextStyle(fontSize: 17)),
            leading: Icon(Icons.directions_car),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(context, MaterialPageRoute(builder: (c) => Ridepage()));
            },
          ),
          ListTile(
            title: const Text("Users", style: TextStyle(fontSize: 17)),
            leading: Icon(Icons.directions_car),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(context, MaterialPageRoute(builder: (c) => UserProfilePage()));
            },
          ),
          ListTile(
            title: const Text("Chat", style: TextStyle(fontSize: 17)),
            leading: Icon(Icons.home),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (c) => ChatPage()));
            },
          ),
          ListTile(
            title: const Text("Ratings", style: TextStyle(fontSize: 17)),
            leading: Icon(Icons.local_taxi),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(context, MaterialPageRoute(builder: (c) => Ratings()));
            },
          ),
          ListTile(
            title: Text("Logout", style: TextStyle(fontSize: 17)),
            leading: Icon(Icons.logout),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(context, MaterialPageRoute(builder: (c) => Logout()));
            },
          ),
        ],
      ),
    );
  }
}
