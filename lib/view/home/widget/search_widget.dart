import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/core/constants/colors.dart';
import 'package:recipe_app/view_models/home_provider.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final List<String> _ingredients = [
    // Vegetables
    'Carrot', 'Tomato', 'Broccoli', 'Spinach', 'Potato', 'Cucumber', 'Lettuce',
    'Pepper', 'Onion', 'Garlic', 'Cabbage', 'Pumpkin', 'Zucchini', 'Kale',
    'Avocado', 'Eggplant', 'Radish', 'Beetroot',

    // Fruits
    'Apple', 'Banana', 'Orange', 'Strawberry', 'Grapes', 'Peach', 'Pear',
    'Mango', 'Lemon', 'Pineapple', 'Watermelon', 'Cherries',

    // Cooking Ingredients
    'Salt', 'Pepper', 'Olive Oil', 'Butter', 'Sugar', 'Flour', 'Eggs', 'Milk',
    'Baking Powder', 'Yeast', 'Vinegar', 'Soy Sauce', 'Honey', 'Garlic Powder',
    'Cumin', 'Paprika', 'Oregano', 'Basil', 'Thyme', 'Rosemary',

    // Meats
    'Chicken Breast', 'Beef', 'Pork', 'Lamb', 'Turkey', 'Duck', 'Bacon',
    'Sausage', 'Ham', 'Salmon', 'Tuna', 'Shrimp',

    // Other Items
    'Rice', 'Pasta', 'Bread', 'Cheese', 'Yogurt', 'Cream', 'Chocolate',
    'Coffee', 'Tea', 'Nuts', 'Seeds', 'Tofu', 'Beans', 'Lentils', 'Quinoa'
  ];
  final SearchController _searchController = SearchController();
  final List<String> _selectedIngredients = [];
  void showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: false,
      builder: (BuildContext context) {
        return FilterBottomSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    return SearchAnchor.bar(
      barBackgroundColor: WidgetStateProperty.all(ColorPalette.white),
      searchController: _searchController,
      barHintText: "Search you recipe....",
      barLeading: Icon(Icons.search, color: ColorPalette.primary),
      barTrailing: [
        if (homeProvider.isSearch)
          IconButton(
            onPressed: () {
              _searchController.clear();
              homeProvider.isSearch = false;
              homeProvider.filteredRecipeList.clear();
              setState(() {});
            },
            icon: Icon(Icons.close, color: ColorPalette.primary),
          ),
        IconButton(
          onPressed: () {
            showFilterBottomSheet(context);
          },
          icon: Icon(Icons.tune, color: ColorPalette.primary),
        ),
      ],
      onSubmitted: (value) {
        FocusManager.instance.primaryFocus?.unfocus();
        Provider.of<HomeProvider>(context, listen: false).searchRecipe(value);
        Navigator.pop(context);
      },
      viewTrailing: [
        IconButton(
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            Provider.of<HomeProvider>(context, listen: false)
                .searchRecipe(_searchController.text);
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.search,
            color: ColorPalette.primary,
          ),
        )
      ],
      suggestionsBuilder:
          (BuildContext context, SearchController searchController) {
        final query = searchController.value.text;
        if (query.isEmpty) {
          return const Iterable<Widget>.empty();
        }
        final currentText = query.split(',').last.trim().toLowerCase();
        final suggestions = _ingredients.where(
            (ingredient) => ingredient.toLowerCase().startsWith(currentText));
        return suggestions.map((suggestion) => ListTile(
              title: Text(
                suggestion,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onTap: () {
                setState(() {
                  List<String> currentTextList = _searchController.text
                      .split(',')
                      .map((e) => e.trim())
                      .where((e) => e.isNotEmpty)
                      .toList();
                  if (currentTextList.isNotEmpty &&
                      currentTextList.last
                          .toLowerCase()
                          .startsWith(currentText)) {
                    currentTextList.removeLast();
                  }
                  currentTextList.add(suggestion);
                  _searchController.text = '${currentTextList.join(', ')}, ';
                  _searchController.selection = TextSelection.fromPosition(
                    TextPosition(offset: _searchController.text.length),
                  );
                  if (!_selectedIngredients.contains(suggestion)) {
                    _selectedIngredients.add(suggestion);
                  }
                });
              },
            ));
      },
    );
  }
}

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  List<String> selectedDishTypes = [];
  List<String> selectedDiets = [];

  final List<Map<String, dynamic>> dishTypes = [
    {"name": "Lunch", "icon": Icons.lunch_dining},
    {"name": "Main Course", "icon": Icons.food_bank},
    {"name": "Main Dish", "icon": Icons.restaurant_menu},
    {"name": "Dinner", "icon": Icons.dinner_dining},
  ];

  final List<Map<String, dynamic>> diets = [
    {"name": "Dairy Free", "icon": Icons.no_food},
    {"name": "Gluten Free", "icon": Icons.free_breakfast},
    {"name": "Vegetarian", "icon": Icons.egg},
    {"name": "Vegan", "icon": Icons.nature_people},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Text(
              'Sort & Filter',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                _buildFilterSection(
                  context,
                  title: 'Dish Types',
                  items: dishTypes,
                  selectedItems: selectedDishTypes,
                  onChanged: (value) {
                    setState(() {
                      if (selectedDishTypes.contains(value)) {
                        selectedDishTypes.remove(value);
                      } else {
                        selectedDishTypes.add(value);
                      }
                    });
                  },
                ),
                const SizedBox(height: 16),
                _buildFilterSection(
                  context,
                  title: 'Diets',
                  items: diets,
                  selectedItems: selectedDiets,
                  onChanged: (value) {
                    setState(() {
                      if (selectedDiets.contains(value)) {
                        selectedDiets.remove(value);
                      } else {
                        selectedDiets.add(value);
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorPalette.primary,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Apply Filters',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorPalette.primary,
                ),
                onPressed: () {
                  setState(() {
                    selectedDishTypes.clear();
                    selectedDiets.clear();
                  });
                },
                child: Text(
                  'Reset',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(
    BuildContext context, {
    required String title,
    required List<Map<String, dynamic>> items,
    required List<String> selectedItems,
    required void Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Column(
          children: items.map((item) {
            final isSelected = selectedItems.contains(item['name']);
            return ListTile(
              leading: Icon(item['icon'],
                  color:
                      isSelected ? ColorPalette.primary : Colors.grey.shade600),
              title: Text(item['name']),
              trailing: isSelected
                  ? Icon(Icons.check_circle, color: ColorPalette.primary)
                  : null,
              onTap: () => onChanged(item['name']),
              tileColor: null,
            );
          }).toList(),
        ),
      ],
    );
  }
}
