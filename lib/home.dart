import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _lat = -6.875109;
  double _lng = 109.664639;
  Position _currentPosition;
  GoogleMapController mapController;

  @override
  initState() {
    super.initState();
  }

  _getCurrentLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
        print('CURRENT POS: $_currentPosition');
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 17.0,
            ),
          ),
        );
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Google Maps"),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: GoogleMap(
          zoomControlsEnabled: true,
          myLocationButtonEnabled: false,
          myLocationEnabled: true,
          initialCameraPosition: CameraPosition(
            target: LatLng(_lat, _lng),
            zoom: 17,
          ),
          markers: {
            Marker(
              markerId: MarkerId('current'),
              position: LatLng(_lat, _lng),
            )
          },
          onMapCreated: (GoogleMapController controller) {
            mapController = controller;
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.location_searching),
        onPressed: () {
          _getCurrentLocation();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
