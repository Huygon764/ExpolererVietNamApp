# Tổng Quan Dự Án
Ứng dụng Flutter này giới thiệu các điểm đến du lịch tại Việt Nam, cung cấp cho người dùng thông tin về các địa điểm, điểm tham quan. Dự án được phát triển như một bài tập học tập nhằm thực hành phát triển Flutter, tích hợp Firebase và kiến trúc ứng dụng di động.

# Công Nghệ Sử Dụng:
Flutter để phát triển ứng dụng đa nền tảng
Firebase (Authentication, Firestore, Storage) làm backend
Mô hình Provider cho quản lý trạng thái
Material Design cho giao diện người dùng

# Cấu Trúc Dự Án
lib/ \
├── data/ \
├── models/        # Các mô hình dữ liệu \
├── pages/         # Các màn hình ứng dụng và thành phần UI \
├── providers/     # Quản lý trạng thái sử dụng Provider \
├── seeds/         # Dữ liệu mẫu cho phát triển và kiểm thử \
├── services/      # Logic nghiệp vụ \
├── widgets/       # Các thành phần UI có thể tái sử dụng \
├── firebase_options.dart  # Cấu hình Firebase \
├── main.dart      # Điểm vào ứng dụng \
└── theme.dart     # Cấu hình chủ đề và kiểu dáng \

# Tính Năng Chi Tiết
Khám Phá Điểm Đến:
- Duyệt các điểm du lịch phổ biến ở Việt Nam
- Hiển thị theo danh mục (Biển, Núi, Di tích lịch sử, v.v.)

Thông Tin Chi Tiết:
- Mô tả đầy đủ về mỗi địa điểm

Trải Nghiệm Cá Nhân:
- Đăng nhập với email hoặc tài khoản Google
- Lưu điểm đến yêu thích vào danh sách cá nhân
- Đánh giá và bình luận về các địa điểm
- Trò chuyện với người khác

# Hướng Dẫn Cài Đặt
1. Clone repository: `git clone https://github.com/Huygon764/ExpolererVietNamApp.git`
2. Cài đặt các gói phụ thuộc: `flutter pub get`
3. Thêm biến môi trường:
   - Tạo 1 file tên .env tại thư mục gốc dự án
   - Copy nội dung của .env.example vào file .env
   - Cập nhật các giá trị biến môi trường theo cấu hình của bạn
4. Chạy dự án: `flutter run`

# Cải tiến trong tương lai
- Chức năng admin
- Hệ thông gợi ý điểm đến thông minh
- Hỗ trợ đa ngôn ngữ
