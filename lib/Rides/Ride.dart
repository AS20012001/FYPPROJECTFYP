import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../bookride.dart';

class Ridepage extends StatefulWidget {
  final String destination;
  final String date;

  Ridepage({required this.destination, required this.date});

  @override
  _RidepageState createState() => _RidepageState();
}

class _RidepageState extends State<Ridepage> {
  late List<Map<String, dynamic>> rides = [];

  @override
  void initState() {
    super.initState();
    fetchTrips();
  }

  Future<void> fetchTrips() async {
    CollectionReference driverTrips = FirebaseFirestore.instance.collection('DriverTrips');

    QuerySnapshot querySnapshot = await driverTrips
        .where('destinationCity', isEqualTo: widget.destination)
        .where('date', isEqualTo: widget.date)
        .get();

    List<Map<String, dynamic>> ridesList = [];

    for (QueryDocumentSnapshot tripSnapshot in querySnapshot.docs) {
      var tripData = tripSnapshot.data();

      if (tripData != null && tripData is Map<String, dynamic>) {
        var postuserId = tripData['postuserId'];

        DocumentSnapshot driverSnapshot = await FirebaseFirestore.instance.collection('drivers').doc(postuserId).get();
        var driverData = driverSnapshot.data();

        if (driverData != null && driverData is Map<String, dynamic>) {
          var imageUrl = await fetchDriverImage(postuserId);

          ridesList.add({
            'documentId': tripSnapshot.id,
            'Destination': tripData['destinationCity'],
            'StartLocation': tripData['startingLocation'],
            'Day': tripData['date'],
            'Time': tripData['time'],
            'NumberOfSeats': tripData['seats'],
            'PricePerSeat': double.parse(tripData['pricePerSeat'].toString()),
            'DriverName': driverData['name'],
            'Rating': driverData['rating'],
            'CarColor': driverData['carColor'],
            'DriverImage': imageUrl,
          });
        }
      }
    }

    setState(() {
      rides = ridesList;
    });
  }

  Future<String> fetchDriverImage(String userId) async {
    try {
      var imageUrl = await firebase_storage.FirebaseStorage.instance
          .ref('drivers/$userId.jpg')
          .getDownloadURL();
      return imageUrl;
    } catch (e) {
      // Handle error, return a default image URL, or leave it empty based on your requirements.
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ride Profile"),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 0, left: 30, right: 30, bottom: 30),
          child: Column(
            children: [
              const SizedBox(height: 20),
              for (var ride in rides)
                ExtendedRideCard(
                  documentId: ride['documentId'],
                  Destination: ride['Destination'],
                  Rating: ride['Rating'],
                  StartLocation: ride['StartLocation'],
                  Day: ride['Day'],
                  Time: ride['Time'],
                  NumberOfSeats: ride['NumberOfSeats'],
                  PricePerSeat: ride['PricePerSeat'],
                  DriverName: ride['DriverName'],
                  CarColor: ride['CarColor'],
                  DriverImage: ride['DriverImage'],
                  onPressed: () {
                    _navigateToBookRidePage(ride);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToBookRidePage(Map<String, dynamic> rideDetails) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookRidePage(rideDetails: rideDetails),
      ),
    );
  }
}

class ExtendedRideCard extends StatelessWidget {
  final String Destination;
  final String StartLocation;
  final String Day;
  final String Time;
  final int NumberOfSeats;
  final double PricePerSeat;
  final String DriverName;
  final String CarColor;
  final String DriverImage;
  final String documentId;
  final int Rating;

  final VoidCallback onPressed;

  ExtendedRideCard({
    required this.Destination,
    required this.StartLocation,
    required this.Day,
    required this.Time,
    required this.NumberOfSeats,
    required this.PricePerSeat,
    required this.DriverName,
    required this.CarColor,
    required this.DriverImage,
    required this.documentId,
    required this.Rating,
    required this.onPressed,
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 60,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: Image.network(
                  DriverImage,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          ListTile(
            title: Text('Driver: $DriverName'),
            subtitle: Text('Car Color: $CarColor'),
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
          const SizedBox(height: 20),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  ),
                  child: const Text(
                    "Book Now",
                    style: TextStyle(
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
