import 'package:flutter/material.dart';
import '../firebase_utils.dart';
import 'package:intl/intl.dart';
import '/CommonDrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostTripForDrivers extends StatefulWidget {
  const PostTripForDrivers({super.key});

  @override
  State<PostTripForDrivers> createState() => _PostTripForDriversState();
}

class _PostTripForDriversState extends State<PostTripForDrivers> {

  final CommonDrawer commonDrawer = CommonDrawer();

  TextEditingController destinationcityTextEditingController = TextEditingController();
  TextEditingController startinglocTextEditingController = TextEditingController();
  TextEditingController priceTextEditingController = TextEditingController();
  TextEditingController timeTextEditingController = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> _selectTime(BuildContext context) async {

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
        timeTextEditingController.text = picked.format(context);
      });
    }
  }

  TextEditingController seatsTextEditingController = TextEditingController();
  TextEditingController dateTextEditingController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      final formattedDate = DateFormat("dd-MM-yyyy").format(picked);
      setState(() {
        selectedDate = picked;
        dateTextEditingController.text = formattedDate;
      });
    }
  }

  int _convertToInt(String value) {
    // Use int.tryParse to safely convert the string to an integer
    // Return 0 if the conversion fails
    return int.tryParse(value) ?? 0;
  }


  Future<void> _submitForm() async {
    // Validate form entries before submitting
    if (_validateForm()) {
      // Get a reference to the "DriverTrips" collection
      CollectionReference driverTrips = FirebaseFirestore.instance.collection('DriverTrips');

      // Generate a new document with a random ID
      DocumentReference newTripRef = driverTrips.doc();

      // Get the current user's ID (you can replace this with the appropriate user ID)
      String userId = getCurrentUserId();

      // Save the trip details to Firestore
      await newTripRef.set({
        'postuserId': userId,
        'destinationCity': destinationcityTextEditingController.text.toLowerCase(),
        'startingLocation': startinglocTextEditingController.text,
        'date': dateTextEditingController.text,
        'time': timeTextEditingController.text,
        'seats': _convertToInt(seatsTextEditingController.text),
        'pricePerSeat': priceTextEditingController.text,
      });

      // Optionally, you can clear the form fields after submitting
      _clearForm();

      // Display a success message or navigate to another screen
      // For example, you can show a SnackBar with a success message:
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Trip submitted successfully!"),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // Validate form entries
  bool _validateForm() {
    // Add your validation logic here
    // Return true if the form is valid, otherwise false
    return true;
  }

  // Clear form fields after submission
  void _clearForm() {
    destinationcityTextEditingController.clear();
    startinglocTextEditingController.clear();
    dateTextEditingController.clear();
    timeTextEditingController.clear();
    seatsTextEditingController.clear();
    priceTextEditingController.clear();
  }









  final _formKeynew = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post A Trip For Drivers"),
      ),
      drawer: commonDrawer.build(context),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(27.0),
          child:Form(
            key: _formKeynew,
            child: Column (
              children: [
                const SizedBox(height:20),

                Padding(
                  padding:const EdgeInsets.all(20.0),
                  child:Image.asset("images/image.jpg",height: 120),

                ),

                const SizedBox(height:20,),

                const Text(
                  "Post A Trip for Drivers",
                  style:TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height:10,),

                const SizedBox(height:17),

                TextFormField(
                  controller: destinationcityTextEditingController,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    labelText: "Destination City",

                    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color:Colors.black),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black),
                    ),


                    labelStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your destination';
                    }
                    return null;
                  },

                ),

                const SizedBox(height:17),

                TextFormField(
                  controller: startinglocTextEditingController,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    labelText: "Starting location",

                    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color:Colors.black),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black),
                    ),

                    labelStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your starting location';
                    }
                    return null;
                  },

                ),

                const SizedBox(height:17),


                TextFormField(
                  controller: dateTextEditingController,
                  keyboardType: TextInputType.text,
                  style: const TextStyle(
                      color: Colors.black
                  ),
                  decoration: InputDecoration(
                    labelText: "Pick A Date",
                    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color:Colors.black),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black),
                    ),

                    labelStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the date';
                    }
                    return null;
                  },

                  onTap: () {
                    _selectDate(context);
                  },
                ),

                const SizedBox(height:17),

                TextFormField(
                  controller: timeTextEditingController,
                  keyboardType: TextInputType.datetime,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    labelText: "Time",

                    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color:Colors.black),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black),
                    ),


                    labelStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a time';
                    }
                    return null;
                  },
                  onTap: () {
                    _selectTime(context);
                  },
                ),

                const SizedBox(height:17),

                TextFormField(
                  controller: seatsTextEditingController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                      color: Colors.black
                  ),
                  decoration: InputDecoration(
                    labelText: "Number of Seat",
                    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color:Colors.black),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black),
                    ),


                    labelStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter number of seats available';
                    }
                    return null;
                  },

                ),

                const SizedBox(height:17),

                TextFormField(
                  controller: priceTextEditingController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                      color: Colors.black
                  ),
                  decoration: InputDecoration(
                    labelText: "Price per Seat",

                    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color:Colors.black),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black),
                    ),

                    labelStyle:const TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the price per seat';
                    }
                    return null;
                  },
                ),

                

                const SizedBox(height: 20),

                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    ),
                    child: const Text(
                      "Submit",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}