import 'package:flutter/material.dart';
import '/HomePage.dart';
import '/PostTripforDriver/post_Trip_For_Driver.dart';
import '/Rides/ChatPage.dart';
import '/Rides/Logout.dart';
import '/main.dart';
import '/CommonDrawer.dart';
import '/Profile/ProfilePage.dart';
import '/Rides/Ratings.dart';
import '/Rides/Ride.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final CommonDrawer commonDrawer = CommonDrawer();

  TextEditingController messageTextEditingController = TextEditingController();

  final List<Message> _messages = [
    Message(text: 'Hi there!', isMe: false),
    Message(text: 'Hello!?', isMe: true),
  ];

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
            child: ListView.builder(
              itemCount: _messages.length,
              reverse: true,
              itemBuilder: (context, index) {
                return _buildMessage(_messages[index]);
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
    return Align(
      alignment: message.isMe ? Alignment.topRight : Alignment.topLeft,
      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: message.isMe ? Colors.blue : Colors.blue,
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

  void _sendMessage() {
    String text = messageTextEditingController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _messages.add(Message(text: text, isMe: true));
        messageTextEditingController.clear();
      });
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

