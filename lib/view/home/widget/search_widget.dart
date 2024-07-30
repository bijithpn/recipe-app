import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/colors.dart';
import '../../../view_models/home_provider.dart';

class SearchWidget extends StatefulWidget {
  final List<String> diets;
  final List<String> dishTypes;
  const SearchWidget({
    super.key,
    required this.diets,
    required this.dishTypes,
  });

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
      showDragHandle: true,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FilterBottomSheet(
          diets: widget.diets,
          dishTypes: widget.dishTypes,
        );
      },
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _dismissKeyboard() {
    _focusNode.unfocus();
  }

  final FocusNode _focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    return Focus(
      autofocus: false,
      focusNode: _focusNode,
      canRequestFocus: false,
      child: SearchAnchor.bar(
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        barBackgroundColor: WidgetStateProperty.all(ColorPalette.white),
        searchController: _searchController,
        barHintText: "Search you ingredients....",
        barLeading: Icon(Icons.search, color: ColorPalette.primary),
        barTrailing: [
          if (homeProvider.homeState == HomeState.search)
            IconButton(
              onPressed: () {
                _dismissKeyboard();
                _searchController.clear();
                homeProvider.clearSearchData();
              },
              icon: Icon(Icons.close, color: ColorPalette.primary),
            ),
          IconButton(
            onPressed: () {
              _dismissKeyboard();
              showFilterBottomSheet(context);
            },
            icon: Icon(Icons.tune, color: ColorPalette.primary),
          ),
        ],
        onSubmitted: (value) {
          _dismissKeyboard();
          Provider.of<HomeProvider>(context, listen: false).searchRecipe(value);
          Navigator.pop(context);
        },
        viewTrailing: [
          IconButton(
            onPressed: () {
              _dismissKeyboard();
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
      ),
    );
  }
}

class FilterBottomSheet extends StatefulWidget {
  final List<String> diets;
  final List<String> dishTypes;
  const FilterBottomSheet({
    super.key,
    required this.diets,
    required this.dishTypes,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 600, minHeight: 500),
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
                    items: widget.dishTypes,
                    selectedItems: homeProvider.selectedDishTypes,
                    onChanged: (value) {
                      setState(() {
                        if (homeProvider.selectedDishTypes.contains(value)) {
                          homeProvider.selectedDishTypes.remove(value);
                        } else {
                          homeProvider.selectedDishTypes.add(value);
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildFilterSection(
                    context,
                    title: 'Diets',
                    items: widget.diets,
                    selectedItems: homeProvider.selectedDiets,
                    onChanged: (value) {
                      setState(() {
                        if (homeProvider.selectedDiets.contains(value)) {
                          homeProvider.selectedDiets.remove(value);
                        } else {
                          homeProvider.selectedDiets.add(value);
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
                    homeProvider.clearFilterData();
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Reset',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorPalette.primary,
                  ),
                  onPressed: () {
                    homeProvider.filterRecipes(homeProvider.selectedDishTypes,
                        homeProvider.selectedDiets);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Apply Filters',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection(
    BuildContext context, {
    required String title,
    required List<String> items,
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
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          children: items.map((item) {
            final isSelected = selectedItems.contains(item);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
              child: InkWell(
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                onTap: () => onChanged(item),
                child: Chip(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100)),
                    color: isSelected
                        ? WidgetStateProperty.all(ColorPalette.primary)
                        : null,
                    elevation: isSelected ? 3 : 0,
                    label: Text(
                      item,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color:
                              isSelected ? Colors.white : ColorPalette.primary),
                    )),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
