import 'package:app_tourist_destination/pages/ChatScreen.dart';
import 'package:app_tourist_destination/pages/Dialog/LoginDialog.dart';
import 'package:app_tourist_destination/widgets/GalleryViewCommentWidget.dart';
import 'package:app_tourist_destination/widgets/GalleryWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReviewsList extends StatelessWidget {
  final String destinationId;

  ReviewsList({required this.destinationId});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
          child: Text(
            'Đánh giá từ du khách',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),

        StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance
                  .collection('destinations')
                  .doc(destinationId)
                  .collection('reviews')
                  .orderBy('timestamp', descending: true)
                  .limit(20)
                  .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Đã xảy ra lỗi: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    'Chưa có đánh giá nào. Hãy là người đầu tiên đánh giá!',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            return ListView.separated(
              separatorBuilder: (context, index) => Divider(),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final doc = snapshot.data!.docs[index];
                final data = doc.data() as Map<String, dynamic>;

                return ReviewItem(reviewData: data);
              },
            );
          },
        ),
      ],
    );
  }
}

class ReviewItem extends StatelessWidget {
  final Map<String, dynamic> reviewData;

  ReviewItem({required this.reviewData});

  void _openChat(BuildContext context) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      showLoginDialog(context);
      return;
    }

    if (currentUser.uid == reviewData['userId']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể trò chuyện với chính mình',)),
      );
      return;
    }

    try {
      // Kiểm tra xem cuộc trò chuyện đã tồn tại chưa
      final existingChats =
          await FirebaseFirestore.instance
              .collection('users_chats')
              .doc(currentUser.uid)
              .collection('chats')
              .where('otherUserId', isEqualTo: reviewData['userId'])
              .get();

      String chatId;

      if (existingChats.docs.isNotEmpty) {
        // Cuộc trò chuyện đã tồn tại
        chatId = existingChats.docs.first['chatId'];
      } else {
        // Tạo cuộc trò chuyện mới
        chatId = FirebaseFirestore.instance.collection('chats').doc().id;

        // Thêm thông tin chat cho người dùng hiện tại
        await FirebaseFirestore.instance
            .collection('users_chats')
            .doc(currentUser.uid)
            .collection('chats')
            .doc(chatId)
            .set({
              'chatId': chatId,
              'otherUserId': reviewData['userId'],
              'otherUserName': reviewData['userName'],
              'otherUserAvatar': reviewData['userAvatar'],
              'lastMessage': '',
              'lastMessageTime': FieldValue.serverTimestamp(),
              'unreadCount': 0,
            });
      }

      // Chuyển đến màn hình chat
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => ChatScreen(
                chatId: chatId,
                otherUserId: reviewData['userId'],
                otherUserName: reviewData['userName'],
                otherUserAvatar: reviewData['userAvatar'],
              ),
        ),
      );
    } catch (e) {
      print('Error opening chat: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã xảy ra lỗi. Vui lòng thử lại.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final timestamp = reviewData['timestamp'] as Timestamp?;
    final formattedDate =
        timestamp != null
            ? DateFormat('dd/MM/yyyy HH:mm').format(timestamp.toDate())
            : 'Vừa xong';

    final List<dynamic> imagesList = reviewData['images'] ?? [];

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info and rating
          Row(
            children: [
              // User Avatar
              GestureDetector(
                onTap: () {
                  _openChat(context);
                },
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage:
                          reviewData['userAvatar'] != null
                              ? NetworkImage(reviewData['userAvatar'])
                              : null,
                      child:
                          reviewData['userAvatar'] == null
                              ? Icon(Icons.person)
                              : null,
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.chat, size: 10, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12),

              // User name and date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reviewData['userName'] ?? 'Người dùng ẩn danh',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      formattedDate,
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),

              // Rating
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 18),
                  SizedBox(width: 4),
                  Text(
                    '${(reviewData['rating'] ?? 0.0).toStringAsFixed(1)}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),

          // Comment text
          if (reviewData['comment'] != null &&
              reviewData['comment'].toString().isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text(reviewData['comment']),
            ),

          // Images
          if (imagesList.isNotEmpty)
            Container(
              height: 120,
              margin: EdgeInsets.only(top: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: imagesList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => GalleryViewComment(
                                imageUrls: List<String>.from(imagesList),
                                initialIndex: index,
                              ),
                        ),
                      );
                    },
                    child: Container(
                      width: 120,
                      margin: EdgeInsets.only(right: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          imagesList[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
