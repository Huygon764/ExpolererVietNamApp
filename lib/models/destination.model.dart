class DestinationModel {
  final String id;
  final String name;
  final String shortDescription;
  final String description;
  final String categoryId;
  final String location;
  final double rating;
  final int totalReviews;
  final String image;
  final List<String> previewImages;

  DestinationModel({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.description,
    required this.categoryId,
    required this.location,
    this.rating = 0.0,
    this.totalReviews = 0,
    required this.image,
    required this.previewImages,
  });

  factory DestinationModel.fromFirestore(Map<String, dynamic> data) {
    return DestinationModel(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      shortDescription: data['short_description'] ?? '',
      description: data['description'] ?? '',
      categoryId: data['category']?.id ?? '',
      location: data['location'],
      rating: (data['rating'] ?? 0.0).toDouble(),
      totalReviews: data['total_reviews'] ?? 0,
      image: data['image'] ?? '',
      previewImages: List<String>.from(data['preview_images'] ?? []),
    );
  }
}
