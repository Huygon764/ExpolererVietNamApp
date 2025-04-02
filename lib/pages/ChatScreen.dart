// chat_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String otherUserId;
  final String otherUserName;
  final String? otherUserAvatar;

  ChatScreen({
    required this.chatId,
    required this.otherUserId,
    required this.otherUserName,
    this.otherUserAvatar,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<types.Message> _messages = [];
  late final User _user;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    
    // Reset unread count when opening chat
    FirebaseFirestore.instance
        .collection('users_chats')
        .doc(_user.uid)
        .collection('chats')
        .doc(widget.chatId)
        .update({'unreadCount': 0});
        
    _loadMessages();
  }

  void _loadMessages() {
    FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      final messages = snapshot.docs.map((doc) {
        final data = doc.data();
        final authorId = data['author'] ?? '';
        final isMe = authorId == _user.uid;
        
        final author = types.User(
          id: authorId,
          firstName: isMe ? _user.displayName ?? 'Tôi' : widget.otherUserName,
          imageUrl: isMe ? _user.photoURL : widget.otherUserAvatar,
        );
        
        if (data['type'] == 'image') {
          return types.ImageMessage(
            id: doc.id,
            author: author,
            name: 'image-name',
            uri: data['imageUrl'] ?? '',
            size: data['size'] ?? 0,
            createdAt: data['timestamp'] != null
                ? (data['timestamp'] as Timestamp).millisecondsSinceEpoch
                : DateTime.now().millisecondsSinceEpoch,
          );
        }
        
        // Default to text message
        return types.TextMessage(
          id: doc.id,
          author: author,
          text: data['text'] ?? '',
          createdAt: data['timestamp'] != null
              ? (data['timestamp'] as Timestamp).millisecondsSinceEpoch
              : DateTime.now().millisecondsSinceEpoch,
        );
      }).toList();
      
      setState(() {
        _messages = messages;
      });
    });
  }

  void _handleSendPressed(types.PartialText message) async {
    final messageData = {
      'author': _user.uid,
      'text': message.text,
      'timestamp': FieldValue.serverTimestamp(),
      'type': 'text',
    };

    // Add message to Firestore
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .add(messageData);

    // Update last message for both users
    await _updateChatInfo(message.text);
  }

  Future<void> _updateChatInfo(String messageText) async {
    // Update for current user
    await FirebaseFirestore.instance
        .collection('users_chats')
        .doc(_user.uid)
        .collection('chats')
        .doc(widget.chatId)
        .update({
      'lastMessage': messageText,
      'lastMessageTime': FieldValue.serverTimestamp(),
    });

    // Update or create for other user
    final otherUserChatRef = FirebaseFirestore.instance
        .collection('users_chats')
        .doc(widget.otherUserId)
        .collection('chats')
        .doc(widget.chatId);

    final otherUserChatDoc = await otherUserChatRef.get();

    if (otherUserChatDoc.exists) {
      await otherUserChatRef.update({
        'lastMessage': messageText,
        'lastMessageTime': FieldValue.serverTimestamp(),
        'unreadCount': FieldValue.increment(1),
      });
    } else {
      await otherUserChatRef.set({
        'chatId': widget.chatId,
        'otherUserId': _user.uid,
        'otherUserName': _user.displayName ?? 'Người dùng',
        'otherUserAvatar': _user.photoURL,
        'lastMessage': messageText,
        'lastMessageTime': FieldValue.serverTimestamp(),
        'unreadCount': 1,
      });
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      setState(() {
        _isLoading = true;
      });
      
      final file = File(result.path);
      
      // Upload image to Firebase Storage
      final String imageId = const Uuid().v4();
      final ref = FirebaseStorage.instance
          .ref()
          .child('chat')
          .child(widget.chatId)
          .child('$imageId.jpg');
          
      final uploadTask = ref.putFile(file);
      final snapshot = await uploadTask.whenComplete(() {});
      final imageUrl = await snapshot.ref.getDownloadURL();
      
      // Get image dimensions
      final decodedImage = await decodeImageFromList(file.readAsBytesSync());
      
      // Add image message to Firestore
      final imageMessage = {
        'author': _user.uid,
        'imageUrl': imageUrl,
        'height': decodedImage.height,
        'width': decodedImage.width,
        'size': file.lengthSync(),
        'timestamp': FieldValue.serverTimestamp(),
        'type': 'image',
      };
      
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId)
          .collection('messages')
          .add(imageMessage);
          
      // Update last message info
      await _updateChatInfo('Đã gửi một hình ảnh');
      
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: widget.otherUserAvatar != null
                  ? NetworkImage(widget.otherUserAvatar!)
                  : null,
              radius: 16,
              child: widget.otherUserAvatar == null
                  ? Text(widget.otherUserName[0].toUpperCase())
                  : null,
            ),
            SizedBox(width: 8),
            Text(widget.otherUserName),
          ],
        ),
      ),
      body: Chat(
        messages: _messages,
        onSendPressed: _handleSendPressed,
        user: types.User(id: _user.uid),
        theme: DefaultChatTheme(
          inputBackgroundColor: Theme.of(context).primaryColor,
          primaryColor: Colors.blue,
          secondaryColor: Colors.grey[300]!,
        ),
        showUserAvatars: true,
        showUserNames: true,
        isAttachmentUploading: _isLoading,
        onAttachmentPressed: _handleImageSelection,
      ),
    );
  }
}
