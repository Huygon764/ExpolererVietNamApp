import 'package:app_tourist_destination/pages/Dialog/FAQDialog.dart';
import 'package:app_tourist_destination/providers/NavigationProvider.dart';
import 'package:app_tourist_destination/providers/ThemeProvider.dart';
import 'package:app_tourist_destination/services/auth.service.dart';
import 'package:app_tourist_destination/widgets/AvatarWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AuthService _authService = AuthService();

  void _showEditNameDialog(BuildContext context, User? user) {
    if (user == null) return;

    final TextEditingController nameController = TextEditingController(
      text: user.displayName,
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Chỉnh sửa tên'),
            content: TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Tên hiển thị',
                hintText: 'Nhập tên của bạn',
              ),
              autofocus: true,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Hủy'),
              ),
              TextButton(
                onPressed: () async {
                  if (nameController.text.trim().isNotEmpty) {
                    try {
                      // Cập nhật tên người dùng
                      await user.updateDisplayName(nameController.text.trim());

                      // Tải lại dữ liệu người dùng để đảm bảo thay đổi được áp dụng
                      await user.reload();

                      // Đóng dialog
                      Navigator.pop(context);

                      // Hiển thị thông báo thành công
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Đã cập nhật tên thành công!')),
                      );

                      // Cập nhật giao diện
                      setState(() {});
                    } catch (e) {
                      // Hiển thị thông báo lỗi
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Lỗi cập nhật tên: $e')),
                      );
                      Navigator.pop(context);
                    }
                  }
                },
                child: Text('Lưu'),
              ),
            ],
          ),
    );
  }

  Future<void> _updateProfilePicture() async {
    try {
      final user = _authService.currentUser;
      if (user == null) return;

      // Hiển thị dialog để chọn nguồn ảnh
      final ImageSource? source = await showDialog<ImageSource>(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text('Chọn nguồn ảnh'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Icon(Icons.camera_alt),
                    title: Text('Chụp ảnh mới'),
                    onTap: () => Navigator.pop(context, ImageSource.camera),
                  ),
                  ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('Chọn từ thư viện'),
                    onTap: () => Navigator.pop(context, ImageSource.gallery),
                  ),
                ],
              ),
            ),
      );

      if (source == null) return;

      // Lấy ảnh từ nguồn đã chọn
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image == null) return;

      // Hiển thị loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()),
      );

      // Tải lên Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_avatars')
          .child('${user.uid}.jpg');

      final file = File(image.path);
      await storageRef.putFile(file);
      final downloadUrl = await storageRef.getDownloadURL();

      // Cập nhật profile
      await user.updatePhotoURL(downloadUrl);
      await user.reload();

      // Đóng dialog loading
      Navigator.pop(context);

      // Cập nhật UI
      setState(() {});

      // Hiển thị thông báo thành công
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ảnh đại diện đã được cập nhật!')));
    } catch (e) {
      print(e);
      // Đóng dialog loading nếu đang hiển thị
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      // Hiển thị thông báo lỗi
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi cập nhật ảnh: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header
                Text(
                  'Your Profile',
                  // style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyMedium?.color),
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyMedium?.color),
                ),

                SizedBox(height: 20),

                // User Info Section
                Row(
                  children: [
                    buildAvatarProfile(
                      _authService.currentUser,
                      onTapCamera: () => _updateProfilePicture(),
                    ),
                    SizedBox(width: 15),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10,
                      children: [
                        Text(
                          'Hello, ${_authService.currentUser?.displayName ?? _authService.currentUser?.email}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _showEditNameDialog(
                              context,
                              _authService.currentUser,
                            );
                          },
                          child: Icon(Icons.edit),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 30),

                // SizedBox(height: 12),
                SettingsOption(
                  title: 'FAQ',
                  icon: Icons.chat_bubble_outline,
                  onTap: () {
                    showFAQModal(context);
                  },
                ),

                SizedBox(height: 12),

                // Dark Mode Toggle
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    // Sử dụng màu từ Theme để tương thích với Dark Mode
                    color:
                        Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Dark Mode',
                        style: TextStyle(
                          fontSize: 16,
                          // Sử dụng màu từ Theme
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                      Consumer<ThemeProvider>(
                        builder: (context, themeProvider, child) {
                          return CupertinoSwitch(
                            // Lấy giá trị từ ThemeProvider
                            value: themeProvider.isDarkMode,
                            // Gọi toggleTheme của ThemeProvider
                            onChanged: (value) {
                              themeProvider.toggleTheme();
                            },
                            // Màu active phù hợp với theme
                            activeColor: Colors.blue,
                          );
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 12),

                // Logout Button
                GestureDetector(
                  onTap: () {
                    _authService.signOut();
                    Provider.of<NavigationProvider>(
                      context,
                      listen: false,
                    ).setIndex(0);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Settings option item widget
class SettingsOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const SettingsOption({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(fontSize: 16)),
            Icon(icon, size: 22, color: Colors.grey[700]),
          ],
        ),
      ),
    );
  }
}
