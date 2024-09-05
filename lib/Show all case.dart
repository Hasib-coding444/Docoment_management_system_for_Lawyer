import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class CaseDetailsPage extends StatefulWidget {
  final DocumentSnapshot caseData;

  const CaseDetailsPage({super.key, required this.caseData});

  @override
  State<CaseDetailsPage> createState() => _CaseDetailsPageState();
}

class _CaseDetailsPageState extends State<CaseDetailsPage> {
  @override
  Widget build(BuildContext context) {
    List<String> imageUrls = List<String>.from(widget.caseData['imageUrls'] ?? []);

    return Scaffold(
      appBar: AppBar(
        title: Text('Case Details'),backgroundColor: Colors.blue,
      ),
      body: Padding(padding: EdgeInsets.all(30),
        child: ListView(
          children: [
            ListTile(
              title: Text('Case No: ${widget.caseData['caseNo'] ?? 'No Case Number'}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Court: ${widget.caseData['courtName'] ?? 'No Court Name'}'),
                  Text('Date: ${widget.caseData['regDate'] ?? 'No Registration Date'}'),
                  Text('Next Date: ${widget.caseData['nextDate'] ?? 'No Next Date'}'),
                  Text('Party: ${widget.caseData['partyName'] ?? 'No Party Name'}'),
                  Text('Year: ${widget.caseData['year'] ?? 'No Year'}'),
                ],
              ),
            ),
            SizedBox(height: 10),
            imageUrls.isNotEmpty
                ? GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
                itemCount: imageUrls.length,
                itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageGalleryPage(
                          imageUrls: imageUrls,
                          initialIndex: index,
                        ),
                      ),
                    );
                  },
                  child: Image.network(imageUrls[index], fit: BoxFit.cover),
                );
              },
            )
                : const Center(child: Text('No images available')),
          ],
        ),
      ),
    );
  }
}

class ImageGalleryPage extends StatelessWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const ImageGalleryPage({required this.imageUrls, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PhotoViewGallery.builder(
        scrollPhysics: BouncingScrollPhysics(),
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(imageUrls[index]),
            initialScale: PhotoViewComputedScale.contained,
            minScale: PhotoViewComputedScale.contained * 0.8,
            maxScale: PhotoViewComputedScale.covered * 2,
          );
        },
        itemCount: imageUrls.length,
        pageController: PageController(initialPage: initialIndex),
        onPageChanged: (index) {},
      ),
    );
  }
}