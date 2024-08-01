import 'dart:async';

import 'package:flutter/material.dart';

const Duration fakeAPIDuration = Duration(seconds: 1);
const Duration debounceDuration = Duration(milliseconds: 500);

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
          bottom: const PreferredSize(
              preferredSize: Size.fromHeight(50), child: _AsyncSearchAnchor()),
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

class _AsyncSearchAnchor extends StatefulWidget {
  const _AsyncSearchAnchor();

  @override
  State<_AsyncSearchAnchor> createState() => _AsyncSearchAnchorState();
}

class _AsyncSearchAnchorState extends State<_AsyncSearchAnchor> {
  // The query currently being searched for. If null, there is no pending
  // request.
  String? _currentQuery;

  // The most recent suggestions received from the API.
  late Iterable<Widget> _lastOptions = <Widget>[];

  late final _Debounceable<Iterable<String>?, String> _debouncedSearch;

  // Calls the "remote" API to search with the given query. Returns null when
  // the call has been made obsolete.
  Future<Iterable<String>?> _search(String query) async {
    _currentQuery = query;

    // In a real application, there should be some error handling here.
    final Iterable<String> options = await _FakeAPI.search(_currentQuery!);

    // If another search happened after this one, throw away these options.
    if (_currentQuery != query) {
      return null;
    }
    _currentQuery = null;

    return options;
  }

  @override
  void initState() {
    super.initState();
    _debouncedSearch = _debounce<Iterable<String>?, String>(_search);
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor.bar(
      suggestionsBuilder:
          (BuildContext context, SearchController controller) async {
        final List<String>? options =
            (await _debouncedSearch(controller.text))?.toList();
        if (options == null) {
          return _lastOptions;
        }
        _lastOptions = List<ListTile>.generate(options.length, (int index) {
          final String item = options[index];
          return ListTile(
            title: Text(item),
            onTap: () {
              debugPrint('You just selected $item');
            },
          );
        });

        return _lastOptions;
      },
    );
  }
}

// Mimics a remote API.
class _FakeAPI {
  static const List<String> _kOptions = <String>[
    'aardvark',
    'bobcat',
    'chameleon',
  ];

  // Searches the options, but injects a fake "network" delay.
  static Future<Iterable<String>> search(String query) async {
    await Future<void>.delayed(fakeAPIDuration); // Fake 1 second delay.
    if (query == '') {
      return const Iterable<String>.empty();
    }
    return _kOptions.where((String option) {
      return option.contains(query.toLowerCase());
    });
  }
}

typedef _Debounceable<S, T> = Future<S?> Function(T parameter);

/// Returns a new function that is a debounced version of the given function.
///
/// This means that the original function will be called only after no calls
/// have been made for the given Duration.
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

// A wrapper around Timer used for debouncing.
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

// An exception indicating that the timer was canceled.
class _CancelException implements Exception {
  const _CancelException();
}
