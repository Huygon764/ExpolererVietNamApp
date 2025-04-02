import 'package:app_tourist_destination/models/destination.model.dart';
import 'package:app_tourist_destination/pages/AllDestinationScreen.dart';
import 'package:app_tourist_destination/pages/Dialog/LoginDialog.dart';
import 'package:app_tourist_destination/pages/PlaceDetailScreen.dart';
import 'package:app_tourist_destination/providers/NavigationProvider.dart';
import 'package:app_tourist_destination/widgets/ImageWidget.dart';
import 'package:app_tourist_destination/services/auth.service.dart';
import 'package:app_tourist_destination/services/categoryService.dart';
import 'package:app_tourist_destination/services/destination.service.dart';
import 'package:app_tourist_destination/widgets/AvatarWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TravelHomePage extends StatefulWidget {
  @override
  State<TravelHomePage> createState() => _TravelHomePageState();
}

class _TravelHomePageState extends State<TravelHomePage> {
  final AuthService _authService = AuthService();

  String categoryId = '';

  void onCategoryTap(String newCategoryId) {
    setState(() {
      categoryId = newCategoryId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "VietnamExplorer",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              if (_authService.currentUser == null) {
                showLoginDialog(context);
              } else {
                Provider.of<NavigationProvider>(
                  context,
                  listen: false,
                ).setIndex(3);
              }
            },
            child: buildAvatar(_authService.currentUser),
          ),
        ],
        actionsPadding: EdgeInsets.all(16),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CategoryAndFeaturedSection(),
                SizedBox(height: 20),
                PopularDestinations(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CategorySection extends StatelessWidget {
  final CategoryService _categoryService = CategoryService();

  final Function onCategoryTap;
  final String categoryId;
  CategorySection({
    super.key,
    required this.onCategoryTap,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Thể loại',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllDestinationScreen(),
                  ),
                );
              },
              child: Row(
                children: [
                  Text('Tất cả', style: TextStyle(color: Colors.blue)),
                  Icon(Icons.arrow_forward, size: 16, color: Colors.blue),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 10),

        StreamBuilder(
          stream: _categoryService.getCategories(),
          builder: (context, snapshot) {
            final categories = snapshot.data ?? [];

            return SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color:
                                categoryId == categories[index].id
                                    ? Colors.blue
                                    : Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              onCategoryTap(categories[index].id);
                            },
                            child: Row(
                              children: [
                                Text(
                                  categories[index].name,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color:
                                        categoryId == categories[index].id
                                            ? Colors.white
                                            : Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

class FeaturedDestinations extends StatefulWidget {
  final String categoryId;
  const FeaturedDestinations(this.categoryId, {super.key});

  @override
  State<FeaturedDestinations> createState() => _FeaturedDestinationsState();
}

class _FeaturedDestinationsState extends State<FeaturedDestinations> {
  final DestinationService _destinationService = DestinationService();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      child: StreamBuilder<List<DestinationModel>>(
        stream:
            widget.categoryId != ''
                ? _destinationService.getDestinationsByCategory(
                  widget.categoryId,
                )
                : _destinationService.getDestinations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          List<DestinationModel> destinations = snapshot.data ?? [];

          if (destinations.isEmpty) {
            return Center(child: Text('No destinations found'));
          }

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: destinations.length,
            itemBuilder: (context, index) {
              DestinationModel destination = destinations[index];
              return Container(
                margin: EdgeInsets.only(right: 16),
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    PlaceDetailScreen(id: destination.id),
                          ),
                        );
                      },
                      child: StorageImage(
                        imageName: destinations[index].image,
                        width: MediaQuery.of(context).size.width * 0.55,
                        height: 200,
                      ),
                    ),

                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => PlaceDetailScreen(
                                          id: destination.id,
                                        ),
                                  ),
                                );
                              },
                              child: Text(
                                destination.name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.white,
                                      size: 12,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      destination.location,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class CategoryAndFeaturedSection extends StatefulWidget {
  @override
  _CategoryAndFeaturedSectionState createState() =>
      _CategoryAndFeaturedSectionState();
}

class _CategoryAndFeaturedSectionState
    extends State<CategoryAndFeaturedSection> {
  String categoryId = '';

  void onCategoryTap(String newCategoryId) {
    setState(() {
      categoryId = newCategoryId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CategorySection(onCategoryTap: onCategoryTap, categoryId: categoryId),
        FeaturedDestinations(categoryId),
      ],
    );
  }
}

class PopularDestinations extends StatefulWidget {
  @override
  State<PopularDestinations> createState() => _PopularDestinationsState();
}

class _PopularDestinationsState extends State<PopularDestinations> {
  DestinationService _destinationService = DestinationService();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Phổ biến',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 16),
        StreamBuilder(
          stream: _destinationService.getPopularDestinations(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            List<DestinationModel> destinations = snapshot.data ?? [];

            if (destinations.isEmpty) {
              return Center(child: Text('No destinations found'));
            }

            return ListView.builder(
              shrinkWrap: true,
              itemCount: destinations.length,
              itemBuilder: (context, index) {
                DestinationModel destination = destinations[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).dividerColor,
                        spreadRadius: 3,
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      PlaceDetailScreen(id: destination.id),
                            ),
                          );
                        },
                        child: StorageImage(
                          imageName: destination.image,
                          width: 150,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => PlaceDetailScreen(
                                          id: destination.id,
                                        ),
                                  ),
                                );
                              },
                              child: Text(
                                destination.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),

                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.blue,
                                  size: 14,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  destination.location,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Text(
                              destination.shortDescription,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            Row(
                              spacing: 5,
                              children: [
                                RatingStars(rating: destination.rating),
                                Text(destination.rating.toString()),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
