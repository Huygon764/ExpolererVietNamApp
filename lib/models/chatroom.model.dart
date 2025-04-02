// chat_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom {
  final String id;
  final String otherUserId;
  final String otherUserName;
  final String? otherUserAvatar;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;

  ChatRoom({
    required this.id,
    required this.otherUserId,
    required this.otherUserName,
    this.otherUserAvatar,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
  });

  factory ChatRoom.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatRoom(
      id: data['chatId'] ?? '',
      otherUserId: data['otherUserId'] ?? '',
      otherUserName: data['otherUserName'] ?? 'Người dùng',
      otherUserAvatar: data['otherUserAvatar'],
      lastMessage: data['lastMessage'] ?? '',
      lastMessageTime: data['lastMessageTime'] != null
          ? (data['lastMessageTime'] as Timestamp).toDate()
          : DateTime.now(),
      unreadCount: data['unreadCount'] ?? 0,
    );
  }
}
