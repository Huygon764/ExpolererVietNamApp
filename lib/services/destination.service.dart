import 'package:app_tourist_destination/models/destination.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DestinationService {
  final CollectionReference destinationsCollection = FirebaseFirestore.instance
      .collection('destinations');

  // Lấy tất cả địa danh
  Stream<List<DestinationModel>> getDestinations() {
    return destinationsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return DestinationModel.fromFirestore(
          doc.data() as Map<String, dynamic>,
        );
      }).toList();
    });
  }

  Stream<List<DestinationModel>> getPopularDestinations() {
    return destinationsCollection
        .orderBy('rating', descending: true)
        .limit(5)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return DestinationModel.fromFirestore(
              doc.data() as Map<String, dynamic>,
            );
          }).toList();
        });
  }

  // Lấy địa danh theo category
  Stream<List<DestinationModel>> getDestinationsByCategory(String categoryId) {
    final categoryRef = FirebaseFirestore.instance
        .collection('categories')
        .doc(categoryId);

    return destinationsCollection
        .where('categories', isEqualTo: categoryRef)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return DestinationModel.fromFirestore(
              doc.data() as Map<String, dynamic>,
            );
          }).toList();
        });
  }

  // Lấy chi tiết một địa danh
  Future<DestinationModel> getDestination(String destinationId) async {
    DocumentSnapshot doc =
        await destinationsCollection.doc(destinationId).get();
    return DestinationModel.fromFirestore(doc.data() as Map<String, dynamic>);
  }

  // for admin
  // Thêm địa danh mới
  // Future<void> addDestination(DestinationModel destination) {
  //   return destinationsCollection.doc(destination.id).set(destination.toFirestore());
  // }

  // // Cập nhật địa danh
  // Future<void> updateDestination(DestinationModel destination) {
  //   return destinationsCollection.doc(destination.id).update(destination.toFirestore());
  // }

  // Xóa địa danh
  // Future<void> deleteDestination(String destinationId) {
  //   return destinationsCollection.doc(destinationId).delete();
  // }
}
