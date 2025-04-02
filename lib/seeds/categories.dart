import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> seedCategories() async {
  QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('categories').limit(1).get();
    if (querySnapshot.docs.isEmpty) {
      print("Bat dau seeding categories!");
      await importCategories();
    } else {
      print("Categories đã tồn tại, bỏ qua quá trình seed data");
    }
}

Future<void> importCategories() async {
  final Map<String, Map<String, dynamic>> categories = {
    'bien': {'name': 'Biển', 'id': 'bien'},
    'dao': {'name': 'Đảo', 'id': 'dao'},
    'den_chua': {'name': 'Đền chùa', 'id': 'den_chua'},
    'hang_dong': {'name': 'Hang động', 'id': 'hang_dong'},
    'nui': {'name': 'Núi ', 'id': 'nui'},
    'song_ho': {'name': 'Sông hồ', 'id': 'song_ho'},
    'thac_nuoc': {'name': 'Thác nước', 'id': 'thac_nuoc'},
    'vuon_quoc_gia': {'name': 'Vườn quốc gia', 'id': 'vuon_quoc_gia'},
    'vinh': {'name': 'Vịnh', 'id': 'vinh'},  
    // Thêm các category khác nếu cần
  };

  WriteBatch batch = FirebaseFirestore.instance.batch();

  categories.forEach((key, value) {
    DocumentReference docRef = FirebaseFirestore.instance
        .collection('categories')
        .doc(key);
    batch.set(docRef, value);
  });

  await batch.commit();
  print('Import categories thành công!');
}
