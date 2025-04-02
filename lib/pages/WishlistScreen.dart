import 'package:app_tourist_destination/providers/NavigationProvider.dart';
import 'package:app_tourist_destination/providers/WishlistProvider.dart';
import 'package:app_tourist_destination/widgets/ImageWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                'Danh sách yêu thích',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Expanded(child: WishlistItemsList()),
            ],
          ),
        ),
      ),
    );
  }
}

class WishlistItemsList extends StatefulWidget {
  @override
  State<WishlistItemsList> createState() => _WishlistItemsListState();
}

class _WishlistItemsListState extends State<WishlistItemsList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WishlistProvider>(context, listen: false).fetchWishlist();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WishlistProvider>(
      builder: (context, wishlistProvider, child) {
        if (wishlistProvider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (wishlistProvider.wishlistIds.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Your wishlist is empty',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
                SizedBox(height: 10),
                Text(
                  'Save your favorite destinations here',
                  style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    // Chuyển đến màn hình Home
                    Provider.of<NavigationProvider>(
                      context,
                      listen: false,
                    ).setIndex(0);
                  },
                  icon: Icon(Icons.search),
                  label: Text('Discover Destinations'),
                ),
              ],
            ),
          );
        }

        return FutureBuilder<QuerySnapshot>(
          future:
              FirebaseFirestore.instance
                  .collection('destinations')
                  .where(
                    FieldPath.documentId,
                    whereIn: wishlistProvider.wishlistIds,
                  )
                  .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            List<DocumentSnapshot> destinations = snapshot.data?.docs ?? [];

            if (destinations.isEmpty) {
              return Center(child: Text('No destinations found'));
            }

            return ListView.separated(
              itemCount: destinations.length,
              separatorBuilder: (context, index) => SizedBox(height: 15),
              itemBuilder: (context, index) {
                final item = destinations[index];
                return WishlistItem(
                  name: item['name'],
                  rating: item['rating'],
                  description: item['description'],
                  image: item['image'],
                );
              },
            );
          },
        );
      },
    );
  }
}

class WishlistItem extends StatelessWidget {
  final String name;
  final double rating;
  final String description;
  final String image;

  const WishlistItem({
    Key? key,
    required this.name,
    required this.rating,
    required this.description,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: StorageImage(
              imageName: image,
              width: 110,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Icon(Icons.favorite, color: Colors.red, size: 24),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      RatingStars(rating: rating),
                      SizedBox(width: 6),
                      Text(
                        rating.toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RatingStars extends StatelessWidget {
  final double rating;

  const RatingStars({Key? key, required this.rating}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating.floor()
              ? Icons.star
              : index < rating
              ? Icons.star_half
              : Icons.star_border,
          color: Colors.amber,
          size: 14,
        );
      }),
    );
  }
}
