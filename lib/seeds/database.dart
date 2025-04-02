import 'package:app_tourist_destination/seeds/categories.dart';
import 'package:app_tourist_destination/seeds/destination.dart';

class DatabaseSeeder {
  static Future<void> runAllSeeds() async {
    await seedCategories();
    await seedDestinations();
  }
}