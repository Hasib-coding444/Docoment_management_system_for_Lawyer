import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/Homepage.dart';
import 'Show all case.dart';

class AllCasesPage extends StatefulWidget {
  const AllCasesPage({super.key});

  @override
  State<AllCasesPage> createState() => _AllCasesPageState();
}

class _AllCasesPageState extends State<AllCasesPage> {
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> selectedCases = [];
  bool isSelectionMode = false;

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text('User not logged in'),
        ),
      );
    }

    String uid = user.uid;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText:
                'Search by Case No, Court Name, Party Name, Year, Month...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white54),
            icon: Icon(Icons.search, color: Colors.white),
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: (value) {
            setState(() {
              searchQuery = value.toLowerCase();
            });
          },
        ),
        actions: [
          if (!isSelectionMode)
            IconButton(
              icon: const Icon(Icons.select_all),
              onPressed: () {
                setState(() {
                  isSelectionMode = true;
                });
              },
            ),
          if (isSelectionMode)
            IconButton(
              icon: const Icon(Icons.cancel),
              onPressed: () {
                setState(() {
                  isSelectionMode = false;
                  selectedCases.clear();
                });
              },
            ),
        ],
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('cases')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No cases found'));
          }

          var filteredCases = snapshot.data!.docs.where((caseDoc) {
            var caseData = caseDoc.data() as Map<String, dynamic>;
            var caseNo = caseData['caseNo']?.toLowerCase() ?? '';
            var courtName = caseData['courtName']?.toLowerCase() ?? '';
            var partyName = caseData['partyName']?.toLowerCase() ?? '';
            var year = caseData['year']?.toLowerCase() ?? '';
            var month = (DateTime.tryParse(caseData['regDate'] ?? '')
                    ?.month
                    .toString()
                    .padLeft(2, '0') ??
                '');

            return caseNo.contains(searchQuery) ||
                courtName.contains(searchQuery) ||
                partyName.contains(searchQuery) ||
                year.contains(searchQuery) ||
                month.contains(searchQuery);
          }).toList();

          return ListView.builder(
            itemCount: filteredCases.length,
            itemBuilder: (context, index) {
              var caseData = filteredCases[index];
              bool isSelected = selectedCases.contains(caseData);

              return ListTile(
                leading: caseData['imageUrls'].isNotEmpty
                    ? Image.network(caseData['imageUrls'][0],
                        width: 50, height: 50)
                    : const Icon(Icons.image_not_supported),
                title: Text(caseData['caseNo'] ?? 'No Case Number'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Court: ${caseData['courtName'] ?? 'No Court Name'}'),
                    Text(
                        'Date: ${caseData['regDate'] ?? 'No Registration Date'}'),
                    Text(
                        'Next Date: ${caseData['nextDate'] ?? 'No Next Date'}'),
                    Text('Party: ${caseData['partyName'] ?? 'No Party Name'}'),
                    Text('Year: ${caseData['year'] ?? 'No Year'}'),
                  ],
                ),
                trailing: isSelectionMode
                    ? Checkbox(
                        value: isSelected,
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              selectedCases.add(caseData);
                            } else {
                              selectedCases.remove(caseData);
                            }
                          });
                        },
                      )
                    : null,
                onTap: () {
                  if (isSelectionMode) {
                    setState(() {
                      if (isSelected) {
                        selectedCases.remove(caseData);
                      } else {
                        selectedCases.add(caseData);
                      }
                    });
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CaseDetailsPage(caseData: caseData),
                      ),
                    );
                  }
                },
                onLongPress: () {
                  if (!isSelectionMode) {
                    setState(() {
                      isSelectionMode = true;
                      selectedCases.add(caseData);
                    });
                  }
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const homepage(), // Replace with your home page widget
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: selectedCases.isEmpty
                  ? null
                  : () async {
                      // Delete selected cases
                      for (var caseDoc in selectedCases) {
                        await caseDoc.reference.delete();
                      }
                      setState(() {
                        selectedCases.clear();
                        isSelectionMode = false;
                      });
                    },
            ),
          ],
        ),
      ),
    );
  }
}
