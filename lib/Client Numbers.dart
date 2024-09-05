import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class ClientNumbers extends StatefulWidget {
  const ClientNumbers({super.key});

  @override
  _ClientNumbersState createState() => _ClientNumbersState();
}

class _ClientNumbersState extends State<ClientNumbers> {
  final TextEditingController _clientNameController = TextEditingController();
  final TextEditingController _clientNumberController = TextEditingController();
  User? _user;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Client Numbers", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildClientNameField(),
            SizedBox(height: 10),
            _buildClientNumberField(),
            SizedBox(height: 20),
            _buildSaveButton(),
            SizedBox(height: 20),
            // Wrap StreamBuilder inside Expanded widget
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('clients')
                    .where('userId', isEqualTo: _user?.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Something went wrong!'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No clients found.'));
                  }

                  final clientsData = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: clientsData.length,
                    itemBuilder: (context, index) {
                      var clientData = clientsData[index].data() as Map<String, dynamic>;
                      String docId = clientsData[index].id;

                      return ListTile(
                        title: Text(clientData['name']),
                        subtitle: GestureDetector(
                          onTap: () => _launchCaller(clientData['number']),
                          child: Text(
                            clientData['number'],
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            // Handle client deletion
                            await FirebaseFirestore.instance
                                .collection('clients')
                                .doc(docId)
                                .delete();
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClientNameField() {
    return TextField(
      controller: _clientNameController,
      decoration: InputDecoration(
        labelText: 'Client Name',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildClientNumberField() {
    return TextField(
      controller: _clientNumberController,
      decoration: InputDecoration(
        labelText: 'Client Number',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _saveClient,
      child: Text('Save'),
    );
  }

  Future<void> _saveClient() async {
    final String name = _clientNameController.text.trim();
    final String number = _clientNumberController.text.trim();

    if (name.isNotEmpty && number.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('clients').add({
          'name': name,
          'number': number,
          'userId': _user?.uid, // Associate data with the current user
        });

        _showSnackBar('Client saved successfully!');
        _clearTextFields();
      } catch (e) {
        _showSnackBar('Error saving client: $e');
      }
    } else {
      _showSnackBar('Please fill out all fields.');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _clearTextFields() {
    _clientNameController.clear();
    _clientNumberController.clear();
  }

  void _launchCaller(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $launchUri';
    }
  }
}
