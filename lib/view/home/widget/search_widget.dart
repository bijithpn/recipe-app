import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final List<String> _ingredients = [
    "apple",
    "banana",
    "carrot",
    "dates",
    "eggplant",
    "fig",
    "grape",
    "honey",
    "iceberg lettuce",
    "jalapeno",
    "kale",
    "lemon",
    "mango",
    "nectarine",
    "orange",
    "papaya",
    "quinoa",
    "radish",
    "spinach",
    "tomato",
    "ugli fruit",
    "vanilla",
    "watermelon",
    "xigua",
    "yam",
    "zucchini"
  ];
  final SearchController _searchController = SearchController();
  final List<String> _selectedIngredients = [];
  @override
  Widget build(BuildContext context) {
    return SearchAnchor.bar(
      searchController: _searchController,
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
              title: Text(suggestion),
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
