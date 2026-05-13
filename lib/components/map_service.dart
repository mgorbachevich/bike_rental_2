import 'dart:math';
import 'package:bike_rental_2/components/ui_service.dart';
import 'package:bike_rental_2/constants.dart';
import 'package:bike_rental_2/repository/bike.dart';
import 'package:bike_rental_2/repository/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

final MapService mapService = MapService(); // Singleton

class MapService {
  static final MapService _instance = MapService._internal();

  MapService._internal();

  factory MapService() {
    return _instance;
  }

  final MapController _mapController = MapController();
  double _currentZoom = 10;
  // Координаты пользователя:
  final double _userLatitude = 55.756081;
  final double _userLongitude = 37.637923;

  double distance(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295; // Math.PI / 180
    var a =
        0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 км
  }

  double bikeDistance(Bike? bike) {
    if (bike == null) return 0;
    return distance(
      _userLatitude,
      _userLongitude,
      bike.latitude,
      bike.longitude,
    );
  }

  List<Marker> getMarkers(Function(Bike?) onBikeClicked) {
    List<Marker> markers = [];
    for (var bike in repository.getAllFreeBikes(false)) {
      markers.add(
        Marker(
          point: LatLng(bike.latitude, bike.longitude),
          width: 40,
          height: 40,
          child: uiService.mapMarker(
            () => onBikeClicked(bike),
            primaryColor,
            Icons.pedal_bike,
          ),
        ),
      );
    }
    // Пользователь:
    markers.add(
      Marker(
        point: LatLng(_userLatitude, _userLongitude),
        width: 40,
        height: 40,
        child: uiService.mapMarker(
          () => onBikeClicked(null),
          accentColor,
          Icons.account_circle,
        ),
      ),
    );
    return markers;
  }

  void moveCenterToUser() {
    _currentZoom = _mapController.camera.zoom;
    _mapController.move(LatLng(_userLatitude, _userLongitude), _currentZoom);
  }

  void zoomIn() {
    _currentZoom = _mapController.camera.zoom;
    _mapController.move(_mapController.camera.center, _currentZoom + 1);
  }

  void zoomOut() {
    _currentZoom = _mapController.camera.zoom;
    _mapController.move(_mapController.camera.center, _currentZoom - 1);
  }

  void moveToUser() {}

  Widget getMap(Function(Bike?) onBikeClicked) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: LatLng(_userLatitude, _userLongitude),
        initialZoom: _currentZoom,
      ),
      children: [
        TileLayer(
          // Слой самой карты (плитки):
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.demo.bike_rental_2', // Нужно для OSM
        ),
        MarkerLayer(
          // Слой маркеров:
          markers: getMarkers(onBikeClicked),
        ),
      ],
    );
  }
}
