import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/DateTimeForm.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:typed_data';
import 'dart:io' as io;

import 'All Cases.dart';

class AppellCaseForm extends StatefulWidget {
  @override
  _AppelCaseFormState createState() => _AppelCaseFormState();
}

class _AppelCaseFormState extends State<AppellCaseForm> {
  final _caseNoController = TextEditingController();
  final _regDateController = TextEditingController();
  final _courtNameController = TextEditingController();
  final _partyNameController = TextEditingController();
  final _yearController = TextEditingController();
  final _nextDateController = TextEditingController();
  List<Uint8List> _imageBytes = [];
  List<XFile> _imageFiles = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      final imageBytes = await image.readAsBytes();
      setState(() {
        _imageBytes.add(imageBytes);
        _imageFiles.add(image);
      });
    }
  }

  Future<void> _saveData() async {
    List<String> imageUrls = [];
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User not logged in')));
      return;
    }
    String uid = user.uid;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Saving document...'),
        duration: Duration(seconds: 1),
      ),
    );

    try {
      for (var imageFile in _imageFiles) {
        String imagePath = 'cases/${DateTime.now().millisecondsSinceEpoch}.png';
        Uint8List imageData = await imageFile.readAsBytes();

        if (kIsWeb) {
          await FirebaseStorage.instance.ref(imagePath).putData(imageData);
        } else {
          await FirebaseStorage.instance.ref(imagePath).putFile(io.File(imageFile.path));
        }

        String imageUrl = await FirebaseStorage.instance.ref(imagePath).getDownloadURL();
        imageUrls.add(imageUrl);
      }

      await FirebaseFirestore.instance.collection('users').doc(uid).collection('cases').add({
        'caseNo': _caseNoController.text,
        'regDate': _regDateController.text,
        'courtName': _courtNameController.text,
        'partyName': _partyNameController.text,
        'year': _yearController.text,
        'nextDate': _nextDateController.text,
        'imageUrls': imageUrls,
      });

      await Future.delayed(Duration(seconds: 1));

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AllCasesPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Case'),backgroundColor: Colors.blue,),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            TextField(
              controller: _caseNoController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Case No'),
            ),
            SizedBox(height: 10,),
            DateTimeFormField(
              controller: _regDateController,
              label: 'Registration Date',
            ),
            SizedBox(height: 10,),
            TextField(
              controller: _courtNameController,
              decoration: InputDecoration(labelText: 'Court Name'),
            ),
            SizedBox(height: 10,),
            TextField(
              controller: _partyNameController,
              decoration: InputDecoration(labelText: 'Name of Party'),
            ),
            SizedBox(height: 10,),
            TextField(
              controller: _yearController,
              decoration: InputDecoration(labelText: 'Year'),
            ),
            SizedBox(height: 10,),
            DateTimeFormField(
              controller: _nextDateController,
              label: 'Next Date',
            ),
            SizedBox(height: 25),
            IconButton(
              icon: Icon(Icons.camera_alt),
              onPressed: _pickImage,
            ),
            SizedBox(height: 20),
            _imageBytes.isEmpty
                ? Text('No pictures added')
                : Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                ),
                itemCount: _imageBytes.length,
                itemBuilder: (context, index) {
                  return Image.memory(
                    _imageBytes[index],
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: _saveData,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
