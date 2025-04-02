import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Đăng nhập bằng email và password
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow; // Ném lại lỗi để xử lý ở nơi gọi
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      //should store in env
      final clientId = dotenv.env['GOOGLE_CLIENT_ID'] ?? '';
      print(clientId);
      // Kích hoạt flow đăng nhập
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
        clientId: clientId
      ).signIn();

      // Nếu người dùng hủy đăng nhập
      if (googleUser == null) {
        throw FirebaseAuthException(
          code: 'sign-in-cancelled',
          message: 'Google sign in was cancelled by the user',
        );
      }

      // Lấy thông tin xác thực từ request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Tạo credential cho Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Đăng nhập với credential
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print('Google sign in error: $e');
      rethrow;
    }
  }

  Future<UserCredential> signInWithFacebook() async {
    try {
      // Kích hoạt flow đăng nhập
      final LoginResult loginResult = await FacebookAuth.instance.login();

      // Kiểm tra trạng thái đăng nhập
      if (loginResult.status != LoginStatus.success) {
        throw FirebaseAuthException(
          code: 'facebook-login-failed',
          message: 'Facebook login failed with status: ${loginResult.status}',
        );
      }

      // Tạo credential cho Firebase
      final OAuthCredential credential = FacebookAuthProvider.credential(
        loginResult.accessToken!.tokenString,
      );

      // Đăng nhập với credential
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print('Facebook sign in error: $e');
      rethrow;
    }
  }

  // Đăng ký tài khoản mới
  Future<UserCredential> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Đăng xuất
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Lấy người dùng hiện tại
  User? get currentUser => _auth.currentUser;

  // Stream thông tin người dùng (sẽ emit mỗi khi trạng thái auth thay đổi)
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
