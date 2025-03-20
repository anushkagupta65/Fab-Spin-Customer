import 'dart:async';
import 'dart:convert';
import 'package:fabspin/Screens/add_address.dart';
import 'package:fabspin/Screens/search_maps.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Urls/urls.dart';

class MapScreen extends StatefulWidget {
  final Function(String) onAddressSelected;

  MapScreen({required this.onAddressSelected});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;
  LatLng _currentPosition = LatLng(28.614620, 77.033173);
  bool _loading = true;
  String? _currentAddress;
  int? userId;
  String zipCode = '';

  TextEditingController house = TextEditingController();
  TextEditingController street = TextEditingController();

  Future<void> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('user_id');
    });
  }

  Future<void> _updateAddress() async {
    final url = Uri.parse(Urls.updateAddress);
    final response = await http.post(
      url,
      body: json.encode({
        'customer_id': userId,
        'address': _currentAddress,
        'landmark': street.text,
        'house': house.text,
        'zip': zipCode,
        'lat': _currentPosition.latitude.toString(),
        'long': _currentPosition.longitude.toString(),
      }),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.isRedirect) {
      print('Redirected to: ${response.headers['location']}');
    }

    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
    print('Redirected to: ${response.headers['location']}');

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      if (responseData['Status'] == 'Success') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddAddress()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Address Updated.')),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _getUserId();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _loading = false;
      _moveToCurrentLocation();
    });

    await _getAddressFromLatLng(
        _currentPosition.latitude, _currentPosition.longitude);
  }

  Future<void> _getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address =
            "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";

        zipCode = place.postalCode ?? "No Zip Code";
        print("Full Address: $address");
        print("Zip Code: $zipCode");
        setState(() {
          _currentAddress = address;
        });

        //await _saveAddressToPreferences(address);

        // Pass address back to the previous screen
        widget.onAddressSelected(address);
      }
    } catch (e) {
      print(e);
    }
  }

  void _moveToCurrentLocation() {
    _controller?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _currentPosition,
          zoom: 14.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            'Location',
            style: GoogleFonts.sourceSans3(
              fontWeight: FontWeight.w500,
              color: Colors.white,
              letterSpacing: 1,
              fontSize: 20,
            ),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
        ),
        body: Column(
          children: [
            _loading
                ? Center(child: CircularProgressIndicator())
                : Expanded(
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: _currentPosition,
                        zoom: 14.0,
                      ),
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      onMapCreated: (GoogleMapController controller) {
                        _controller = controller;
                      },
                    ),
                  ),
            Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _currentAddress ?? 'No address available',
                          style: GoogleFonts.sourceSans3(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            letterSpacing: 1,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final selectedLocation = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SearchLocationScreen(
                                      _currentPosition.latitude,
                                      _currentPosition.longitude),
                                ));

                            if (selectedLocation != null) {
                              setState(() {
                                _currentPosition = selectedLocation;
                                _moveToCurrentLocation();
                                _getAddressFromLatLng(_currentPosition.latitude,
                                    _currentPosition.longitude);
                              });
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(5)),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Center(
                                  child: Text(
                                'Change',
                                style: GoogleFonts.sourceSans3(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  letterSpacing: 1,
                                  fontSize: 12,
                                ),
                              )),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: TextField(
                            controller: house,
                            decoration: InputDecoration(
                              hintText: "House / Flat / Block / Building",
                              border: InputBorder.none,
                              hintStyle: GoogleFonts.sourceSans3(
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                letterSpacing: 1,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: TextField(
                          controller: street,
                          decoration: InputDecoration(
                            hintText: "Street, Society or Landmark",
                            border: InputBorder.none,
                            hintStyle: GoogleFonts.sourceSans3(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              letterSpacing: 1,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      onTap: () {
                        _updateAddress();
                      },
                      child: Container(
                        child: Center(
                          child: Text(
                            'Add Address',
                            style: GoogleFonts.sourceSans3(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              letterSpacing: 1,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        height: 60,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
