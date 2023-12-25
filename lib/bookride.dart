import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookRidePage extends StatelessWidget {
  final Map<String, dynamic> rideDetails;

  BookRidePage({required this.rideDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book Ride"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RideDetailsCard(rideDetails: rideDetails),
      ),
      // Add additional booking logic or UI as needed
    );
  }
}

class RideDetailsCard extends StatefulWidget {
  final Map<String, dynamic> rideDetails;

  RideDetailsCard({required this.rideDetails});

  @override
  _RideDetailsCardState createState() => _RideDetailsCardState();
}

class _RideDetailsCardState extends State<RideDetailsCard> {
  int selectedSeats = 1;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
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
                  widget.rideDetails['DriverImage'],
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          ListTile(
            title: Text('Driver: ${widget.rideDetails['DriverName']}'),
            subtitle: Text('Car Color: ${widget.rideDetails['CarColor']}'),
          ),
          ListTile(
            title: Text('Destination: ${widget.rideDetails['Destination']}'),
            subtitle:
            Text('Start Location: ${widget.rideDetails['StartLocation']}'),
          ),
          ListTile(
            title: Text('Day: ${widget.rideDetails['Day']}'),
            subtitle: Text('Time: ${widget.rideDetails['Time']}'),
          ),
          ListTile(
            title:
            Text('Seats Available: ${widget.rideDetails['NumberOfSeats']}'),
            subtitle: Text(
                'Price per Seat: \$${widget.rideDetails['PricePerSeat'].toStringAsFixed(2)}'),
          ),
          ListTile(
            title: Text('Rating: ${widget.rideDetails['Rating'].toString()}'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Adjust the alignment as needed
            children: [
              Expanded(
                child: ListTile(
                  title: Text('Select Number of Seats:'),
                  subtitle: DropdownButton<int>(
                    value: selectedSeats,
                    onChanged: (value) {
                      setState(() {
                        selectedSeats = value!;
                      });
                    },
                    items: [1, 2, 3].map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }).toList(),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  bookRide(widget.rideDetails['documentId'], selectedSeats);
                  // Add your booking logic here
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
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
            ],
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Adjust the alignment as needed
            children: [
              ElevatedButton(
                onPressed: () {
                  // Add your chat logic here
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text(
                  "Chat Now",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Add your "View On Map" logic here
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text(
                  "View On Map",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Future<void> bookRide(String documentId, int selectedSeats) async {
    String? currentUserId = await getCurrentUserId();

    if (currentUserId != null) {
      CollectionReference driverTrips = FirebaseFirestore.instance.collection('DriverTrips');

      DocumentSnapshot tripSnapshot = await driverTrips.doc(documentId).get();
      var tripData = tripSnapshot.data() as Map<String, dynamic>?;

      if (tripData != null) {
        int availableSeats = tripData['seats'] ?? 0;

        if (availableSeats >= selectedSeats) {
          // Check if there are enough available seats

          if (tripData['User 1 ID'] == null) {
            // User 1 ID and Seats
            await driverTrips.doc(documentId).update({
              'User 1 ID': currentUserId,
              'User 1 Seats': selectedSeats,
              'seats': availableSeats - selectedSeats,
            });
          } else if (tripData['User 2 ID'] == null && tripData['User 1 ID'] != currentUserId) {
            // User 2 ID and Seats
            await driverTrips.doc(documentId).update({
              'User 2 ID': currentUserId,
              'User 2 Seats': selectedSeats,
              'seats': availableSeats - selectedSeats,
            });
          } else if (tripData['User 3 ID'] == null && tripData['User 1 ID'] != currentUserId && tripData['User 2 ID'] != currentUserId) {
            // User 3 ID and Seats
            await driverTrips.doc(documentId).update({
              'User 3 ID': currentUserId,
              'User 3 Seats': selectedSeats,
              'seats': availableSeats - selectedSeats,
            });
          } else if (tripData['User 1 ID'] == currentUserId || tripData['User 2 ID'] == currentUserId || tripData['User 3 ID'] == currentUserId) {
            // User has already booked this trip
            showPopup("You've already booked this trip");
            return; // Exit the function to prevent showing the success popup
          }

          // Show success popup
          showSuccessPopup(context);
        } else {
          showPopup("Not enough available seats. Please choose a smaller number.");
        }
      }
    } else {
      print('User is not authenticated.');
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

  void showSuccessPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Booking Successful"),
          content: Text("You have successfully booked a trip."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
  void showPopup(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Booking Failed"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
