import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LegalHelp extends StatelessWidget {
  const LegalHelp({super.key});

  // URL of the Bangladesh High Court website
  final String _highCourtUrl = 'https://www.highcourt.gov.bd';

  // Function to launch the URL
  Future<void> _launchURL() async {
    if (await canLaunch(_highCourtUrl)) {
      await launch(_highCourtUrl);
    } else {
      throw 'Could not launch $_highCourtUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Legal Help", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'For detailed information on legal matters, visit the Bangladesh High Court website:https://www.supremecourt.gov.bd/web/indexn.php?page=officers_main.php&menu=11&div_id=2&lang=',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _launchURL,
                style: TextButton.styleFrom(
                  // Text color
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                child: const Text('Go to Bangladesh High Court'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
