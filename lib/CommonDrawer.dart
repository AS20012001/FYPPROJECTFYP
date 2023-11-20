import 'package:flutter/material.dart';
import 'firebase_utils.dart'; // Import your utility functions and classes
import 'package:flutter/material.dart';
import '/HomePage.dart';
import '/MyDrawer.dart';
import '/Profile/ProfilePage.dart';
import '/Rides/Logout.dart';
import '/Rides/Ratings.dart';
import '/Rides/Ride.dart';
import '/Rides/User.dart';
import '/PostTripforDriver/post_Trip_For_Driver.dart';
import '/Rides/ChatPage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommonDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<UserData>(
        // Use FutureBuilder to fetch user data asynchronously
        future: getUserDataFromFirestore(getCurrentUserId()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // If the Future is still running, show a loading indicator
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // If there's an error, show an error message
            return Text('Error: ${snapshot.error}');
          } else {
            // If the Future is complete, build the UI with fetched user data
            UserData userData = snapshot.data!;

            return Column(
              children: <Widget>[
                Container(
                  color: Theme.of(context).primaryColor,
                  width: double.infinity,
                  child: Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => ProfilePage()),
                          );
                        },
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 50.0),
                              child: CircleAvatar(
                                radius: 50,
                                // Use the user's image URL if available, else use a placeholder
                                backgroundImage: userData.imageUrl.isNotEmpty
                                    ? NetworkImage(userData.imageUrl)
                                    : AssetImage('images/profille.jpg')
                                        as ImageProvider,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                // Use the fetched user name
                                userData.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
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
                    Navigator.push(
                        context, MaterialPageRoute(builder: (c) => MyDrawer()));
                  },
                ),
                ListTile(
                  title: const Text("PostTrip For Drivers",
                      style: TextStyle(fontSize: 17)),
                  leading: Icon(Icons.local_taxi),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) => PostTripForDrivers()));
                  },
                ),
                ListTile(
                  title: const Text("Rides", style: TextStyle(fontSize: 17)),
                  leading: Icon(Icons.directions_car),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context, MaterialPageRoute(builder: (c) => Ridepage()));
                  },
                ),
                ListTile(
                  title: const Text("Users", style: TextStyle(fontSize: 17)),
                  leading: Icon(Icons.directions_car),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) => UserProfilePage()));
                  },
                ),
                ListTile(
                  title: const Text("Chat", style: TextStyle(fontSize: 17)),
                  leading: Icon(Icons.home),
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (c) => ChatPage()));
                  },
                ),
                ListTile(
                  title: const Text("Ratings", style: TextStyle(fontSize: 17)),
                  leading: Icon(Icons.local_taxi),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context, MaterialPageRoute(builder: (c) => Ratings()));
                  },
                ),
                ListTile(
                  title: Text("Logout", style: TextStyle(fontSize: 17)),
                  leading: Icon(Icons.logout),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context, MaterialPageRoute(builder: (c) => Logout()));
                  },
                )
                // ... add other ListTiles as needed
              ],
            );
          }
        },
      ),
    );
  }
}
