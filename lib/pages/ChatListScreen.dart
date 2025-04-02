import 'package:app_tourist_destination/models/chatroom.model.dart';
import 'package:app_tourist_destination/pages/ChatScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Tin nhắn'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users_chats')
            .doc(currentUser?.uid)
            .collection('chats')
            .orderBy('lastMessageTime', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Đã xảy ra lỗi: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Chưa có cuộc trò chuyện nào'),
                ],
              ),
            );
          }

          final chatRooms = snapshot.data!.docs
              .map((doc) => ChatRoom.fromFirestore(doc))
              .toList();

          return ListView.separated(
            itemCount: chatRooms.length,
            separatorBuilder: (context, index) => Divider(height: 1),
            itemBuilder: (context, index) {
              final room = chatRooms[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: room.otherUserAvatar != null
                      ? NetworkImage(room.otherUserAvatar!)
                      : null,
                  child: room.otherUserAvatar == null
                      ? Text(room.otherUserName[0].toUpperCase())
                      : null,
                ),
                title: Text(room.otherUserName),
                subtitle: Text(
                  room.lastMessage.isEmpty 
                      ? 'Bắt đầu cuộc trò chuyện' 
                      : room.lastMessage,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatTime(room.lastMessageTime),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    if (room.unreadCount > 0)
                      Container(
                        margin: EdgeInsets.only(top: 4),
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          room.unreadCount.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(
                        chatId: room.id,
                        otherUserId: room.otherUserId,
                        otherUserName: room.otherUserName,
                        otherUserAvatar: room.otherUserAvatar,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
  
  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final messageDate = DateTime(time.year, time.month, time.day);
    
    if (messageDate == today) {
      return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    } else if (messageDate == yesterday) {
      return 'Hôm qua';
    } else {
      return '${time.day}/${time.month}';
    }
  }
}
