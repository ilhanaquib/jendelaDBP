import 'package:get/get.dart';
import 'package:jendela_dbp/model/category_model.dart';

class CategoryController extends GetxController {
  final categories = <CategoryModel>[
    CategoryModel(name: 'All', isSelected: true),
    CategoryModel(name: 'Cerpen'),
    CategoryModel(name: 'Novel'),
    CategoryModel(name: 'Islam'),
    CategoryModel(name: 'Kartun'),
    // Add more books as needed
  ].obs;

  void onCategoryPressed(int index) {
    for (int i = 0; i < categories.length; i++) {
      categories[i].isSelected = i == index;
    }
    update(); // Update the UI after changing the selected category
  }
}
