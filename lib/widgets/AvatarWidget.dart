import 'package:app_tourist_destination/services/user.service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Widget buildAvatar(User? user) {
  final _userService = UserService();
  if (user == null) {
    return CircleAvatar(
      radius: 25,
      backgroundColor: Colors.blue[100],
      child: Icon(Icons.person, color: Colors.blue),
    );
  }

  if (user.photoURL != null) {
    return CircleAvatar(
      radius: 25,
      backgroundColor: Colors.blue[100],
      backgroundImage: NetworkImage(user.photoURL!),
    );
  } else {
    return CircleAvatar(
      radius: 30,
      backgroundColor: Colors.blue[200],
      child: Text(_userService.getUserInitials(user)),
    );
  }
}

Widget buildAvatarProfile(User? user, {VoidCallback? onTapCamera}) {
  return Stack(
    children: [
      // Avatar hiện tại
      buildAvatar(user),
      // CircleAvatar(
      //   radius: 30,
      //   backgroundColor: Colors.blue[100],
      //   backgroundImage:
      //       user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
      //   child:
      //       user == null
      //           ? Icon(Icons.person)
      //           : Text(_userService.getUserInitials(user)),
      // ),

      // Nút camera ở góc phải dưới
      Positioned(
        right: 0,
        bottom: 0,
        child: GestureDetector(
          onTap: onTapCamera,
          child: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.camera_alt, color: Colors.white, size: 18),
          ),
        ),
      ),
    ],
  );
}
