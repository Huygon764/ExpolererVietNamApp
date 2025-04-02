import 'package:app_tourist_destination/widgets/ImageWidget.dart';
import 'package:flutter/material.dart';

class GalleryView extends StatefulWidget {
  final List<String> imageNames;
  final int initialIndex;
  final String? folder;

  GalleryView({required this.imageNames, this.initialIndex = 0, this.folder});

  @override
  _GalleryViewState createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {
  late PageController _pageController;
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          '${currentIndex + 1}/${widget.imageNames.length}',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.imageNames.length,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return Center(
            child: InteractiveViewer(
              panEnabled: true,
              boundaryMargin: EdgeInsets.all(20),
              minScale: 0.5,
              maxScale: 4,
              child: StorageImage(
                imageName: widget.imageNames[index],
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.contain,
                borderRadius: 0,
                folder: widget.folder,
              ),
            ),
          );
        },
      ),
    );
  }
}
