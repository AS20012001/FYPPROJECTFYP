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


class Ridepage extends StatefulWidget {

  @override
  State<Ridepage> createState() => _RidepageState();
}

class _RidepageState extends State<Ridepage> {

  final CommonDrawer commonDrawer = CommonDrawer();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("Ride Profile"),
      ),
      drawer: commonDrawer.build(context),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
        child: Padding(
        padding: EdgeInsets.only(top:0,left:30,right:30,bottom:30),
        child:Column(
        children: [
        const SizedBox(height:40),

        Padding(
        padding:const EdgeInsets.all(6.0),
        child: CircleAvatar(radius:60, child
            : Image.asset("images/profille.jpg")),
        ),

        const SizedBox(height:20),
          RideCard(
            DriverName: 'Ali',
            CarType: 'Civic',
            DriverImage: 'assets/img.jpng',
            Destination: 'Destination A',
            StartLocation: 'Start Location B',
            Day: 'Monday',
            Time: '10:00 AM',
            NumberOfSeats: 3,
            PricePerSeat: 10.0,
          ),
        ],
        ),
        ),
        ),
    );
  }
}
class RideCard extends StatelessWidget {
  final String DriverName;
  final String DriverImage;
  final String Destination;
  final String StartLocation;
  final String Day;
  final String CarType;
  final String Time;
  final int NumberOfSeats;
  final double PricePerSeat;


  RideCard({
    required this.DriverName,
    required this.CarType,
    required this.DriverImage,
    required this.Destination,
    required this.StartLocation,
    required this.Day,
    required this.Time,
    required this.NumberOfSeats,
    required this.PricePerSeat,

  });

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.only(bottom: 18.0),
        elevation: 4.0,
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
    ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          // Image.asset("images/img.jpeg",height: 100),

          ListTile(
            title: Text('Driver: $DriverName'),
            subtitle: Text('Car Type: $CarType'),
          ),
          ListTile(
            title: Text('Destination: $Destination'),
            subtitle: Text('Start Location: $StartLocation'),
          ),
          ListTile(
            title: Text('Day: $Day'),
            subtitle: Text('Time: $Time'),
          ),
          ListTile(
            title: Text('Seats Available: $NumberOfSeats'),
            subtitle: Text('Price per Seat: \$${PricePerSeat.toStringAsFixed(2)}'),
          ),


          const SizedBox(height:20),
        Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: ElevatedButton(
              onPressed:() {
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
              child: const Text(
                "Book Now",
                style:TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
        ),
        ],
        ),
    );
  }
}
