import 'package:app_tourist_destination/models/destination.model.dart';
import 'package:app_tourist_destination/pages/PlaceDetailScreen.dart';
import 'package:app_tourist_destination/widgets/ImageWidget.dart';
import 'package:app_tourist_destination/services/destination.service.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';

class AllDestinationScreen extends StatefulWidget {
  const AllDestinationScreen({super.key});

  @override
  State<AllDestinationScreen> createState() => _AllDestinationScreenState();
}

class _AllDestinationScreenState extends State<AllDestinationScreen> {
  String searchText = '';

  void onSearchTextChanged(String text) {
    setState(() {
      searchText = text;
    });
  }

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
              Row(
                spacing: 15,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back, color: Colors.blue, size: 24),
                  ),
                  Text(
                    'Tất cả địa điểm',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 20),
              SearchBar(onSearchTextChanged: onSearchTextChanged),
              SizedBox(height: 20),
              Expanded(child: AllDestination(searchText: searchText)),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  final Function onSearchTextChanged;

  const SearchBar({Key? key, required this.onSearchTextChanged})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.search,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
          hintText: 'Tìm kiếm',
          contentPadding: EdgeInsets.only(top: 12),
        ),
        onChanged: (value) {
          onSearchTextChanged(value);
        },
      ),
    );
  }
}

class AllDestination extends StatefulWidget {
  String searchText = '';

  AllDestination({Key? key, this.searchText = ''}) : super(key: key);

  @override
  State<AllDestination> createState() => _AllDestinationState();
}

class _AllDestinationState extends State<AllDestination> {
  DestinationService _destinationService = DestinationService();
  late Stream<List<DestinationModel>> _destinationsStream;

  @override
  void initState() {
    super.initState();
    _destinationsStream = _destinationService.getDestinations();
  }

  String normalize(String input) {
    return removeDiacritics(input.toLowerCase());
  }

  // Sử dụng
  bool isMatch(DestinationModel des) {
    final normalizedSearchText = normalize(widget.searchText);
    final normalizedName = normalize(des.name);
    final normalizedDescription = normalize(des.description);

    return normalizedName.contains(normalizedSearchText) ||
        normalizedDescription.contains(normalizedSearchText);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _destinationsStream,
      builder: (context, snapshot) {
        final destinations = snapshot.data ?? [];
        final filteredDestinations =
            destinations.where((des) {
              return isMatch(des);
            }).toList();

        if (filteredDestinations.isEmpty) {
          return Center(
            child: Text(
              'No destinations found',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          );
        }
        return ListView.separated(
          itemCount: filteredDestinations.length,
          separatorBuilder: (context, index) => SizedBox(height: 15),
          itemBuilder: (context, index) {
            final item = filteredDestinations[index];
            return DestinationItem(
              id: item.id,
              name: item.name,
              rating: item.rating,
              description: item.description,
              image: item.image,
            );
          },
        );
      },
    );
  }
}

class DestinationItem extends StatelessWidget {
  final String id;
  final String name;
  final double rating;
  final String description;
  final String image;

  const DestinationItem({
    Key? key,
    required this.id,
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
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlaceDetailScreen(id: id),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: StorageImage(
                imageName: image,
                width: 110,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlaceDetailScreen(id: id),
                        ),
                      );
                    },
                    child: Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      RatingStars(rating: rating),
                      SizedBox(width: 6),
                      Text(
                        rating.toString(),
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
