import 'package:flutter/material.dart';
import '/MyDrawer.dart';
import '/HomePage.dart';
import '/PostTripforDriver/post_Trip_For_Driver.dart';
import '/Profile/ProfilePage.dart';
import '/Rides/ChatPage.dart';
import '/Rides/Logout.dart';
import '/Rides/Ratings.dart';
import '/Rides/Ride.dart';
import '/Rides/User.dart';
import '/CommonDrawer.dart';
import '/main.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final CommonDrawer commonDrawer = CommonDrawer();


  TextEditingController whereTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: commonDrawer.build(context),

      appBar: PreferredSize(
        preferredSize: Size.fromHeight(150),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [ Image.asset('images/image.jpg',height: 120),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 17),

            TextField(
              showCursor: false,
              autofocus: false,
              controller: whereTextEditingController,
              style: const TextStyle(
                  color: Colors.black
              ),
              decoration: InputDecoration(
                labelText: "Where To Go?",
                contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color:Colors.black),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.black),
                ),

                labelStyle: const  TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                ),
                suffixIcon: Icon(Icons.search),
              ),

            ),

          ],
        ),
      ),

    );
  }
}
