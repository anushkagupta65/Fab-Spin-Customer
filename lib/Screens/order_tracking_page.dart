import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({super.key});

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  final Completer<GoogleMapController> _controller = Completer();
  static const LatLng destination = LatLng(29.602100, 77.363700);
  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocation;
  String remainingTime = '';


  void getCurrentLocation() async {
    Location location = Location();

    // Check if location services are enabled
    bool _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        print('Location service not enabled');
        return;
      }
    }

    // Check location permissions
    PermissionStatus _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        print('Location permission not granted');
        return;
      }
    }

    try {
      // Fetch the current location
      currentLocation = await location.getLocation();
      print('Current location: ${currentLocation!.latitude}, ${currentLocation!.longitude}');
      setState(() {});

      GoogleMapController googleMapController = await _controller.future;

      // Listen to location changes
      location.onLocationChanged.listen((newLoc) {
        if (newLoc.latitude != null && newLoc.longitude != null) {
          currentLocation = newLoc;
          googleMapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                zoom: 16,
                target: LatLng(
                  newLoc.latitude!,
                  newLoc.longitude!,
                ),
              ),
            ),
          );
          updatePolyline(); // Update the polyline whenever location changes
          calculateRemainingTime(); // Calculate the remaining time to reach destination
          setState(() {});
        }
      });

      // Fetch and draw the polyline initially
      updatePolyline();
    } catch (e) {
  print('Error fetching location: $e');
  }
}

  void calculateRemainingTime() async {
    if (currentLocation != null) {
      // Calculate the distance between current location and destination in meters
      double distanceInMeters = Geolocator.distanceBetween(
        currentLocation!.latitude!,
        currentLocation!.longitude!,
        destination.latitude,
        destination.longitude,
      );

      // Assume an average speed of 50 km/h (approximately 13.89 meters/second)
      double averageSpeed = 13.89; // in meters per second

      // Calculate the remaining time in seconds
      double remainingSeconds = distanceInMeters / averageSpeed;

      // Convert seconds to minutes and hours
      Duration remainingDuration = Duration(seconds: remainingSeconds.round());

      setState(() {
        // Format the time to a readable format (HH:MM:SS)
        remainingTime = '${remainingDuration.inHours}h ${remainingDuration.inMinutes % 60}m';
      });
    }
  }


void updatePolyline() async {
  if (currentLocation != null) {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyDaO-jjmk06YaFSmT3d2YvvxD_fQYIfv3w", // Replace with your actual Google Maps API Key
      PointLatLng(currentLocation!.latitude!, currentLocation!.longitude!),
      PointLatLng(destination.latitude, destination.longitude),
    );

    polylineCoordinates.clear(); // Clear previous coordinates

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        );
      });
    }

    setState(() {}); // Rebuild UI to draw the updated polyline
  }
}

@override
void initState() {
  super.initState();
  getCurrentLocation(); // Fetch the current location
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            if (remainingTime.isNotEmpty)
              Container(
                height: 90,
                width: double.infinity,
                color: Colors.grey,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Text(
                      'Remaining time to destination: $remainingTime',
                      style: const TextStyle(fontSize: 16,  color: Colors.black),
                    ),
                  ),
                ),
              ),

            Expanded(
              child: currentLocation == null
                  ? const Center(child: CircularProgressIndicator()) // Show loading indicator
                  : GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    currentLocation!.latitude!,
                    currentLocation!.longitude!,
                  ),
                  zoom: 13.5,
                ),
                markers: {
                  // Marker for the current location
                  Marker(
                    markerId: const MarkerId("currentLocation"),
                    position: LatLng(
                      currentLocation!.latitude!,
                      currentLocation!.longitude!,
                    ),
                  ),
                  // Marker for the destination
                  const Marker(
                    markerId: MarkerId("destination"),
                    position: destination,
                  ),
                },
                onMapCreated: (mapController) {
                  _controller.complete(mapController); // Complete the map controller
                },
                polylines: {
                  Polyline(
                    polylineId: const PolylineId("route"),
                    points: polylineCoordinates,
                    color: Colors.black,
                    width: 6,
                  ),
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 70, right: 70, top: 15, bottom: 15),
                    child: Text("Back", style: TextStyle(color: Colors.white),),
                  ),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }

}
