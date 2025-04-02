import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String id;
  final String userId;
  final String userName;
  final String? userAvatar;
  final double rating;
  final String comment;
  final DateTime timestamp;
  final List<String> images;
  
  Review({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.rating,
    required this.comment,
    required this.timestamp,
    required this.images,
  });
  
  factory Review.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Review(
      id: doc.id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? 'Người dùng ẩn danh',
      userAvatar: data['userAvatar'],
      rating: (data['rating'] ?? 0.0).toDouble(),
      comment: data['comment'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      images: List<String>.from(data['images'] ?? []),
    );
  }
}
