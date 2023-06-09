import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart';
import 'directions_model.dart';

class DirectionsRepository {
  static const _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';

  final Dio _dio;
  DirectionsRepository({Dio? dio}) : _dio = dio ?? Dio();

  Future<Directions> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final response = await _dio.get(_baseUrl, queryParameters: {
      'origin': '${origin.latitude},${origin.longitude}',
      'destination': '${destination.latitude},${destination.longitude}',
      'key': 'AIzaSyA3P32nwk5k221Yur-pk3ntVthW-asp6SU',
    });

    if (response.statusCode == 200) {
      return Directions.fromMap(response.data);
    } else {
      throw Exception('Failed to load directions');
    }
  }
}
