import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jendela_dbp/blocs/category_bloc.dart';

class CategoryButtons extends StatelessWidget {
  const CategoryButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryBloc = BlocProvider.of<CategoryBloc>(context);
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(left: 13),
          child: SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.categories.length,
              itemBuilder: (context, index) {
                final category = state.categories[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlinedButton(
                    onPressed: () {
                      // Dispatch the SelectCategoryEvent with the selected category
                      categoryBloc.add(SelectCategoryEvent(category));
                    },
                    style: ButtonStyle(
                      // Set the button's background color based on the isSelected property
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (states) {
                          if (category.isSelected) {
                            return const Color.fromARGB(255, 144, 191,
                                63); // Change this to the desired selected color
                          } else {
                            return Colors
                                .white; // Change this to the desired unselected color
                          }
                        },
                      ),
                      // Set the button's border color when selected
                      side: MaterialStateProperty.resolveWith<BorderSide>(
                        (states) {
                          return BorderSide(
                            color: category.isSelected
                                ? const Color.fromARGB(255, 144, 191,
                                    63) // RGB(144, 191, 63) when selected
                                : Colors
                                    .grey, // Change this to the desired unselected border color
                            width: 1.0,
                          );
                        },
                      ),
                    ),
                    child: Text(
                      category.name,
                      style: TextStyle(
                        // Set the button's text color based on the isSelected property
                        color: category.isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
