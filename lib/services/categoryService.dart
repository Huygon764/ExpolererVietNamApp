import 'package:app_tourist_destination/models/category.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryService {
  final CollectionReference categoriesCollection = FirebaseFirestore.instance
      .collection('categories');

  // Lấy tất cả địa danh
  Stream<List<CategoryModel>> getCategories() {
    return categoriesCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return CategoryModel.fromFirestore(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}
