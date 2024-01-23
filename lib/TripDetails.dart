import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Rides/ChatPage.dart';
import 'firebase_utils.dart';

class TripDetailsPage extends StatelessWidget {
  final String documentId;

  TripDetailsPage({required this.documentId});

  Future<Map<String, dynamic>> fetchUserDetails(String documentId) async {
    try {
      print('Fetching user IDs from DriverTrips for documentId: $documentId');
      DocumentSnapshot tripSnapshot =
      await FirebaseFirestore.instance.collection('DriverTrips').doc(documentId).get();

      if (tripSnapshot.exists) {
        List<String?> userIds = [
          tripSnapshot['User 1 ID'],
          tripSnapshot['User 2 ID'],
          tripSnapshot['User 3 ID'],
        ];

        Map<String, dynamic> userDetails = {};

        for (int i = 1; i <= 3; i++) {
          String userIdKey = 'User $i ID';
          String seatsKey = 'User $i Seats';

          String? userId = tripSnapshot[userIdKey];

          if (userId != null) {
            try {
              print('Fetching user details for userId: $userId');
              DocumentSnapshot userSnapshot =
              await FirebaseFirestore.instance.collection('Usertable').doc(userId).get();

              if (userSnapshot.exists) {
                // Construct field name dynamically
                int? userSeats = tripSnapshot[seatsKey];

                // Check for null before accessing values
                if (userSeats != null) {
                  userDetails[userId] = {
                    'userData': userSnapshot.data(),
                    'seats': userSeats,
                  };
                } else {
                  print('Seats data is null for userId: $userId');
                }
              } else {
                print('User details not found for userId: $userId');
              }
            } catch (e) {
              print('Error fetching user details for userId: $userId - $e');
            }
          }
        }

        return userDetails;
      } else {
        return {};
      }
    } catch (e) {
      print('Error fetching user details: $e');
      return {};
    }
  }





  @override
  Widget build(BuildContext context) {
    print('Building TripDetailsPage with documentId: $documentId');
    return Scaffold(
      appBar: AppBar(
        title: Text('Trip Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<Map<String, dynamic>>(
              future: fetchUserDetails(documentId),
              builder: (context, snapshot) {
                print('User Snapshot: $snapshot');
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error loading user details');
                } else if (snapshot.hasData && (snapshot.data as Map).isNotEmpty) {
                  return buildUserCards(snapshot.data!, context);
                } else {
                  return Text('No user details available for Users');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildUserCards(Map<String, dynamic> userMap, context) {
    List<Widget> userCards = [];

    userMap.forEach((userId, userData) {
      if (userData != null && userData['userData'] != null) {
        userCards.add(buildUserCard(userData['userData'], 'User $userId', userData['seats'], context));
      }
    });

    return Column(children: userCards);
  }

  Widget buildUserCard(Map<String, dynamic> userData, String userTitle, int? seats, context) {
    return Card(
      margin: EdgeInsets.only(bottom: 18.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // First column for the image
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 50,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: Image.network(
                    userData['img_url'] ?? '',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Second column for details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Driver: ${userData['name'] ?? 'N/A'}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Gender: ${userData['gender'] ?? 'N/A'}',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Email: ${userData['email'] ?? 'N/A'}',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    // Add more details as needed

                    // Seats information
                    if (seats != null)
                      Text(
                        'Seats Booked: $seats',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ElevatedButton(
                      onPressed: () async {
                        String chatRoomId =
                            '${userData["UsersID"]}${getCurrentUserId()}';
                        final DocumentSnapshot<Map<String, dynamic>> chatRoomDoc =
                        await FirebaseFirestore.instance
                            .collection("chats")
                            .doc(chatRoomId)
                            .get();
                        if (!chatRoomDoc.exists) {
                          await FirebaseFirestore.instance
                              .collection("chats")
                              .doc(chatRoomId)
                              .set({
                            "driver_id": getCurrentUserId(),
                            "driver_name": FirebaseAuth.instance.currentUser!.displayName!,
                            "driver_image": FirebaseAuth.instance.currentUser!.photoURL!,
                            "user_id": userData["UsersID"],
                            "user_name": userData["name"],
                            "user_image": userData["img_url"],
                          });
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (c) => ChatPage(
                              id: userData["UsersID"],
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      child: const Text(
                        "Chat",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
