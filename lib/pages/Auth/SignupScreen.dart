import 'package:app_tourist_destination/services/auth.service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback? onToggleView;

  const SignUpScreen({Key? key, this.onToggleView});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Error state variables
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  // Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _confirmPasswordController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
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
                    'Bắt đầu hành trình nào!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),

                  // Main Signup Form
                  SignupForm(),

                  SizedBox(height: 20),

                  // Already have account text
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Có tài khoản? ',
                          style: TextStyle(color: Colors.white),
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.onToggleView!();
                          },
                          child: Text(
                            'Đăng nhập',
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

  Form SignupForm() {
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
                "Đăng ký",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

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
                            child: TextField(
                              controller: _emailController,
                              cursorColor: Colors.white,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'example@gmail.com',
                                hintStyle: TextStyle(color: Colors.white70),
                                border: InputBorder.none,
                              ),
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
                  // Email error
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
                    SizedBox(height: 5),
                ],
              ),
              SizedBox(height: 10),

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
                            child: TextField(
                              controller: _passwordController,
                              obscureText: !_isPasswordVisible,
                              decoration: InputDecoration(
                                hintText: 'Mật khẩu',
                                hintStyle: TextStyle(color: Colors.blue),
                                border: InputBorder.none,
                              ),
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
                  // Password error
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
                    SizedBox(height: 5),
                ],
              ),
              SizedBox(height: 10),

              // confirm password field
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color:
                            _confirmPasswordError != null ? Colors.red : Colors.blue,
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
                            child: TextField(
                              controller: _confirmPasswordController,
                              obscureText: !_isConfirmPasswordVisible,
                              decoration: InputDecoration(
                                hintText: 'Xác nhận mật khẩu',
                                hintStyle: TextStyle(color: Colors.blue),
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                if (_confirmPasswordError != null) {
                                  setState(() {
                                    _confirmPasswordError = null;
                                  });
                                }
                              },
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                              });
                            },
                            child: Icon(
                              _isConfirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Confirm Password error
                  if (_confirmPasswordError != null) 
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
                            _confirmPasswordError!,
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ],
                      ),
                    )
                  else
                    SizedBox(height: 5),
                ],
              ),

              SizedBox(height: 10),

              // Sign up button
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.blue,
                ),
                child: TextButton(
                  onPressed: _validateAndSignUp,
                  child: Text(
                    'Đăng ký',
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

  void _validateAndSignUp() async {
    // Reset errors
    setState(() {
      _emailError = null;
      _confirmPasswordError = null;
      _passwordError = null;
    });

    // Validate inputs
    bool isValid = true;

    // Email validation
    if (_emailController.text.isEmpty) {
      setState(() {
        _emailError = 'Please enter your email';
      });
      isValid = false;
    } else if (!_emailController.text.contains('@')) {
      setState(() {
        _emailError = 'Please enter a valid email';
      });
      isValid = false;
    }

    // Password validation
    if (_passwordController.text.isEmpty) {
      setState(() {
        _passwordError = 'Please enter a password';
      });
      isValid = false;
    } else if (_passwordController.text.length < 6) {
      setState(() {
        _passwordError = 'Password must be at least 6 characters';
      });
      isValid = false;
    }

        // Confirm password validation
    if (_confirmPasswordController.text.isEmpty) {
      setState(() {
        _confirmPasswordError = 'Please confirm your password';
      });
      isValid = false;
    } else if (_confirmPasswordController.text != _passwordController.text) {
      setState(() {
        _confirmPasswordError = 'Password do not match';
      });
      isValid = false;
    }

    // Proceed with signup if valid
    if (isValid) {
      try {
        // Create user with email and password
        await _authService.createUserWithEmailAndPassword(
          _emailController.text,
          _passwordController.text,
        );

        // Successfully created account
        if (Navigator.canPop(context)) {
          Navigator.pop(context); // Close dialog if in dialog mode
        }
      } on FirebaseAuthException catch (e) {
        // Handle Firebase Auth specific errors
        print(e);
        switch (e.code) {
          case 'email-already-in-use':
            setState(() {
              _emailError = 'Email already in use';
            });
            break;
          case 'invalid-email':
            setState(() {
              _emailError = 'Invalid email format';
            });
            break;
          case 'weak-password':
            setState(() {
              _passwordError = 'Password is too weak';
            });
            break;
          default:
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Signup failed: ${e.code}')));
        }
      } catch (e) {
        // Handle other errors
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('An error occurred: $e')));
      }
    }
  }
}
