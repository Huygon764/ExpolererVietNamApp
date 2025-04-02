import 'dart:io';

import 'package:app_tourist_destination/pages/Dialog/LoginDialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';

class AddReviewSection extends StatefulWidget {
  final String destinationId;

  AddReviewSection({required this.destinationId});

  @override
  _AddReviewSectionState createState() => _AddReviewSectionState();
}

class _AddReviewSectionState extends State<AddReviewSection> {
  final _commentController = TextEditingController();
  double _rating = 5.0;
  List<File> _selectedImages = [];
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      // margin: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Đánh giá của bạn',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),

          // Rating Stars
          Row(
            children: [
              Text('Đánh giá: ', style: TextStyle(fontSize: 16)),
              RatingBar.builder(
                initialRating: _rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 24,
                itemBuilder:
                    (context, _) => Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 16),

          // Comment TextField
          TextField(
            controller: _commentController,
            decoration: InputDecoration(
              hintText: 'Chia sẻ trải nghiệm của bạn...',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          SizedBox(height: 16),

          // Image Upload
          Row(
            children: [
              ElevatedButton.icon(
                icon: Icon(Icons.photo_camera),
                label: Text('Thêm ảnh'),
                onPressed: _pickImages,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[100],
                  foregroundColor: Colors.blue[800],
                ),
              ),
              SizedBox(width: 8),
              Text('${_selectedImages.length} ảnh đã chọn'),
            ],
          ),

          // Selected Images Preview
          if (_selectedImages.isNotEmpty)
            Container(
              height: 100,
              margin: EdgeInsets.symmetric(vertical: 16),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _selectedImages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            _selectedImages[index],
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedImages.removeAt(index);
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

          // Submit Button
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              child:
                  _isSubmitting
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Đăng đánh giá'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: _isSubmitting ? null : _submitReview,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImages() async {
    final ImagePicker _picker = ImagePicker();
    final List<XFile>? images = await _picker.pickMultiImage();

    if (images != null) {
      setState(() {
        _selectedImages.addAll(
          images.map((xFile) => File(xFile.path)).toList(),
        );
      });
    }
  }

  Future<void> _submitReview() async {
    if (_commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng nhập nội dung đánh giá')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Upload images if any
      List<String> imageUrls = [];
      for (var imageFile in _selectedImages) {
        String fileName =
            'reviews/${widget.destinationId}/${DateTime.now().millisecondsSinceEpoch}_${imageUrls.length}.jpg';
        Reference ref = FirebaseStorage.instance.ref().child(fileName);

        await ref.putFile(imageFile);
        String downloadUrl = await ref.getDownloadURL();
        imageUrls.add(downloadUrl);
      }

      // Get current user
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        showLoginDialog(context);
        setState(() {
          _isSubmitting = false;
        });
        return;
      }

      // Tạo transaction để đảm bảo tính nhất quán của dữ liệu
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        // Lấy dữ liệu destination hiện tại
        DocumentReference destRef = FirebaseFirestore.instance
            .collection('destinations')
            .doc(widget.destinationId);

        DocumentSnapshot destDoc = await transaction.get(destRef);

        if (destDoc.exists) {
          Map<String, dynamic> destData =
              destDoc.data() as Map<String, dynamic>;

          // Tính toán rating mới
          double currentRating = (destData['rating'] ?? 0.0).toDouble();
          int currentTotalReviews = (destData['totalReviews'] ?? 0);

          double newTotalRatingPoints =
              (currentRating * currentTotalReviews) + _rating;
          int newTotalReviews = currentTotalReviews + 1;
          double newRating = newTotalRatingPoints / newTotalReviews;

          // Cập nhật destination
          transaction.update(destRef, {
            'rating': newRating,
            'totalReviews': newTotalReviews,
          });
        }

        // Thêm review mới
        DocumentReference reviewRef =
            FirebaseFirestore.instance
                .collection('destinations')
                .doc(widget.destinationId)
                .collection('reviews')
                .doc();

        transaction.set(reviewRef, {
          'userId': user.uid,
          'userName': user.displayName ?? 'Người dùng ẩn danh',
          'userAvatar': user.photoURL,
          'rating': _rating,
          'comment': _commentController.text.trim(),
          'timestamp': FieldValue.serverTimestamp(),
          'images': imageUrls,
        });
      });

      // Reset form
      setState(() {
        _commentController.clear();
        _rating = 5.0;
        _selectedImages.clear();
        _isSubmitting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đánh giá của bạn đã được đăng thành công')),
      );
    } catch (e) {
      print('Error submitting review: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã xảy ra lỗi. Vui lòng thử lại.')),
      );
      setState(() {
        _isSubmitting = false;
      });
    }
  }
}
