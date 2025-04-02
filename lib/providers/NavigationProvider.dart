import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  // Biến lưu trạng thái tab hiện tại
  int _selectedIndex = 0;
  
  // Getter để đọc trạng thái hiện tại
  int get selectedIndex => _selectedIndex;
  
  // Phương thức để thay đổi tab
  void setIndex(int index) {
    // Chỉ cập nhật nếu tab thay đổi
    if (_selectedIndex != index) {
      _selectedIndex = index;
      // Thông báo cho tất cả các listener để cập nhật UI
      notifyListeners();
    }
  }
}