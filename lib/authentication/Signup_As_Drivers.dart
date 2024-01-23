import 'package:drivetogether/MyDrawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../otp_HomePage.dart';
import '/PostTripforDriver/post_Trip_For_Driver.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController cnicTextEditingController = TextEditingController();
  TextEditingController CarModelTextEditingController = TextEditingController();
  TextEditingController CarNumberTextEditingController =
      TextEditingController();
  TextEditingController CarColorTextEditingController = TextEditingController();

  List<String> genderTypeList = ["Male", "Female"];
  String? selectedgenderType;

  File? _image;

  Future<void> _getImageFromGallery() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> saveUserDataToFirestore(String userId, String imageUrl) async {
    CollectionReference drivers = FirebaseFirestore.instance.collection('drivers');


    await drivers.doc(userId).set({
      'name': nameTextEditingController.text,
      'email': emailTextEditingController.text,
      'cnic': cnicTextEditingController.text,
      'gender': selectedgenderType,
      'carModel': CarModelTextEditingController.text,
      'carNumber': CarNumberTextEditingController.text,
      'carColor': CarColorTextEditingController.text,
      'rating': 5,
      "img_url":imageUrl,
    });
  }

  // Function to get the current user ID
  String getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid ?? '';
  }

  Future<String> uploadImageToFirebaseStorage() async {
    if (_image == null) return ''; // No image selected

    final firebase_storage.Reference storageReference =
        firebase_storage.FirebaseStorage.instance
            .ref()
            .child('drivers') // Change 'user_images' to 'drivers'
            .child('${getCurrentUserId()}.jpg');

    final firebase_storage.UploadTask uploadTask =
        storageReference.putFile(_image!);
    await uploadTask.whenComplete(() => null);

    return await storageReference.getDownloadURL();
  }

  Future<void> _uploadImageAndSubmit() async {
    // Get the picked file from the gallery
    if (_image == null) {
      // Handle the case where no image is selected
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please select an image."),
            duration: Duration(seconds: 2),
          ),
        );
      return;
    }
    String imageUrl = await uploadImageToFirebaseStorage();

    // Save user data (including image URL) to Firestore
    await saveUserDataToFirestore(getCurrentUserId(), imageUrl).then((value) {
    FirebaseAuth.instance.currentUser!.updateDisplayName(nameTextEditingController.text);
    FirebaseAuth.instance.currentUser!.updatePhotoURL(imageUrl);
  });
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Image.asset("images/image.jpg", height: 120),
                ),
                const Text(
                  "Signup as a Driver",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Driver Details",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 17),
                TextFormField(
                  controller: nameTextEditingController,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: "Name",
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black),
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
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 17),
                TextFormField(
                  controller: emailTextEditingController,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: "Email",
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black),
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
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 17),
                TextFormField(
                  controller: cnicTextEditingController,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: "CNIC No",
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black),
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
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 17,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: DropdownButton(
                    dropdownColor: Colors.white,
                    hint: const Text(
                      "Gender",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black,
                      ),
                    ),
                    value: selectedgenderType,
                    onChanged: (newValue) {
                      setState(() {
                        selectedgenderType = newValue.toString();
                      });
                    },
                    items: genderTypeList.map((gender) {
                      return DropdownMenuItem(
                        child: Text(
                          gender,
                          style: TextStyle(color: Colors.black),
                        ),
                        value: gender,
                      );
                    }).toList(),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: ElevatedButton(
                    onPressed: () {
                      _getImageFromGallery();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    ),
                    child: const Text(
                      "Select Image",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if (_image != null)
                  Image.file(_image!)
                else
                  Text("No Image Selected"),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Car Details",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 17,
                ),
                TextFormField(
                  controller: CarModelTextEditingController,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: "Car Model",
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    labelStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 17,
                ),
                TextFormField(
                  controller: CarNumberTextEditingController,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: "Car Number",
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    labelStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 17,
                ),
                TextFormField(
                  controller: CarColorTextEditingController,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: "Car Color",
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    labelStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate() && _image != null) {
                        _uploadImageAndSubmit();
                        // Show a snackbar message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Your form has been filled."),
                            duration: Duration(seconds: 3),
                          ),
                        );
                        await Future.delayed(Duration(seconds: 3));

                        // Navigate to HomePage after 3 seconds
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => MyDrawer()));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    ),
                    child: const Text(
                      "Signup",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
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
