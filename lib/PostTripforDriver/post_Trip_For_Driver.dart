import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostTripForDrivers extends StatefulWidget {
  const PostTripForDrivers({super.key});

  @override
  State<PostTripForDrivers> createState() => _PostTripForDriversState();


}

class _PostTripForDriversState extends State<PostTripForDrivers> {

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


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white54,
      body:
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(27.0),
          child:Column (
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

              TextField(
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

              ),

              const SizedBox(height:17),

              TextField(
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

              ),

              const SizedBox(height:17),


              TextField(
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
                onTap: () {
                  _selectDate(context);
                },
              ),

              const SizedBox(height:17),

              TextField(
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
                onTap: () {
                  _selectTime(context);
                },
              ),

              const SizedBox(height:17),

              TextField(
                controller: seatsTextEditingController,
                keyboardType: TextInputType.text,
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

              ),

              const SizedBox(height:17),

              TextField(
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
              ),


              const SizedBox(height: 20),

              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: ElevatedButton(
                  onPressed: () {
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  ),
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}