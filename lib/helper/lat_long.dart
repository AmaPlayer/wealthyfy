

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wealthyfy/controller/button_controller/custombuttom.dart';
import 'package:wealthyfy/helper/textview.dart';

class LatLong extends StatefulWidget {
  const LatLong({super.key});

  @override
  State<LatLong> createState() => _LatLongState();
}

class _LatLongState extends State<LatLong> {

  double? latitude;
  double? longitude;
  String address = '';


  Future<Position> _determinePosition() async {
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
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }


  Future<void> getLatLong() async {
    try {
      Position position = await _determinePosition();
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });
      await getAddress(latitude!, longitude!);
    } catch (error) {
      print("Error: $error");

    }
  }


  Future<void> getAddress(double lat, double long) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
      setState(() {
        address = '${placemarks[0].subLocality}, ${placemarks[0].thoroughfare}';
      });
    } catch (error) {
      print("Error getting address: $error");
      setState(() {
        address = "Unable to retrieve address";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: headingText(title: 'LatLong'),
      ),
      body: Column(
        children: [
          headingText(title: 'Lat: ${latitude ?? 'N/A'}'),
          headingText(title: 'Long: ${longitude ?? 'N/A'}'),
          headingText(title: 'Address: $address'),
          CustomButton(
              text: 'Get Current Location',
              onPressed: getLatLong
          ),
        ],
      ),
    );
  }
}

