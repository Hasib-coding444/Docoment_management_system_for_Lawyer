import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Note extends StatefulWidget {
  const Note({super.key});

  @override
  _NoteState createState() => _NoteState();
}

class _NoteState extends State<Note> {
  final TextEditingController _noteController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _noteContent = '';

  @override
  void initState() {
    super.initState();
    _fetchNote();
  }

  Future<void> _fetchNote() async {
    // Fetch the note from Firestore
    DocumentSnapshot snapshot = await _firestore.collection('notes').doc('noteDoc').get();
    if (snapshot.exists) {
      setState(() {
        _noteContent = snapshot['content'] ?? '';
        _noteController.text = _noteContent;
      });
    }
  }

  Future<void> _saveNote() async {
    // Save the note to Firestore
    await _firestore.collection('notes').doc('noteDoc').set({
      'content': _noteController.text,
    });

    // Update the state
    setState(() {
      _noteContent = _noteController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Note", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: _noteController,
                maxLines: null, // Allows unlimited lines
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Write your note here...',
                ),
                onChanged: (value) {
                  setState(() {
                    _noteContent = value;
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveNote,
              child: Text('Save Note'),
            ),
          ],
        ),
      ),
    );
  }
}
