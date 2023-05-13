import 'dart:ui';

import 'package:aub_pickusup/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import '../components/directions_model.dart';
import '../components/directions_repository.dart';
import '../components/global.dart';

class MainScreenRider extends StatefulWidget {
  const MainScreenRider({Key? key}) : super(key: key);

  @override
  State<MainScreenRider> createState() => _MainScreenRiderState();
}

// Main Screen for the Rider user type (the user who is requesting a ride)
class _MainScreenRiderState extends State<MainScreenRider> {
  late GoogleMapController mapController;
  Future<LatLng>? _currentLocation; // Track the current location of the user
  bool _isGoingToAUB =
      true; // Track whether the user is going to AUB or leaving AUB
  final Set<Marker> _markers = {};
  late Directions _info = Directions(
    bounds: LatLngBounds(
      southwest: const LatLng(0, 0),
      northeast: const LatLng(0, 0),
    ), //
    polylinePoints: [],
    totalDistance: '',
    totalDuration: '',
  );

  @override
  void initState() {
    super.initState();
    _currentLocation = _getCurrentLocation();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<LatLng> _getCurrentLocation() async {
    // ask for location permission and get the current location of the user
    final PermissionStatus permission =
        await Permission.locationWhenInUse.status;
    switch (permission) {
      case PermissionStatus.granted:
        // Permission granted, continue with location retrieval
        break;
      case PermissionStatus.denied:
        // Permission denied, show permission denied dialog
        Fluttertoast.showToast(msg: 'Permission Denied');
        openAppSettings();
        throw Exception('Location permission denied');
      case PermissionStatus.permanentlyDenied:
        // Permission permanently denied, show permission denied dialog and open app settings
        Fluttertoast.showToast(msg: 'Permission permanently denied');
        openAppSettings();
        throw Exception('Location permission permanently denied');
      case PermissionStatus.restricted:
        // Permission restricted, show permission restricted dialog
        Fluttertoast.showToast(msg: 'Permission Restricted');
        openAppSettings();
        throw Exception('Location permission restricted');
      case PermissionStatus.limited:
        Fluttertoast.showToast(msg: 'Permission limited');
        openAppSettings();
        throw Exception('Location permission limited');
    }

    Position? position;
    try {
      position = await Geolocator.getCurrentPosition();
    } on LocationServiceDisabledException {
      Fluttertoast.showToast(msg: 'Location Service Disabled');
      throw Exception('Location service disabled');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Generic Location Error $e');
      throw Exception('Unknown location error');
    }

    return LatLng(position.latitude, position.longitude);
  }

  // add AUB marker to the map and set the camera to show the route from the current location to AUB
  void _addAUBMarker() async {
    LatLng? position = await getPositionFromPlace('AUB Main Gate');
    if (position != null) {
      // Create a marker for AUB and add it to the set of markers
      final marker = Marker(
        icon: await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(
            size: Size(256, 256),
          ),
          'assets/logo_icon.png',
        ),
        markerId: const MarkerId('AUB'),
        position: position,
        infoWindow: const InfoWindow(title: 'AUB Main Gate'),
        flat: true,
      );

      setState(() {
        _markers.add(marker);
      });
      // get directions from current location to AUB
      final directions = await DirectionsRepository().getDirections(
        origin: await _currentLocation as LatLng,
        destination: position,
      );
      setState(() {
        _info =
            directions; // update the directions info to show the route on the map and the distance and duration
      });
      mapController.animateCamera(
        CameraUpdate.newLatLngBounds(_info.bounds, 100),
      ); // set the camera to show the route from the current location to AUB with a padding of 100 pixels
    } else {
      Fluttertoast.showToast(
        msg: 'Failed to retrieve AUB location',
      );
    }
  }

  void _updateMapMarkers() {
    // update the map markers when the user changes the direction (going to AUB or leaving AUB)
    if (_isGoingToAUB) {
      _addAUBMarker();
    } else {
      _markers.removeWhere((marker) => marker.markerId.value == 'AUB');
      setState(() {
        _info = Directions(
          bounds: LatLngBounds(
            southwest: const LatLng(0, 0),
            northeast: const LatLng(0, 0),
          ),
          polylinePoints: [],
          totalDistance: '',
          totalDuration: '',
        );
      });
    }
  }

  @override
  void didChangeDependencies() {
    // update the map markers when the user changes the direction (going to AUB or leaving AUB)
    super.didChangeDependencies();
    _updateMapMarkers();
  }

