import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

const kGoogleApiKey = "AIzaSyDaO-jjmk06YaFSmT3d2YvvxD_fQYIfv3w"; // Add your Google API key

class SearchLocationScreen extends StatefulWidget {
  double lat;
  double long;
  SearchLocationScreen(this.lat, this.long);
  @override
  _SearchLocationScreenState createState() => _SearchLocationScreenState();
}

class _SearchLocationScreenState extends State<SearchLocationScreen> {
  GoogleMapController? mapController;
  LatLng? searchedLocation;

  // Google Places API instance
  final GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _searchPlace() async {
    // Open the search screen provided by the Google Places API, without country restriction
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      mode: Mode.overlay,
      language: "en", // Search in English (optional)
    );

    if (p != null) {
      // Get place details
      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId!);
      final lat = detail.result.geometry!.location.lat;
      final lng = detail.result.geometry!.location.lng;

      setState(() {
        searchedLocation = LatLng(lat, lng);
        mapController?.animateCamera(CameraUpdate.newLatLng(searchedLocation!));
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchedLocation = LatLng(widget.lat, widget.long);
    mapController?.animateCamera(CameraUpdate.newLatLng(searchedLocation!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black
        ,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text('Search Location', style: GoogleFonts.sourceSans3(
          fontWeight: FontWeight.w500,
          color: Colors.white,
          letterSpacing: 1,
          fontSize: 20,
          //fontWeight: FontWeight.bold,
        ),),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _searchPlace, // Trigger the global search
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: searchedLocation ?? LatLng(widget.lat, widget.long),
                zoom: 14.0,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: searchedLocation != null
                  ? {
                Marker(
                  markerId: MarkerId("searchedLocation"),
                  position: searchedLocation!,
                ),
              }
                  : Set(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black
              ),
              onPressed: () {
                if (searchedLocation != null) {
                  Navigator.pop(context, searchedLocation); // Return the selected location
                }
                else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please select a location")));
                }
              },
              child: Text("Confirm Location", style: GoogleFonts.sourceSans3(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                letterSpacing: 1,
                fontSize: 15,
                //fontWeight: FontWeight.bold,
              ),),
            ),
          ),
        ],
      ),
    );
  }
}
