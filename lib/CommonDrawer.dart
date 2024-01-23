import 'package:flutter/material.dart';
import 'Active_Trips.dart';
import 'Chatlist.dart';
import 'Current_Active_Rides.dart';
import 'Wheretogo.dart';
import 'firebase_utils.dart'; // Import your utility functions and classes
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
                  title: const Text("Chat", style: TextStyle(fontSize: 17)),
                  leading: Icon(Icons.home),
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (c) => ChatPage(id: '')));
                  },
                ),
                ListTile(
                  title: Text("Active Trips", style: TextStyle(fontSize: 17)),
                  leading: Icon(Icons.logout),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context, MaterialPageRoute(builder: (c) => ActiveTripsPage()));
                  },
                ),
                ListTile(
                  title: Text("ChatsList", style: TextStyle(fontSize: 17)),
                  leading: Icon(Icons.logout),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context, MaterialPageRoute(builder: (c) => ChatListPage(userId: getCurrentUserId() ,)));
                  },
                ),
                // ... add other ListTiles as needed
              ],
            );
          }
        },
      ),
    );
  }
}