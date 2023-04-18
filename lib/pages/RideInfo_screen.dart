
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RideInfoScreen extends StatefulWidget {
  final String placeName;
  final double latitude;
  final double longitude;
  final String userId;

  const RideInfoScreen({
    Key? key,
    required this.placeName,
    required this.latitude,
    required this.longitude,
    required this.userId,
  }) : super(key: key);

  @override
  _RideInfoScreenState createState() => _RideInfoScreenState();
}

class _RideInfoScreenState extends State<RideInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _rideTimeController = TextEditingController();
  final _numberOfPassengersController = TextEditingController();
  final _phoneNumberController = TextEditingController();

//The _saveRideInfo function saves the entered ride information to a Firestore collection called rides using the
// widget.userId as the document ID.
  Future<void> _saveRideInfo() async {
    final rideInfo = {
      'placeName': widget.placeName,
      'latitude': widget.latitude,
      'longitude': widget.longitude,
      'rideTime': _rideTimeController.text,
      'numberOfPassengers': _numberOfPassengersController.text,
      'phoneNumber': _phoneNumberController.text,
    };

    final rideInfoRef = FirebaseFirestore.instance.collection('rides').doc(widget.userId);
    await rideInfoRef.set(rideInfo);

  }
  static const Color aubColor = Color.fromRGBO(166, 27, 46, 1.0);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Ride Info',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),),
        backgroundColor: aubColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Destination:',

                  style: TextStyle(fontSize: 18,color: aubColor,
                    fontWeight: FontWeight.bold,),
                ),

                SizedBox(height: 8),
                Text(widget.placeName,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),),
                SizedBox(height: 16),

                TextFormField(
                  controller: _rideTimeController,
                  decoration: InputDecoration(
                    labelText: 'Ride Time',
                    prefixIcon: Icon(
                      Icons.timer,
                      color: Colors.black,
                    )
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                    // Add separator character after every 2 digits
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      final text = newValue.text;

                      if (text.length == 1) {
                        final hour = int.parse(text);
                        if (hour > 2) {
                          return oldValue;
                        }
                      }

                      if (text.length == 2) {
                        final hour = int.parse(text.substring(0, 2));
                        if (hour > 23) {
                          return oldValue;
                        }
                        return TextEditingValue(
                          text: '$text:',
                          selection: TextSelection.collapsed(offset: text.length + 1),
                        );
                      }

                      return newValue;
                    }),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the ride time';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _numberOfPassengersController,
                  decoration: InputDecoration(
                    labelText: 'Number of Passengers',
                      prefixIcon: Icon(
                        Icons.people,
                        color: Colors.black,
                      )
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {//to range the number of passengers between 1 and 4
                    if (value == null || value.isEmpty) {
                      return 'Please enter the number of passengers';
                    } else if (int.tryParse(value) == null || int.tryParse(value)! < 1 || int.tryParse(value)! > 4) {
                      return 'Please enter a number between 1 and 4';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _phoneNumberController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                      prefixIcon: Icon(
                        Icons.phone,
                        color: Colors.black,
                      )
                  ),

                  keyboardType: TextInputType.phone, // Set the keyboardType to TextInputType.phone
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 32),
                ElevatedButton(

                  onPressed: () {//The ElevatedButton at the bottom of the form triggers the _saveRideInfo function when pressed.
                    if (_formKey.currentState!.validate()) {
                      _saveRideInfo().then((_) {
                        Navigator.pop(context);
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary:  aubColor, // background color
                  ),
                  child:  Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
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
