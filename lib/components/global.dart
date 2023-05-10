import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<LatLng?> getPositionFromPlace(String placeName) async {
  try {
    List<Location> locations = await locationFromAddress(placeName);
    if (locations.isNotEmpty) {
      return LatLng(locations.first.latitude, locations.first.longitude);
    } else {
      return null;
    }
  } catch (e) {
    Fluttertoast.showToast(msg: 'Error: ${e.toString()}');
    return null;
  }
}