  bool _showRides = false; // Track whether to show the available rides list

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LatLng>(
      future: _currentLocation,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SafeArea(
            child: Scaffold(
              floatingActionButton: FloatingActionButton(
                heroTag: 's',
                tooltip: 'Show Available Rides',
                enableFeedback: true,
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                onPressed: () {
                  setState(() {
                    _showRides = !_showRides;
                  });
                },
                child: _showRides
                    ? const Icon(Icons.close)
                    : const Icon(
                        Icons.directions_car,
                      ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              bottomNavigationBar: _showRides
                  ? _buildRidesList()
                  : null, // show available rides list when the user taps on the floating action button
              body: Stack(
                alignment: Alignment.center,
                children: [
                  GoogleMap(
                    padding: const EdgeInsets.only(
                      top: 150,
                      right: 6,
                      left: 6,
                      bottom: 6,
                    ),
                    onMapCreated: _onMapCreated,
                    buildingsEnabled: true,
                    mapToolbarEnabled: true,
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    compassEnabled: true,
                    zoomGesturesEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target: snapshot.data!,
                      zoom: 16.0,
                    ),
                    markers: _markers,
                    polylines: {
                      Polyline(
                        polylineId: const PolylineId('aub_polyline'),
                        points: _info.polylinePoints
                            .map((e) => LatLng(e.latitude, e.longitude))
                            .toList(),
                        color: aubRed,
                        width: 6,
                        startCap: Cap.roundCap,
                        endCap: Cap.roundCap,
                      ),
                    },
                  ),
                  Positioned(
                    top: 160,
                    child: _info.polylinePoints.isNotEmpty
                        ? Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: aubRed,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              textAlign: TextAlign.center,
                              '${_info.totalDistance}\n${_info.totalDuration}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Jost',
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          )
                        : Container(),
                  ),
                  Positioned(
                    top: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 150,
                      padding: const EdgeInsets.only(bottom: 15),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.elliptical(70, 40),
                          bottomRight: Radius.elliptical(70, 40),
                        ),
                        color: aubRed,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(40),
                              border: Border.all(
                                width: 2.0,
                                color: Colors.white,
                              ),
                            ),
                            child: DropdownButton<bool>(
                              underline: Container(
                                height: 0,
                              ),
                              enableFeedback: true,
                              icon: const Icon(
                                color: aubRed,
                                size: 25,
                                Icons.arrow_drop_down_circle_rounded,
                              ),
                              itemHeight: 75,
                              elevation: 6,
                              borderRadius: BorderRadius.circular(40),
                              value: _isGoingToAUB,
                              onChanged: (newValue) {
                                if (mounted) {
                                  setState(
                                    () {
                                      _isGoingToAUB = newValue!;
                                      _updateMapMarkers();
                                    },
                                  );
                                }
                              },
                              items: [
                                DropdownMenuItem<bool>(
                                  value: true,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                    ),
                                    child: Text(
                                      'Going to AUB',
                                      style: TextStyle(
                                        color: aubRed,
                                        fontFamily: 'Jost',
                                        fontWeight: _isGoingToAUB
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                DropdownMenuItem<bool>(
                                  value: false,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0,
                                    ),
                                    child: Text(
                                      'Leaving AUB',
                                      style: TextStyle(
                                        color: aubRed,
                                        fontFamily: 'Jost',
                                        fontWeight: _isGoingToAUB
                                            ? FontWeight.normal
                                            : FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkResponse(
                            onTap: () {
                              Navigator.pushNamed(context, '/profile');
                            },
                            highlightShape: BoxShape
                                .circle, // Set the splash shape to CircleBorder
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 3.0,
                                  color: Colors.white,
                                ),
                              ),
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                foregroundImage: const AssetImage(
                                  'assets/logo.png',
                                ),
                                radius: 35,
                                onForegroundImageError:
                                    (exception, stackTrace) {
                                  Fluttertoast.showToast(
                                    msg:
                                        'Error loading profile picture: $exception',
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          return SafeArea(
            child: Scaffold(
              backgroundColor: aubRed,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    LoadingAnimationWidget.halfTriangleDot(
                      color: Colors.white,
                      size: 60,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Fetching Location',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.w100,
                        letterSpacing: 1,
                        height: 2,
                        fontFamily: 'Jost',
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  // TODO: implement a way to show available rides using firestore
  Widget _buildRidesList() {
    // show available rides list when the user taps on the floating action button
    return Container(
      height: 350,
      color: Colors.white,
      child: ListView.builder(
        itemCount: 5, // Number of available rides
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.fromLTRB(10, 30, 10, 30),
            margin: const EdgeInsets.fromLTRB(15, 8, 15, 8),
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
              color: aubRed,
            ),
            child: ListTile(
              onTap: () {
                // TODO: show current driver location on map and draw a route from the rider's current location to the driver's current location using firestore
              },
              leading: const CircleAvatar(
                radius: 25,
                // TODO: add driver profile picture
              ),
              title: Row(
                children: [
                  Text(
                    'Driver $index',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    ' - Current Location $index',
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      color: aubGrey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
