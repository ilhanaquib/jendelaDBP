class CategoryModel {
  final String name;
  bool isSelected;

  CategoryModel({
    required this.name,
    this.isSelected = false,
  });

  // Copy constructor
  CategoryModel copyWith({
    String? name,
    bool? isSelected,
  }) {
    return CategoryModel(
      name: name ?? this.name,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

class CategoryRepository {
  List<CategoryModel> categories = [
    CategoryModel(name: 'All', isSelected: true),
    CategoryModel(name: 'Cerpen'),
    CategoryModel(name: 'Novel'),
    CategoryModel(name: 'Islam'),
    CategoryModel(name: 'Kartun'),
  ];
}
