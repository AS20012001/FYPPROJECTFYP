import 'package:drivetogether/firebase_utils.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/CommonDrawer.dart';
import 'Rides/ChatPage.dart';

class ChatListPage extends StatefulWidget {
  final String userId;

  ChatListPage({required this.userId, Key? key}) : super(key: key);

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final CommonDrawer commonDrawer = CommonDrawer();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat List"),
      ),
      drawer: commonDrawer.build(context),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _firestore.collection("chats").where("driver_id",isEqualTo: getCurrentUserId()).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text("Something went wrong"),);
          else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return Center(child: Text("No chats available"),);

          var chats = snapshot.data!.docs;

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              var chat = chats[index];

              // Determine the other user ID from the chat ID


              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(chats[index].data()["user_image"]),
                ),
                title: Text("Chat with ${chats[index].data()["user_name"]}"),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(id: chats[index].data()["user_id"]),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
