import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';

class LokasiWidget extends StatefulWidget {
  const LokasiWidget({super.key});

  @override
  State<LokasiWidget> createState() => _LokasiWidgetState();
}

class _LokasiWidgetState extends State<LokasiWidget> {
  bool isLoading = false;
  loc.LocationData? locationData;
  List<Placemark>? placemark;

  void getPermission() async {
    if (await Permission.location.isGranted) {
      // Location
      getLocation();
    } else {
      Permission.location.request();
    }
  }

  void getLocation() async {
    setState(() {
      isLoading = true;
    });
    locationData = await loc.Location.instance.getLocation();

    setState(() {
      isLoading = false;
    });
  }

  void getAddress() async {
    if (locationData != null) {
      setState(() {
        isLoading = true;
      });

      placemark = await placemarkFromCoordinates(
          locationData!.latitude!, locationData!.longitude!);

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Text(
                    locationData != null
                        ? "Latitude : ${locationData!.latitude}"
                        : 'Latitude : Not Available',
                  ),
                  Text(
                    locationData != null
                        ? "Longtitude : ${locationData!.longitude}"
                        : 'Longtitude : Not Available',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: getPermission,
                    child: Text('Get Location'),
                  ),
                  SizedBox(
                    height: 80,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      placemark != null? "Address : ${placemark![0].street}" : 'Address : Not Available',
                      textAlign: TextAlign.center,
                      
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: getAddress,
                    child: Text('Get Address'),
                  ),
                ],
              ),
            ),
    );
  }
}
