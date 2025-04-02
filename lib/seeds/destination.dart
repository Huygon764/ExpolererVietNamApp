import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> seedDestinations() async {
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance
          .collection('destinations')
          .limit(1)
          .get();
  if (querySnapshot.docs.isEmpty) {
    print("Bắt đầu seeding destinations!");
    await importDestinations();
  } else {
    print("Destinations đã tồn tại, bỏ qua quá trình seed data");
  }
}

Future<void> importDestinations() async {
  // Đầu tiên tạo batch để thực hiện nhiều ghi cùng lúc
  WriteBatch batch = FirebaseFirestore.instance.batch();

  // Dữ liệu destinations
  final List<Map<String, dynamic>> destinations = [
    {
      'name': 'Vịnh Hạ Long',
      'short_description':
          'Di sản thiên nhiên thế giới với hàng nghìn hòn đảo đá vôi',
      'description':
          'Vịnh Hạ Long là một trong những di sản thiên nhiên thế giới được UNESCO công nhận. Nơi đây có hàng nghìn hòn đảo đá vôi hùng vĩ, tạo nên khung cảnh tuyệt đẹp giữa làn nước xanh ngọc.',
      'location': 'Quảng Ninh',
      'image': 'vinhhalong.jpg',
      'preview_images': [
        'vinhhalong1.jpg',
        'vinhhalong2.jpg',
        'vinhhalong3.jpg',
        'vinhhalong4.jpg',
      ],
      'rating': 5.0,
      'total_reviews': 0,
      'category_id': 'vinh',
    },
    {
      'name': 'Phố Cổ Hội An',
      'short_description':
          'Đô thị cổ với kiến trúc độc đáo pha trộn nhiều nền văn hóa',
      'description':
          'Phố cổ Hội An là một đô thị cổ nằm ở hạ lưu sông Thu Bồn, tỉnh Quảng Nam. Đây là một điểm du lịch cực kỳ nổi tiếng với những ngôi nhà cổ hàng trăm năm tuổi, những con phố đèn lồng đầy màu sắc và không khí cổ kính yên bình.',
      'location': 'Quảng Nam',
      'image': 'hoian.jpg',
      'preview_images': ['hoian1.jpg', 'hoian2.jpg', 'hoian3.jpg', 'hoian4.jpg'],
      'rating': 4.9,
      'total_reviews': 0,
      'category_id': 'di_tich_lich_su',
    },
    {
      'name': 'Vịnh Lan Hạ',
      'short_description':
          'Vịnh đẹp hoang sơ với hàng trăm đảo đá và bãi biển cát trắng',
      'description':
          'Vịnh Lan Hạ nằm ở phía Đông đảo Cát Bà, là một vịnh đẹp hoang sơ với hơn 400 hòn đảo lớn nhỏ. Nơi đây có những bãi cát trắng mịn, nước biển xanh trong và hệ sinh thái biển phong phú.',
      'location': 'Hải Phòng',
      'image': 'vinhlanha.jpg',
      'preview_images': [
        'vinhlanha1.jpg',
        'vinhlanha2.jpg',
        'vinhlanha3.jpg',
        'vinhlanha4.jpg',
      ],
      'rating': 4.8,
      'total_reviews': 0,
      'category_id': 'vinh',
    },
    {
      'name': 'Động Phong Nha',
      'short_description':
          'Hang động với hệ thống sông ngầm và nhũ đá tráng lệ',
      'description':
          'Động Phong Nha là một phần của Vườn Quốc gia Phong Nha - Kẻ Bàng, được UNESCO công nhận là Di sản Thiên nhiên Thế giới. Động có hệ thống sông ngầm dài nhất và đẹp nhất với những nhũ đá, măng đá tuyệt đẹp.',
      'location': 'Quảng Bình',
      'image': 'dongphongnha.jpg',
      'preview_images': [
        'dongphongnha1.jpg',
        'dongphongnha2.jpg',
        'dongphongnha3.jpg',
        'dongphongnha4.jpg',
      ],
      'rating': 4.8,
      'total_reviews': 0,
      'category_id': 'hang_dong',
    },
    {
      'name': 'Ruộng Bậc Thang Mù Cang Chải',
      'short_description':
          'Kiệt tác ruộng bậc thang tuyệt đẹp trên sườn núi của người H\'Mông',
      'description':
          'Ruộng bậc thang Mù Cang Chải là công trình nông nghiệp độc đáo của người H\'Mông, tạo nên bức tranh thiên nhiên tuyệt đẹp trên sườn núi. Vào mùa lúa chín, cả vùng núi được phủ một màu vàng rực rỡ.',
      'location': 'Yên Bái',
      'image': 'mucangchai.jpg',
      'preview_images': [
        'mucangchai1.jpg',
        'mucangchai2.jpg',
        'mucangchai3.jpg',
        'mucangchai4.jpg',
      ],
      'rating': 4.7,
      'total_reviews': 0,
      'category_id': 'nui',
    },
    {
      'name': 'Phú Quốc',
      'short_description':
          'Đảo Ngọc với bãi biển đẹp, rừng nguyên sinh và ẩm thực đặc sắc',
      'description':
          'Phú Quốc là hòn đảo lớn nhất Việt Nam, được mệnh danh là đảo Ngọc. Nơi đây nổi tiếng với bãi biển cát trắng, nước biển trong xanh, rừng nguyên sinh và các đặc sản nổi tiếng như nước mắm và hồ tiêu.',
      'location': 'Kiên Giang',
      'image': 'phuquoc.jpg',
      'preview_images': [
        'phuquoc1.jpg',
        'phuquoc2.jpg',
        'phuquoc3.jpg',
        'phuquoc4.jpg',
      ],
      'rating': 4.7,
      'total_reviews': 0,
      'category_id': 'dao',
    },
    {
      'name': 'Sapa',
      'short_description':
          'Thị trấn sương mù với núi Fansipan và văn hóa dân tộc đặc sắc',
      'description':
          'Sapa là thị trấn nghỉ mát trên núi thuộc tỉnh Lào Cai, nổi tiếng với cảnh quan ruộng bậc thang tuyệt đẹp, núi Fansipan \'Nóc nhà Đông Dương\' và văn hóa đa dạng của các dân tộc vùng cao.',
      'location': 'Lào Cai',
      'image': 'sapa.jpg',
      'preview_images': ['sapa1.jpg', 'sapa2.jpg', 'sapa3.jpg', 'sapa4.jpg'],
      'rating': 4.6,
      'total_reviews': 0,
      'category_id': 'nui',
    },
    {
      'name': 'Chùa Thiên Mụ',
      'short_description':
          'Ngôi chùa cổ linh thiêng với tháp Phước Duyên 7 tầng nổi tiếng',
      'description':
          'Chùa Thiên Mụ còn gọi là chùa Linh Mụ, là ngôi chùa cổ nằm trên đồi Hà Khê, bên bờ sông Hương. Ngôi chùa được xây dựng từ năm 1601, là biểu tượng của xứ Huế với tháp Phước Duyên 7 tầng nổi tiếng.',
      'location': 'Thừa Thiên Huế',
      'image': 'chuathienmu.jpg',
      'preview_images': [
        'chuathienmu1.jpg',
        'chuathienmu2.jpg',
        'chuathienmu3.jpg',
        'chuathienmu4.jpg',
      ],
      'rating': 4.5,
      'total_reviews': 0,
      'category_id': 'den_chua',
    },
    {
      'name': 'Thác Bản Giốc',
      'short_description':
          'Thác nước hùng vĩ nhất Đông Nam Á với dòng nước trắng xóa',
      'description':
          'Thác Bản Giốc là thác nước tự nhiên lớn nhất Đông Nam Á, nằm trên biên giới Việt - Trung. Thác có dòng nước trắng xóa đổ xuống từ độ cao 30m, tạo nên cảnh quan hùng vĩ giữa núi rừng Cao Bằng.',
      'location': 'Cao Bằng',
      'image': 'thacbangioc.jpg',
      'preview_images': [
        'thacbangioc1.jpg',
        'thacbangioc2.jpg',
        'thacbangioc3.jpg',
        'thacbangioc4.jpg',
      ],
      'rating': 4.7,
      'total_reviews': 0,
      'category_id': 'thac_nuoc',
    },
    {
      'name': 'Hồ Hoàn Kiếm',
      'short_description':
          'Trái tim của Hà Nội với đền Ngọc Sơn và câu chuyện trả gươm thần',
      'description':
          'Hồ Hoàn Kiếm nằm giữa trung tâm Hà Nội, gắn liền với truyền thuyết vua Lê Thái Tổ trả gươm thần cho Rùa Vàng. Quanh hồ có đền Ngọc Sơn, tháp Rùa, cầu Thê Húc đỏ tạo nên biểu tượng văn hóa lịch sử của Thủ đô.',
      'location': 'Hà Nội',
      'image': 'hoankiem.jpg',
      'preview_images': [
        'hoankiem1.jpg',
        'hoankiem2.jpg',
        'hoankiem3.jpg',
        'hoankiem4.jpg',
      ],
      'rating': 4.6,
      'total_reviews': 0,
      'category_id': 'song_ho',
    },
    {
      'name': 'Khu Di Tích Cố Đô Huế',
      'short_description':
          'Di sản văn hóa thế giới với hệ thống kinh thành và lăng tẩm hoàng gia',
      'description':
          'Quần thể di tích Cố đô Huế bao gồm Kinh thành Huế, các lăng tẩm vua chúa nhà Nguyễn và các công trình kiến trúc liên quan. Đây là di sản văn hóa thế giới được UNESCO công nhận năm 1993.',
      'location': 'Thừa Thiên Huế',
      'image': 'codohue.jpg',
      'preview_images': [
        'codohue1.jpg',
        'codohue2.jpg',
        'codohue3.jpg',
        'codohue4.jpg',
      ],
      'rating': 4.8,
      'total_reviews': 0,
      'category_id': 'di_tich_lich_su',
    },
    {
      'name': 'Vườn Quốc Gia Cúc Phương',
      'short_description':
          'Khu bảo tồn thiên nhiên với rừng nguyên sinh và hang động tiền sử',
      'description':
          'Vườn Quốc gia Cúc Phương là khu bảo tồn thiên nhiên đầu tiên của Việt Nam, nổi tiếng với rừng nguyên sinh hàng nghìn năm tuổi, hệ động thực vật phong phú và hang động cổ Người Xưa với dấu tích văn hóa tiền sử.',
      'location': 'Ninh Bình',
      'image': 'cucphuong.jpg',
      'preview_images': [
        'cucphuong1.jpg',
        'cucphuong2.jpg',
        'cucphuong3.jpg',
        'cucphuong4.jpg',
      ],
      'rating': 4.5,
      'total_reviews': 0,
      'category_id': 'vuon_quoc_gia',
    },
    {
      'name': 'Bãi Biển Mỹ Khê',
      'short_description':
          'Một trong những bãi biển đẹp nhất hành tinh với cát trắng mịn',
      'description':
          'Bãi biển Mỹ Khê ở Đà Nẵng được tạp chí Forbes bình chọn là một trong những bãi biển quyến rũ nhất hành tinh. Bãi biển dài với cát trắng mịn, nước biển xanh trong, sóng vừa phải, rất thích hợp cho tắm biển và các môn thể thao biển.',
      'location': 'Đà Nẵng',
      'image': 'mykhe.jpg',
      'preview_images': ['mykhe1.jpg', 'mykhe2.jpg', 'mykhe3.jpg', 'mykhe4.jpg'],
      'rating': 4.6,
      'total_reviews': 0,
      'category_id': 'bien',
    },
    {
      'name': 'Bà Nà Hills',
      'short_description':
          'Thiên đường giải trí trên mây với cầu Vàng nổi tiếng thế giới',
      'description':
          'Bà Nà Hills là khu du lịch nổi tiếng với cầu Vàng độc đáo, hệ thống cáp treo đạt nhiều kỷ lục thế giới và kiến trúc theo phong cách Pháp. Từ đỉnh núi Chúa ở độ cao 1.487m, du khách có thể ngắm nhìn toàn cảnh Đà Nẵng.',
      'location': 'Đà Nẵng',
      'image': 'banahills.jpg',
      'preview_images': [
        'banahills1.jpg',
        'banahills2.jpg',
        'banahills3.jpg',
        'banahills4.jpg',
      ],
      'rating': 4.5,
      'total_reviews': 0,
      'category_id': 'nui',
    },
    {
      'name': 'Hang Sơn Đoòng',
      'short_description':
          'Hang động lớn nhất thế giới với hệ sinh thái riêng biệt',
      'description':
          'Hang Sơn Đoòng được phát hiện năm 2009, là hang động lớn nhất thế giới với những thạch nhũ, sông ngầm và cả một khu rừng nguyên sinh bên trong. Khám phá Sơn Đoòng là trải nghiệm độc đáo dành cho những người ưa mạo hiểm.',
      'location': 'Quảng Bình',
      'image': 'hangdoong.jpg',
      'preview_images': [
        'hangdoong1.jpg',
        'hangdoong2.jpg',
        'hangdoong3.jpg',
        'hangdoong4.jpg',
      ],
      'rating': 4.9,
      'total_reviews': 0,
      'category_id': 'hang_dong',
    },
    {
      'name': 'Hồ Ba Bể',
      'short_description':
          'Hồ nước ngọt tự nhiên lớn nhất Việt Nam giữa núi rừng Bắc Kạn',
      'description':
          'Hồ Ba Bể là hồ nước ngọt tự nhiên lớn nhất Việt Nam, nằm trong Vườn quốc gia Ba Bể. Hồ được bao quanh bởi núi đá vôi, thác nước và hang động, tạo nên cảnh quan hữu tình giữa đại ngàn Bắc Kạn.',
      'location': 'Bắc Kạn',
      'image': 'hobabe.jpg',
      'preview_images': [
        'hobabe1.jpg',
        'hobabe2.jpg',
        'hobabe3.jpg',
        'hobabe4.jpg',
      ],
      'rating': 4.6,
      'total_reviews': 0,
      'category_id': 'song_ho',
    },
    {
      'name': 'Thành Nhà Hồ',
      'short_description':
          'Di sản thế giới với kiến trúc đá độc đáo từ thế kỷ XIV',
      'description':
          'Thành Nhà Hồ hay còn gọi là Thành Tây Đô, được xây dựng năm 1397 bằng những khối đá khổng lồ ghép khít với nhau không dùng chất kết dính. Đây là di sản văn hóa thế giới với kỹ thuật xây dựng độc đáo.',
      'location': 'Thanh Hóa',
      'image': 'thanhnhaho.jpg',
      'preview_images': [
        'thanhnhaho1.jpg',
        'thanhnhaho2.jpg',
        'thanhnhaho3.jpg',
        'thanhnhaho4.jpg',
      ],
      'rating': 4.4,
      'total_reviews': 0,
      'category_id': 'di_tich_lich_su',
    },
    {
      'name': 'Làng Cổ Đường Lâm',
      'short_description':
          'Làng cổ với kiến trúc truyền thống nguyên vẹn hàng trăm năm',
      'description':
          'Làng cổ Đường Lâm là một trong những làng cổ nguyên vẹn nhất Việt Nam với những ngôi nhà cổ hàng trăm năm tuổi, cổng làng, đình, chùa mang đậm kiến trúc truyền thống của người Việt cổ.',
      'location': 'Hà Nội',
      'image': 'langduonglam.jpg',
      'preview_images': [
        'langduonglam1.jpg',
        'langduonglam2.jpg',
        'langduonglam3.jpg',
        'langduonglam4.jpg',
      ],
      'rating': 4.5,
      'total_reviews': 0,
      'category_id': 'di_tich_lich_su',
    },
    {
      'name': 'Đảo Lý Sơn',
      'short_description':
          'Hòn đảo núi lửa với biển xanh và những cánh đồng tỏi nổi tiếng',
      'description':
          'Đảo Lý Sơn hay còn gọi là Cù Lao Ré, được hình thành từ núi lửa, tạo nên địa hình độc đáo với biển xanh, cát trắng và những cánh đồng tỏi nổi tiếng. Đảo còn lưu giữ nhiều di tích lịch sử văn hóa của đội Hoàng Sa.',
      'location': 'Quảng Ngãi',
      'image': 'lyson.jpg',
      'preview_images': ['lyson1.jpg', 'lyson2.jpg', 'lyson3.jpg', 'lyson4.jpg'],
      'rating': 4.5,
      'total_reviews': 0,
      'category_id': 'dao',
    },
    {
      'name': 'Thác Dray Nur',
      'short_description':
          'Thác nước hùng vĩ nhất Tây Nguyên với truyền thuyết tình yêu',
      'description':
          'Thác Dray Nur là một trong những thác nước đẹp nhất Tây Nguyên, cao 30m rộng 250m, nằm trên dòng sông Sêrêpốk. Thác còn gắn với truyền thuyết tình yêu của đôi trai gái người Ê Đê, tạo nên vẻ đẹp vừa hùng vĩ vừa thơ mộng.',
      'location': 'Đắk Lắk',
      'image': 'draynur.jpg',
      'preview_images': [
        'draynur1.jpg',
        'draynur2.jpg',
        'draynur3.jpg',
        'draynur4.jpg',
      ],
      'rating': 4.4,
      'total_reviews': 0,
      'category_id': 'thac_nuoc',
    },
    {
      'name': 'Vườn Quốc Gia Tràm Chim',
      'short_description':
          'Khu đất ngập nước với hệ sinh thái đa dạng và loài sếu đầu đỏ quý hiếm',
      'description':
          'Vườn Quốc gia Tràm Chim là khu đất ngập nước tiêu biểu của vùng Đồng Tháp Mười, nơi sinh sống của hơn 230 loài chim, trong đó có sếu đầu đỏ quý hiếm. Khu vực này còn lưu giữ hệ sinh thái đặc trưng của vùng đồng bằng sông Cửu Long.',
      'location': 'Đồng Tháp',
      'image': 'tramchim.jpg',
      'preview_images': [
        'tramchim1.jpg',
        'tramchim2.jpg',
        'tramchim3.jpg',
        'tramchim4.jpg',
      ],
      'rating': 4.3,
      'total_reviews': 0,
      'category_id': 'vuon_quoc_gia',
    },
  ];

  // Tạo DocumentReference cho mỗi destination và thêm vào batch
  for (int i = 0; i < destinations.length; i++) {
    // Tạo ID cho document
    String destId = 'dest_${i + 1}';

    // Tạo reference đến category
    DocumentReference categoryRef = FirebaseFirestore.instance
        .collection('categories')
        .doc(destinations[i]['category_id']);

    // Tạo document cho destination
    DocumentReference destRef = FirebaseFirestore.instance
        .collection('destinations')
        .doc(destId);

    // Tạo dữ liệu với reference hợp lệ và bỏ category_id tạm thời
    Map<String, dynamic> destData = Map.from(destinations[i]);
    destData.remove('category_id');
    destData['id'] = destId; // Thêm id vào data
    destData['categories'] = categoryRef; // Thêm reference đến category

    // Thêm vào batch
    batch.set(destRef, destData);
  }

  // Thực hiện batch
  await batch.commit();
  print('Import destinations thành công!');
}
