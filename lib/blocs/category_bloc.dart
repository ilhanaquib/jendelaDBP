import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jendela_dbp/model/category_model.dart';

// Step 2: Create CategoryEvent
abstract class CategoryEvent {}

class SelectCategoryEvent extends CategoryEvent {
  final CategoryModel category;

  SelectCategoryEvent(this.category);
}

// Step 3: Create CategoryState
class CategoryState {
  final List<CategoryModel> categories;

  CategoryState(this.categories);

  CategoryState copyWith({List<CategoryModel>? categories}) {
    return CategoryState(categories ?? this.categories);
  }
}

// Step 4: Implement CategoryBloc
class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(CategoryState(CategoryRepository().categories)) {
    // Register the event handler for SelectCategoryEvent
    on<SelectCategoryEvent>((event, emit) {
      List<CategoryModel> updatedCategories = state.categories.map((category) {
        return category.copyWith(isSelected: category == event.category);
      }).toList();

      emit(state.copyWith(categories: updatedCategories));
    });
  }

  Stream<CategoryState> mapEventToState(CategoryEvent event) async* {
    // The mapEventToState method can be left empty since you're handling the event using the `on` method.
  }
}
