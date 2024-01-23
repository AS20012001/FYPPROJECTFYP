import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'MyDrawer.dart';
import 'TripDetails.dart';

class ActiveTripsPage extends StatefulWidget {
  @override
  _ActiveTripsPageState createState() => _ActiveTripsPageState();
}

class _ActiveTripsPageState extends State<ActiveTripsPage> {
  late List<Map<String, dynamic>> activeTrips = [];

  @override
  void initState() {
    super.initState();
    fetchActiveTrips();
  }

  Future<void> fetchActiveTrips() async {
    String? currentUserId = await getCurrentUserId();

    if (currentUserId != null) {
      CollectionReference driverTrips = FirebaseFirestore.instance.collection('DriverTrips');

      QuerySnapshot querySnapshot = await driverTrips
          .where('postuserId', isEqualTo: currentUserId)
          .get();

      List<Map<String, dynamic>> tripsList = [];

      for (QueryDocumentSnapshot tripSnapshot in querySnapshot.docs) {
        var tripData = tripSnapshot.data();

        if (tripData != null && tripData is Map<String, dynamic>) {
          tripsList.add({
            'documentId': tripSnapshot.id,
            'Destination': tripData['destinationCity'],
            'StartLocation': tripData['startingLocation'],
            'Day': tripData['date'],
            'Time': tripData['time'],
            'NumberOfSeats': tripData['seats'],
            'PricePerSeat': double.parse(tripData['pricePerSeat'].toString()),
            'DriverName': tripData['DriverName'],
            'Rating': tripData['DriverRating'],
            'CarColor': tripData['DriverCarColor'],
            'DriverImage': tripData["DriveImg"],
            'User1ID': tripData['User 1 ID'] ?? '', // Update field name
            'User2ID': tripData['User 2 ID'] ?? '', // Update field name
            'User3ID': tripData['User 3 ID'] ?? '', // Update field name
          });
        }
      }

      setState(() {
        activeTrips = tripsList;
      });
    }
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

  Future<String?> getCurrentUserId() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      return user.uid;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Active Trips"),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              for (var trip in activeTrips)
                ExtendedTripCard(
                  Destination: trip['Destination'],
                  Rating: trip['Rating'],
                  StartLocation: trip['StartLocation'],
                  Day: trip['Day'],
                  Time: trip['Time'],
                  NumberOfSeats: trip['NumberOfSeats'],
                  PricePerSeat: trip['PricePerSeat'],
                  DriverName: trip['DriverName'],
                  CarColor: trip['CarColor'],
                  DriverImage: trip['DriverImage'],
                  documentId: trip['documentId'],
                  onCancel: () => showCancelTripPopup(context, trip['documentId']),
                  onViewDetails: () => viewTripDetails(
                    trip['documentId'],
                  ),
                  onFinishTrip: () => finishTrip(trip['documentId']),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showCancelTripPopup(BuildContext context, String documentId) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cancel Trip'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you want to cancel this trip?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                cancelTrip(documentId);
                Navigator.of(context).pop();
                showCancellationConfirmationPopup(context);
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }


  Future<void> cancelTrip(String documentId) async {
    await FirebaseFirestore.instance.collection('DriverTrips').doc(documentId).delete();
    fetchActiveTrips();
  }
  Future<void> showCancellationConfirmationPopup(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Trip Canceled'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('You have canceled this trip.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate back to the homepage
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MyDrawer()),
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void viewTripDetails(String documentId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TripDetailsPage(
          documentId: documentId,
        ),
      ),
    );
  }
  void finishTrip(String documentId) {
    // Implement logic to finish the trip based on the documentId
    // You may want to update the document status or perform other actions
  }
}

class ExtendedTripCard extends StatelessWidget {
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
  final VoidCallback onCancel;
  final VoidCallback onViewDetails;
  final VoidCallback onFinishTrip;

  ExtendedTripCard({
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
    required this.onCancel,
    required this.onViewDetails,
    required this.onFinishTrip,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: onCancel,
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
                child: const Text(
                  "Cancel Trip",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: onViewDetails,
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
                child: const Text(
                  "View Details",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: onFinishTrip,
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
                child: const Text(
                  "Finish Trip",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ActiveTripsPage(),
  ));
}
