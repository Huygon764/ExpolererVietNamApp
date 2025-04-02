import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WishlistProvider extends ChangeNotifier {
  final List<String> _wishlistIds = [];
  bool _isLoading = false;
  
  // Getters
  List<String> get wishlistIds => _wishlistIds;
  bool get isLoading => _isLoading;
  
  // Kiểm tra xem destination đã được yêu thích chưa
  bool isInWishlist(String destinationId) {
    return _wishlistIds.contains(destinationId);
  }
  
  // Thêm hoặc xóa destination khỏi danh sách yêu thích
  Future<void> toggleWishlist(String destinationId, User user) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      final userId = user.uid;
      final wishlistRef = FirebaseFirestore.instance
          .collection('wishlists')
          .doc(userId);
      
      // Kiểm tra xem document wishlist đã tồn tại chưa
      final docSnapshot = await wishlistRef.get();
      
      if (isInWishlist(destinationId)) {
        // Nếu đã có trong wishlist, xóa đi
        _wishlistIds.remove(destinationId);
        
        if (docSnapshot.exists) {
          await wishlistRef.update({
            'destinations': FieldValue.arrayRemove([destinationId])
          });
        }
      } else {
        // Nếu chưa có trong wishlist, thêm vào
        _wishlistIds.add(destinationId);
        
        if (docSnapshot.exists) {
          await wishlistRef.update({
            'destinations': FieldValue.arrayUnion([destinationId])
          });
        } else {
          // Tạo mới nếu chưa có document
          await wishlistRef.set({
            'destinations': [destinationId],
            'userId': userId,
            'updatedAt': FieldValue.serverTimestamp()
          });
        }
      }
    } catch (e) {
      print('Error toggling wishlist: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Lấy danh sách wishlist từ Firestore
  Future<void> fetchWishlist() async {
    final user = FirebaseAuth.instance.currentUser;
    
    if (user == null) {
      _wishlistIds.clear();
      notifyListeners();
      return;
    }
    
    try {
      _isLoading = true;
      notifyListeners();
      
      final userId = user.uid;
      final wishlistDoc = await FirebaseFirestore.instance
          .collection('wishlists')
          .doc(userId)
          .get();
      
      if (wishlistDoc.exists) {
        final data = wishlistDoc.data() as Map<String, dynamic>;
        final destinations = data['destinations'] as List<dynamic>;
        
        _wishlistIds.clear();
        _wishlistIds.addAll(destinations.map((id) => id.toString()));
      } else {
        _wishlistIds.clear();
      }
    } catch (e) {
      print('Error fetching wishlist: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
