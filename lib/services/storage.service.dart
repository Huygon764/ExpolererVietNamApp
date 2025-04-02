import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Cache URLs để tránh tải lại nhiều lần
  final Map<String, String> _urlCache = {};

  // Hàm lấy URL từ tên file
  Future<String> getImageUrl(String imageName, String? folder) async {
    // Kiểm tra cache trước
    if (_urlCache.containsKey(imageName)) {
      return _urlCache[imageName]!;
    }

    try {
      // Tạo reference đến file trong storage
      final ref =
          (folder == null || folder == '')
              ? _storage.ref().child(imageName)
              : _storage.ref().child(folder).child(imageName);

      // Lấy URL download
      final url = await ref.getDownloadURL();

      // Lưu vào cache
      _urlCache[imageName] = url;

      return url;
    } catch (e) {
      print('Error getting URL for $imageName: $e');
      return ''; // Trả về chuỗi rỗng nếu có lỗi
    }
  }

  // Hàm lấy danh sách URLs từ danh sách tên file
  Future<List<String>> getImageUrls(
    List<String> imageNames,
    String? folder,
  ) async {
    List<String> urls = [];
    for (String name in imageNames) {
      String url = await getImageUrl(name, folder);
      if (url.isNotEmpty) {
        urls.add(url);
      }
    }
    return urls;
  }
}
