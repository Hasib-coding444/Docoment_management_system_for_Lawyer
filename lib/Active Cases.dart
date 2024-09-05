import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ActiveCase extends StatelessWidget {
  const ActiveCase({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final todayFormatted = DateFormat('yyyy-MM-dd').format(today);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Active Cases", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('cases').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong!'));
          }

          final casesData = snapshot.data!.docs.where((caseDoc) {
            var caseData = caseDoc.data() as Map<String, dynamic>;
            var nextDate = caseData['nextDate'] as String;
            return nextDate == todayFormatted;
          }).toList();

          if (casesData.isEmpty) {
            return const Center(child: Text('No active cases for today'));
          }

          return ListView.builder(
            itemCount: casesData.length,
            itemBuilder: (context, index) {
              var caseData = casesData[index].data() as Map<String, dynamic>;

              return Card(
                child: ListTile(
                  title: Text('Case No: ${caseData['caseNo']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Court Name: ${caseData['courtName']}'),
                      Text('Name of Party: ${caseData['partyName']}'),
                      Text('Next Date: ${caseData['nextDate']}'),
                    ],
                  ),
                  onTap: () {
                    // Navigate to the CaseDetailsPage
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => CaseDetailsPage(caseData: caseData),
                    //   ),
                    // );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
