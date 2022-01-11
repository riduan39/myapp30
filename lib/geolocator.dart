import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  Position? position;
  String address = "My Address";

  get import => null;
  fatecposition() async {
    bool servicEnable;
    LocationPermission permission;
    servicEnable = await Geolocator.isLocationServiceEnabled();
    if (!servicEnable) {
      Fluttertoast.showToast(msg: "Disable");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: "Location permission are demied");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(msg: "Location permission are denied Forever");
    }
    Position currentposition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          currentposition.latitude, currentposition.longitude);
      Placemark place = placemarks[0];

      setState(() {
        position = currentposition;
        address = "${place.locality},${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Location App"),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            children: [
              Text(address),
              Text(position == null ? 'Location' : position.toString()),
              ElevatedButton(
                onPressed: fatecposition,
                child: Text("Fine Location"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
