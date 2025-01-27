import 'package:flutter/material.dart';

class CategoryFilter extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategoryFilter({
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (ctx, index) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: FilterChip(
            label: Text(categories[index]),
            selected: selectedCategory == categories[index],
            onSelected: (selected) {
              onCategorySelected(categories[index]);
            },
          ),
        ),
      ),
    );
  }
}