import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:locasi_app/current_location_screen.dart';
import 'package:locasi_app/item_list.dart';
import 'package:locasi_app/lokasi.dart';
import 'package:locasi_app/theme.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';

class AddItem extends StatefulWidget {
  const AddItem({Key? key}) : super(key: key);

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerAddres = TextEditingController();
  TextEditingController _controllerNohp = TextEditingController();
  TextEditingController _controllerJenisKelamin = TextEditingController();

  GlobalKey<FormState> key = GlobalKey();

  CollectionReference _reference =
      FirebaseFirestore.instance.collection('users');

  String imageUrl = '';
  int? _value = 1;

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
        backgroundColor: const Color(0xff141B62),
        title: Text('Add Employee Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: key,
          child: ListView(
            children: [
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _controllerName,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: primaryColor),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  labelText: 'Name',
                  hintText: 'Enter Your Name',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return ('Please enter your name');
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 12,
              ),
              TextFormField(
                controller: _controllerAddres,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: primaryColor),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  labelText: 'Alamat',
                  hintText: 'Enter Your Alamat',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return ('Please enter your age');
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 12,
              ),
              TextFormField(
                controller: _controllerNohp,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: primaryColor),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  labelText: 'No Hp',
                  hintText: 'Enter Your No Hp',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return ('Please enter your age');
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 12,
              ),
              TextFormField(
                controller: _controllerJenisKelamin,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: primaryColor),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  labelText: 'Jenis Kelamin',
                  hintText: 'Enter Your Jenis Kelamin',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return ('Please enter your age');
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              // const SizedBox(
              //   height: 12,
              // ),
              // AddPhoto(),
              // Container(
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(100),
              //   ),
              //   child: (imageUrl != null)
              //       ? Container(
              //           width: 100,
              //           height: 100,
              //           decoration: BoxDecoration(
              //             shape: BoxShape.circle,
              //             border: Border.all(color: Colors.black),
              //             image: DecorationImage(
              //                 image: NetworkImage(imageUrl), fit: BoxFit.cover),
              //           ),
              //         )
              //       : Container(
              //           width: 100,
              //           height: 100,
              //           decoration: BoxDecoration(
              //             shape: BoxShape.circle,
              //             border: Border.all(color: Colors.black),
              //           ),
              //         ),
              // ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                child: Text(
                  'Add Foto',
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xff6C63FF),
                  textStyle: textButtonStyle,
                ),
                onPressed: () async {
                  ImagePicker imagePicker = ImagePicker();
                  XFile? imagePath =
                      await imagePicker.pickImage(source: ImageSource.camera);
                  print('${imagePath?.path}');

                  // upload to firebase

                  if (imagePath == null) return;

                  String uniqFileName = DateTime.now().weekday.toString();

                  // Get a reference
                  Reference referenceRoot = FirebaseStorage.instance.ref();
                  Reference referenceDirImages = referenceRoot.child('images');

                  // create reference image to be storage
                  Reference referenceImageToUpload =
                      referenceDirImages.child('${imagePath.path}');
                  // Handle error/succes
                  try {
                    // store file to firebase
                    await referenceImageToUpload.putFile(File(imagePath.path));

                    // Succes get download file
                    imageUrl = await referenceImageToUpload.getDownloadURL();
                  } catch (error) {
                    // some error
                  }
                },
              ),
              SizedBox(
                height: 24,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff6C63FF),
                    textStyle: textButtonStyle,
                  ),
                  onPressed: () async {
                    if (imageUrl.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please Upload Image'),
                        ),
                      );
                    }

                    if (key.currentState!.validate()) {
                      String itemName = _controllerName.text;
                      String itemAddres = _controllerAddres.text;
                      String itemNohp = _controllerNohp.text;
                      String itemJenisKelamin = _controllerJenisKelamin.text;

                      //Create a Map of data
                      Map<String, String> dataToSend = {
                        'name': itemName,
                        'alamat': itemAddres,
                        'hp': itemNohp,
                        'jk': itemJenisKelamin,
                        'image': imageUrl
                      };

                      //Add a new item
                      _reference.add(dataToSend);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ItemList(),
                        ),
                      );
                    }
                  },
                  child: Text('Submit'))
            ],
          ),
        ),
      ),
    );
  }
}
