import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: screenHeight,
        width: screenWidth,
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(right: 270),
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    
                  },
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(right: 28),
                child: Text(
                  'Take a photo of document',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Text('Please ensure photos are clear and visible'),
              ),
              SizedBox(height: 150),
              FloatingActionButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return SizedBox(
                        height: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                _requestCameraPermission();
                              },
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20, top: 20),
                                    child: Icon(Icons.camera_alt, size: 25),
                                  ),
                                  SizedBox(width: 25),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: Text(
                                      'Camera',
                                      style: TextStyle(fontSize: 15, color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 40),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                _requestGalleryPermission();
                              },
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Icon(Icons.photo, size: 25),
                                  ),
                                  SizedBox(width: 25),
                                  Text(
                                    'Gallery',
                                    style: TextStyle(fontSize: 15, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                backgroundColor: Colors.black,
                child: Icon(Icons.add, color: Colors.white),
              ),
              SizedBox(height: 20),
              if (_selectedImage != null) Image.file(_selectedImage!),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isGranted) {
      print(status);
      _pickImageFromCamera();
    } else {
      if (await Permission.camera.request().isGranted) {
        _pickImageFromCamera();
      } else {
        _showPermissionDeniedDialog();
      }
    }
  }

  Future<void> _requestGalleryPermission() async {
    var status = await Permission.storage.status; 
    if (status.isGranted) {
      _pickImageFromGallery();
    } else {
      if (await Permission.storage.request().isGranted) {
        _pickImageFromGallery();
      } else {
        _showPermissionDeniedDialog();
      }
    }
  }

  Future<void> _pickImageFromCamera() async {
    final returnedImage = await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnedImage == null) return; 
    setState(() {
      _selectedImage = File(returnedImage.path);
    });
  }

  Future<void> _pickImageFromGallery() async {
    final returnedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return; 
    setState(() {
      _selectedImage = File(returnedImage.path);
    });
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Allow Imagepicker to take picture and record video'),
          content: Text('Allow camera and gallery to access while running',style: TextStyle(color: Color.fromARGB(255, 23, 92, 25)),),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
