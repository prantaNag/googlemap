import 'package:googlemap/location_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Assignment10 extends StatefulWidget {
  const Assignment10({super.key});

  @override
  State<Assignment10> createState() => _Assignment10State();
}

class _Assignment10State extends State<Assignment10> {
  GoogleMapController? _mapController;

  Future<void> _getLocation() async {
    await Get.find<LocationController>().listenCurrentLocation();
  }

  @override
  void initState() {
    _getLocation();
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    Get.find<LocationController>().addListener(() {
      _animateToUser();
    });
  }

  void _animateToUser() {
    final locationController = Get.find<LocationController>();
    if (locationController.currentLocation != null && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              locationController.currentLocation!.latitude,
              locationController.currentLocation!.longitude,
            ),
            zoom: 14.0,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location'),
        centerTitle: true,
        backgroundColor: Colors.yellowAccent,
      ),
      body: Center(
        child: GetBuilder<LocationController>(
          builder: (lController) {
            if (!lController.locationCheck ||
                lController.currentLocation == null) {
              return const CircularProgressIndicator();
            }
            return GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(lController.currentLocation!.latitude,
                    lController.currentLocation!.longitude),
                zoom: 16,
              ),
              polylines: {
                Polyline(
                  polylineId: const PolylineId('line'),
                  width: 8,
                  color: Colors.blueGrey,
                  visible: true,
                  points: lController.coOrdinates,
                ),
              },
              markers: {
                Marker(
                  markerId: const MarkerId('trying'),
                  visible: true,
                  position: LatLng(lController.currentLocation!.latitude,
                      lController.currentLocation!.longitude),
                  infoWindow: InfoWindow(
                    title: 'My current location',
                    snippet:
                        'Latitude: ${lController.currentLocation!.latitude}, Longitude: ${lController.currentLocation!.longitude}',
                  ),
                ),
              },
            );
          },
        ),
      ),
    );
  }
}
