import 'package:app_tourist_destination/services/auth.service.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback? onToggleView;

  const LoginScreen({Key? key, this.onToggleView}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  AuthService _authService = AuthService();

  bool _isPasswordVisible = false;

  // Biến lưu lỗi
  String? _emailError;
  String? _passwordError;
  String? _loginError;

  // Thêm controllers để quản lý input
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // Giải phóng controllers khi widget bị hủy
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        image: DecorationImage(
          image: AssetImage('assets/images/sunset1.jpg'),
          fit: BoxFit.cover,
          opacity: 0.5,
        ),
      ),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(height: 20),
                  Text(
                    'Mừng trở lại!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),

                  // Main Card
                  FormLogin(context),

                  SizedBox(height: 30),

                  // Social login options
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocialLoginButton(
                        iconPath: 'assets/images/google_icon.jpg',
                        onTap: () async {
                          final user = await _authService.signInWithGoogle();
                          if (user.user != null) {
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                      // SizedBox(width: 20),
                      // SocialLoginButton(
                      //   iconPath: 'assets/images/facebook_icon.png',
                      //   onTap: () {
                      //     _authService.signInWithFacebook();
                      //   },
                      // ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Sign up text
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Không có tài khoản? ',
                          style: TextStyle(color: Colors.white),
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.onToggleView!();
                          },
                          child: Text(
                            'Đăng ký',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Form FormLogin(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Text(
                "Explorer VietNam",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              if (_loginError != null)
                Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 5),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, size: 14, color: Colors.red),
                      SizedBox(width: 4),
                      Text(
                        _loginError!,
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ],
                  ),
                ),

              // Email field
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(30),
                      border:
                          _emailError != null
                              ? Border.all(color: Colors.red, width: 1.0)
                              : null,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        children: [
                          Icon(Icons.email_outlined, color: Colors.white),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: _emailController,
                              cursorColor: Colors.white,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'example@gmail.com',
                                hintStyle: TextStyle(color: Colors.white70),
                                border: InputBorder.none,
                                errorStyle: TextStyle(height: 0),
                                errorText: null,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  setState(() {
                                    _emailError = 'Please enter your email';
                                  });
                                  return ''; // Return empty string to trigger error
                                }
                                if (!value.contains('@')) {
                                  setState(() {
                                    _emailError = 'Please enter a valid email';
                                  });
                                  return '';
                                }
                                setState(() {
                                  _emailError = null;
                                });
                                return null;
                              },
                              onChanged: (value) {
                                if (_emailError != null) {
                                  setState(() {
                                    _emailError = null;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Error text hiển thị bên ngoài
                  if (_emailError != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 5),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 14,
                            color: Colors.red,
                          ),
                          SizedBox(width: 4),
                          Text(
                            _emailError!,
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ],
                      ),
                    )
                  else
                    SizedBox(height: 10),
                ],
              ),

              // Password field
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color:
                            _passwordError != null ? Colors.red : Colors.blue,
                        width: 1.5,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        children: [
                          Icon(Icons.lock_outline, color: Colors.blue),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: !_isPasswordVisible,
                              decoration: InputDecoration(
                                hintText: 'Mật khẩu',
                                hintStyle: TextStyle(color: Colors.blue),
                                border: InputBorder.none,
                                errorStyle: TextStyle(
                                  height: 0,
                                  color: Colors.transparent,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  setState(() {
                                    _passwordError =
                                        'Please enter your password';
                                  });
                                  return '';
                                }
                                if (value.length < 6) {
                                  setState(() {
                                    _passwordError =
                                        'Password must be at least 6 characters';
                                  });
                                  return '';
                                }
                                setState(() {
                                  _passwordError = null;
                                });
                                return null;
                              },
                              onChanged: (value) {
                                if (_passwordError != null) {
                                  setState(() {
                                    _passwordError = null;
                                  });
                                }
                              },
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                            child: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Error text cho password
                  if (_passwordError != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 5),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 14,
                            color: Colors.red,
                          ),
                          SizedBox(width: 4),
                          Text(
                            _passwordError!,
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ],
                      ),
                    )
                  else
                    SizedBox(height: 10),
                ],
              ),
              SizedBox(height: 15),

              // Sign in button
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.blue,
                ),
                child: TextButton(
                  onPressed: () async {
                    // Xóa lỗi hiện tại trước khi validate
                    setState(() {
                      _emailError = null;
                      _passwordError = null;
                    });

                    if (_formKey.currentState!.validate()) {
                      try {
                        // Lấy email và password từ TextEditingController
                        await _authService.signInWithEmailAndPassword(
                          _emailController.text,
                          _passwordController.text,
                        );
                        // Đóng dialog nếu đăng nhập thành công
                        Navigator.of(context).pop();
                      } catch (e) {
                        setState(() {
                          _loginError = 'Wrong username or password';
                        });
                      }
                    }
                  },
                  child: Text(
                    'Đăng nhập',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SocialLoginButton extends StatelessWidget {
  final String iconPath;
  final VoidCallback onTap;

  const SocialLoginButton({
    Key? key,
    required this.iconPath,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ClipOval(child: Image.asset(iconPath, width: 20, height: 20)),
      ),
    );
  }
}
