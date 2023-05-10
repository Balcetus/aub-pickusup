import 'package:aub_pickusup/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import '../components/global.dart';

class MainScreenRider extends StatefulWidget {
  const MainScreenRider({Key? key}) : super(key: key);

  @override
  State<MainScreenRider> createState() => _MainScreenRiderState();
}

class _MainScreenRiderState extends State<MainScreenRider> {
  Future<LatLng>? _currentLocation;
  bool _isGoingToAUB =
      true; // Track whether the user is going to AUB or leaving AUB
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _currentLocation = _getCurrentLocation();
  }

  Future<LatLng> _getCurrentLocation() async {
    final PermissionStatus permission =
        await Permission.locationWhenInUse.status;
    if (permission != PermissionStatus.granted) {
      final permissionResult = await Permission.locationWhenInUse.request();
      if (permissionResult != PermissionStatus.granted) {
        openAppSettings();
        _showPermissionDeniedDialog();
        throw Exception('Location permission denied');
      }
    }

    Position? position;
    try {
      position = await Geolocator.getCurrentPosition();
    } on LocationServiceDisabledException {
      _showLocationServiceDisabledDialog();
      throw Exception('Location service disabled');
    } catch (e) {
      _showUnknownLocationErrorDialog();
      throw Exception('Unknown location error');
    }

    return LatLng(position.latitude, position.longitude);
  }

  void _showPermissionDeniedDialog() {
    // Show permission denied dialog
    Fluttertoast.showToast(msg: 'Permission Denied');
  }

  void _showLocationServiceDisabledDialog() {
    // Show location services disabled dialog
    Fluttertoast.showToast(msg: 'Location Service Disabled');
  }

  void _showUnknownLocationErrorDialog() {
    // Show generic location error dialog
    Fluttertoast.showToast(msg: 'Generic Location Error');
  }

  void _addAUBMarker() async {
    LatLng? position = await getPositionFromPlace('AUB Main Gate');
    if (position != null) {
      // Create a marker for AUB and add it to the set of markers
      final marker = Marker(
        markerId: const MarkerId('AUB'),
        position: position,
        infoWindow: const InfoWindow(title: 'AUB Main Gate'),
        flat: true,
      );
      setState(() {
        _markers.add(marker);
      });
    } else {
      Fluttertoast.showToast(msg: 'Failed to retrieve AUB location');
    }
  }

  void _updateMapMarkers() {
    if (_isGoingToAUB) {
      _addAUBMarker();
    } else {
      _markers.removeWhere((marker) => marker.markerId.value == 'AUB');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateMapMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LatLng>(
      future: _currentLocation,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            backgroundColor: aubRed,
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(50, 10, 0, 25),
                    child: Material(
                      color: aubRed,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          DropdownButton<bool>(
                            underline: Container(
                              height: 2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.white,
                              ),
                            ),
                            dropdownColor: Colors.black,
                            enableFeedback: true,
                            icon: const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Icon(
                                Icons.arrow_drop_down_circle_rounded,
                              ),
                            ),
                            iconSize: 20,
                            iconEnabledColor: Colors.white,
                            itemHeight: 80,
                            borderRadius: BorderRadius.circular(25),
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
                            items: const [
                              DropdownMenuItem<bool>(
                                value: true,
                                child: Text(
                                  'Going to AUB',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Jost',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              DropdownMenuItem<bool>(
                                value: false,
                                child: Text(
                                  'Leaving AUB',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Jost',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 120,
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
                              child: const CircleAvatar(
                                backgroundColor: Colors.white,
                                foregroundImage: AssetImage('assets/logo.png'),
                                radius: 25,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GoogleMap(
                      buildingsEnabled: true,
                      mapToolbarEnabled: true,
                      myLocationButtonEnabled: true,
                      myLocationEnabled: true,
                      compassEnabled: true,
                      initialCameraPosition: CameraPosition(
                        target: snapshot.data!,
                        zoom: 16.0,
                      ),
                      markers: _markers,
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
}
