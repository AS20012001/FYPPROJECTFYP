import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivetogether/firebase_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/CommonDrawer.dart';

class ChatPage extends StatefulWidget {
  final String id;
  @override
  _ChatPageState createState() => _ChatPageState();

  ChatPage({required this.id,Key? key}):super(key: key);
}

class _ChatPageState extends State<ChatPage> {
  final CommonDrawer commonDrawer = CommonDrawer();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final String chatId;

  TextEditingController messageTextEditingController = TextEditingController();

  final List<Message> _messages = [

  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chatId = '${widget.id}${FirebaseAuth.instance.currentUser!.uid}';
  }
  //userid+driverid

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat with Driver"),
      ),
      drawer: commonDrawer.build(context),

      body: Column(
        children: [
          _buildDriverInfo(),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _firestore.collection("chats").doc(chatId).collection("messages").orderBy("time_stamp",).snapshots(),
              builder: (context,snapshot){
                 if(snapshot.hasError)return Center(child: Text("Something went wrong"),);
                else if(!snapshot.hasData || snapshot.data!.docs.isEmpty)return Center(child: Text("Start a conversation"),);
            log("${snapshot.data!.docs[0].data()}");
            _messages.clear();
            for(var message in snapshot.data!.docs){
              _messages.insert(0, Message(text: message.data()["message"], isMe: message.data()["sender_id"] == getCurrentUserId()));
            }

                return  ListView.builder(itemCount: _messages.length, reverse: true, itemBuilder: (context,index){
                 return _buildMessage(_messages[index]);

                });

              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildDriverInfo() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Image.asset("images/image.jpg", height: 100),
          SizedBox(height: 10),

          const Text(
            "Driver Name",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Text(
            "Online",
            style: TextStyle(color: Colors.green),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(Message message) {
    return
      Align(
      alignment: message.isMe ? Alignment.bottomRight : Alignment.bottomLeft,
      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: message.isMe ? Colors.blue : Colors.grey,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          message.text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageTextEditingController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              _sendMessage();
            },
          ),
        ],
      ),
    );
  }

  void _sendMessage() async{
    String text = messageTextEditingController.text.trim();
    if (text.isNotEmpty) {
      try{

        await _firestore.collection("chats").doc(chatId).collection("messages").doc().set({"sender_id": getCurrentUserId(), "message": messageTextEditingController.text, "time_stamp": DateTime.now()});
      }catch(e){
        log(e.toString());
      }
        messageTextEditingController.clear();
    }
  }
}


class Message {
  final String text;
  final bool isMe;

  Message({
    required this.text,
    required this.isMe,
  });
}

