import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/core/core.dart';
import 'package:recipe_app/widgets/image_widget.dart';

import '../../view_models/view_models.dart';

const Duration debounceDuration = Duration(milliseconds: 350);

class SearchRecipe extends StatefulWidget {
  const SearchRecipe({super.key});

  @override
  State<SearchRecipe> createState() => _SearchRecipeState();
}

class _SearchRecipeState extends State<SearchRecipe> {
  List<Map<String, String>> searchItems = [
    {'image': 'assets/images/breakfast.png', "title": "Breakfast"},
    {'image': 'assets/images/hamburger.png', "title": "Lunch"},
    {'image': 'assets/images/shallow_pan.png', "title": "Dinner"},
    {'image': 'assets/images/greek_salad.png', "title": "Diet"},
    {'image': 'assets/images/seafood.png', "title": "Seafood"},
    {'image': 'assets/images/cake.png', "title": "Cake"},
    {'image': 'assets/images/cookie.png', "title": "Cookie"},
    {'image': 'assets/images/pastry.png', "title": "Pastry"},
    {'image': 'assets/images/wine.png', "title": "Wine"},
    {'image': 'assets/images/meat.png', "title": "Meat"},
    {'image': 'assets/images/shortcake.png', "title": "Desserts"},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Search",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          bottom: const PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: AsyncSearchAnchor(),
              )),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: GridView.count(
            crossAxisCount: 4,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            childAspectRatio: .8,
            children: List.generate(searchItems.length, (i) {
              var tile = searchItems[i];
              return TextButton(
                style: TextButton.styleFrom(
                    overlayColor: WidgetStateColor.resolveWith(
                        (states) => Colors.transparent),
                    elevation: 4,
                    foregroundColor: Colors.transparent),
                onPressed: () {},
                iconAlignment: IconAlignment.start,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        width: 60,
                        height: 60,
                        padding: const EdgeInsets.all(15),
                        decoration: const BoxDecoration(boxShadow: [
                          BoxShadow(
                              color: Colors.grey,
                              blurRadius: 25.0,
                              offset: Offset(0, 5))
                        ], color: Colors.white, shape: BoxShape.circle),
                        child: Image.asset(tile["image"]!)),
                    const SizedBox(height: 10),
                    Text(
                      tile['title']!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              );
            }),
          ),
        ));
  }
}

class AsyncSearchAnchor extends StatefulWidget {
  const AsyncSearchAnchor({super.key});

  @override
  State<AsyncSearchAnchor> createState() => _AsyncSearchAnchorState();
}

class _AsyncSearchAnchorState extends State<AsyncSearchAnchor> {
  String? _currentQuery;

  late Iterable<Widget> _lastOptions = <Widget>[];

  late final _Debounceable<Iterable<Map<String, dynamic>>?, String>
      _debouncedSearch;
  Future<Iterable<Map<String, dynamic>>?> _search(String query) async {
    _currentQuery = query;
    final Iterable<Map<String, dynamic>> options =
        await Provider.of<SearchProvider>(context, listen: false)
            .getSearchQuery(_currentQuery!);

    if (_currentQuery != query) {
      return null;
    }
    _currentQuery = null;

    return options;
  }

  @override
  void initState() {
    super.initState();
    _debouncedSearch =
        _debounce<Iterable<Map<String, dynamic>>?, String>(_search);
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor.bar(
      barBackgroundColor: WidgetStateProperty.all(Colors.white),
      barOverlayColor: WidgetStateProperty.all(Colors.white),
      suggestionsBuilder:
          (BuildContext context, SearchController controller) async {
        final List<Map<String, dynamic>>? options =
            (await _debouncedSearch(controller.text))?.toList();
        if (options == null) {
          return _lastOptions;
        }
        _lastOptions = List<ListTile>.generate(options.length, (int index) {
          final String item = options[index]['title'];
          final String type = options[index]['imageType'];
          final int id = options[index]['id'];
          return ListTile(
            leading: ImageWidget(
              width: 70,
              height: 70,
              imageUrl: "${ApiConfig.imageUrl}recipes/$id-312x231.$type",
            ),
            title: Text(
              item,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
          );
        });

        return _lastOptions;
      },
    );
  }
}

typedef _Debounceable<S, T> = Future<S?> Function(T parameter);

_Debounceable<S, T> _debounce<S, T>(_Debounceable<S?, T> function) {
  _DebounceTimer? debounceTimer;

  return (T parameter) async {
    if (debounceTimer != null && !debounceTimer!.isCompleted) {
      debounceTimer!.cancel();
    }
    debounceTimer = _DebounceTimer();
    try {
      await debounceTimer!.future;
    } catch (error) {
      if (error is _CancelException) {
        return null;
      }
      rethrow;
    }
    return function(parameter);
  };
}

class _DebounceTimer {
  _DebounceTimer() {
    _timer = Timer(debounceDuration, _onComplete);
  }

  late final Timer _timer;
  final Completer<void> _completer = Completer<void>();

  void _onComplete() {
    _completer.complete();
  }

  Future<void> get future => _completer.future;

  bool get isCompleted => _completer.isCompleted;

  void cancel() {
    _timer.cancel();
    _completer.completeError(const _CancelException());
  }
}

class _CancelException implements Exception {
  const _CancelException();
}
