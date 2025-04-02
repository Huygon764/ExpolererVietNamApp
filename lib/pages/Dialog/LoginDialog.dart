import 'package:app_tourist_destination/pages/Auth/LoginScreen.dart';
import 'package:app_tourist_destination/pages/Auth/SignupScreen.dart';
import 'package:flutter/material.dart';

void showLoginDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        insetPadding: EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.65,
          child: LoginDialogContent(),
        ),
      );
    },
  );
}

class LoginDialogContent extends StatefulWidget {
  @override
  _LoginDialogContentState createState() => _LoginDialogContentState();
}

class _LoginDialogContentState extends State<LoginDialogContent> {
  bool _isLoginDialog = true;

  void toggleLoginSignup() {
    setState(() {
      _isLoginDialog = !_isLoginDialog;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _isLoginDialog
            ? LoginScreen(onToggleView: toggleLoginSignup)
            : SignUpScreen(onToggleView: toggleLoginSignup),

        // Thêm nút đóng ở góc phải trên
        Positioned(
          right: 10,
          top: 10,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, color: Colors.blue),
            ),
          ),
        ),
      ],
    );
  }
}
