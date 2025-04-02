import 'package:app_tourist_destination/services/storage.service.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class StorageImage extends StatefulWidget {
  final String imageName;
  final double? width;
  final double? height;
  final double? borderRadius;
  final BoxFit fit;
  final String? folder;

  const StorageImage({
    Key? key,
    required this.imageName,
    this.width,
    this.height,
    this.borderRadius,
    this.fit = BoxFit.cover,
    this.folder = null,
  }) : super(key: key);

  @override
  _StorageImageState createState() => _StorageImageState();
}

class _StorageImageState extends State<StorageImage> {
  final StorageService _storageService = StorageService();
  late Future<String> _imageUrlFuture;

  @override
  void initState() {
    super.initState();
    _imageUrlFuture = _storageService.getImageUrl(
      widget.imageName,
      widget.folder,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _imageUrlFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: widget.width,
            height: widget.height,
            color: Colors.grey[300],
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return Container(
            width: widget.width,
            height: widget.height,
            color: Colors.grey[300],
            child: Icon(Icons.image_not_supported, color: Colors.grey[600]),
          );
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 10),
          child: CachedNetworkImage(
            imageUrl: snapshot.data!,
            width: widget.width,
            height: widget.height,
            fit: widget.fit,
            placeholder:
                (context, url) => Container(
                  color: Colors.grey[300],
                  child: Center(child: CircularProgressIndicator()),
                ),
            errorWidget:
                (context, url, error) => Container(
                  color: Colors.grey[300],
                  child: Icon(Icons.error, color: Colors.red),
                ),
          ),
        );
      },
    );
  }
}
