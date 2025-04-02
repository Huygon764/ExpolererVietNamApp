import 'package:app_tourist_destination/models/destination.model.dart';
import 'package:app_tourist_destination/pages/Dialog/LoginDialog.dart';
import 'package:app_tourist_destination/providers/WishlistProvider.dart';
import 'package:app_tourist_destination/widgets/AddReviewWidget.dart';
import 'package:app_tourist_destination/widgets/GalleryWidget.dart';
import 'package:app_tourist_destination/widgets/ImageWidget.dart';
import 'package:app_tourist_destination/widgets/ReviewListWidget.dart';
import 'package:app_tourist_destination/services/auth.service.dart';
import 'package:app_tourist_destination/services/destination.service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlaceDetailScreen extends StatefulWidget {
  final String id;
  const PlaceDetailScreen({super.key, required this.id});

  @override
  State<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
  late Future<DestinationModel> _destination;
  DestinationService _destinationService = DestinationService();
  AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _destination = _destinationService.getDestination(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return DetailScreen();
  }

  FutureBuilder<DestinationModel> DetailScreen() {
    return FutureBuilder<DestinationModel>(
      future: _destination,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: Colors.grey[300],
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Container(
            color: Colors.grey[300],
            child: Icon(Icons.image_not_supported, color: Colors.grey[600]),
          );
        }

        final destination = snapshot.data!;
        return Consumer<WishlistProvider>(
          builder: (context, wishlistProvider, child) {
            final isInWishlist = wishlistProvider.isInWishlist(destination.id);
            return Scaffold(
              body: Column(
                children: [
                  Stack(
                    children: [
                      StorageImage(
                        imageName: destination.image,
                        height: MediaQuery.of(context).size.height * 0.35,
                        width: double.infinity,
                        borderRadius: 0,
                      ),

                      // Back button
                      Positioned(
                        top: 40,
                        left: 20,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          width: 40,
                          height: 40,
                          child: IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.black),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ),

                      // Favorite button
                      Positioned(
                        top: 40,
                        right: 20,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          width: 40,
                          height: 40,
                          child: IconButton(
                            icon: Icon(
                              isInWishlist
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isInWishlist ? Colors.red : Colors.grey,
                            ),
                            onPressed: () {
                              final user = _authService.currentUser;
                              if (user == null) {
                                showLoginDialog(context);
                                return;
                              }
                              wishlistProvider.toggleWishlist(
                                destination.id,
                                user,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Content section
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                destination.name,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 10),

                          // Location
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.blue,
                                size: 18,
                              ),
                              SizedBox(width: 5),
                              Text(
                                destination.location,
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 15),

                          // Description
                          Text(
                            destination.description + '...',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              height: 1.5,
                            ),
                          ),

                          SizedBox(height: 20),

                          // Preview section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Xem trước',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 18,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    destination.rating.toStringAsFixed(2),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          SizedBox(height: 15),

                          // Preview images
                          Container(
                            height:
                                100, // Set an appropriate height for your list
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  destination
                                      .previewImages
                                      .length, // Set the number of items you want to show
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    // Mở gallery với ảnh được chọn
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => GalleryView(
                                              imageNames:
                                                  destination.previewImages,
                                              initialIndex: index,
                                              folder:
                                                  destination.image.split(
                                                    '.',
                                                  )[0],
                                            ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width *
                                        0.25, // Fixed width for each item
                                    margin: EdgeInsets.only(right: 12),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: StorageImage(
                                        imageName:
                                            destination.previewImages[index],
                                        fit: BoxFit.cover,
                                        height: 100,
                                        width:
                                            MediaQuery.of(context).size.width *
                                            0.25,
                                        borderRadius: 10,
                                        folder: destination.image.split('.')[0],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          SizedBox(height: 16),

                          // Thêm form đánh giá
                          AddReviewSection(destinationId: destination.id),

                          // Hiển thị danh sách reviews
                          ReviewsList(destinationId: destination.id),
                        ],
                      ),
                    ),
                  ),

                  // Book Now button
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          final user = _authService.currentUser;
                          if (user == null) {
                            showLoginDialog(context);
                            return;
                          }
                          await wishlistProvider.toggleWishlist(
                            widget.id,
                            user,
                          );
                        },
                        child: Text(
                          isInWishlist
                              ? 'Xóa khỏi yêu thích'
                              : 'Lưu vào yêu thích',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
