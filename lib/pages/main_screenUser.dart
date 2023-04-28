import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import 'RidesList.dart';

class mainScreenUser extends StatefulWidget {
  const mainScreenUser({Key? key}) : super(key: key);
  @override
  _mainScreenUserState createState() => _mainScreenUserState();
}

class _mainScreenUserState extends State<mainScreenUser > {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(33.89971809068136, 35.48022013654691), // initialize with default value
    zoom: 15,
  );

  List<Marker> _marker = [];

  List<Marker> _list = [];

  //In the initState method, the widget calls the _determinePosition method, which determines the user's current location
  // and updates the _kGooglePlex camera position and the _marker list with the user's location.
  // The _marker list contains a single Marker instance that represents the user's current location on the map
  @override
  void initState() {
    super.initState();
    _determinePosition().then((position) {
      // update camera position and marker with current location
      setState(() {
        _kGooglePlex = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 15,
        );

        _list = [
          Marker(
            markerId: MarkerId('1'),
            position: LatLng(33.89971809068136, 35.48022013654691),
            infoWindow: InfoWindow(
              title: 'my location',
            ),
          ),
        ];

        _marker.addAll(_list);
      });
    });
  }
// in the _determinePosition method here we get the



  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
//These variables will be used to determine whether the user has enabled location services and whether the app has permission to access the user's location.

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {

      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {

      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    //If the user has enabled location services and granted permission to the app, the function uses Geolocator.getCurrentPosition()
    // to get the user's current position.
    // and then the function returns the Future<Position> object that contains the user's position.
    return await Geolocator.getCurrentPosition();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Stack(
        children: <Widget>[
          GoogleMap(
            initialCameraPosition: _kGooglePlex,
            markers: Set<Marker>.of(_marker),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),Positioned(
            top: 50,
            right: 16,
            child: GestureDetector(
              onTap: () {
                // Navigate to profile page
              },
              child: CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('image/download.png'),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: 150,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RidesList(userId: '',)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                ),
                child: Text(
                  'Rides List',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: 50,
              height: 50,
              child: FloatingActionButton(
                onPressed: () async {
                  Position position = await _determinePosition();
                  print('my current location');
                  print(position.latitude.toString() + " " + position.longitude.toString());
                },
                backgroundColor: Colors.black,
                child: Icon(Icons.location_on),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
