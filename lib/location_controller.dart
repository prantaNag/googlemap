import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationController extends GetxController {
  Position? currentLocation;
  bool locationCheck = false;
  List<LatLng> coOrdinates = [];
  Future<void> listenCurrentLocation() async {
    LocationPermission locationPermission = await Geolocator.checkPermission();

    if (locationPermission == LocationPermission.denied ||
        locationPermission == LocationPermission.deniedForever) {
      locationPermission = await Geolocator.requestPermission();
    }

    if (locationPermission == LocationPermission.always ||
        locationPermission == LocationPermission.whileInUse) {
      final bool isLocationServiceEnabled =
          await Geolocator.isLocationServiceEnabled();
      if (isLocationServiceEnabled) {
        currentLocation = await Geolocator.getCurrentPosition();

        locationCheck = true;
        update();
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.bestForNavigation,
              timeLimit: Duration(seconds: 10)),
        ).listen((p) {
          print(currentLocation.toString());
          currentLocation = p;
          coOrdinates.add(LatLng(p.latitude, p.longitude));
          update();
        });
      } else {
        listenCurrentLocation();
      }
    } else if (locationPermission == LocationPermission.deniedForever) {
      Geolocator.openAppSettings();
    }
  }
}
