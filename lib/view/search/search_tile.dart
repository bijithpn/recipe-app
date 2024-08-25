import 'package:flutter/material.dart';
import 'package:recipe_app/data/data.dart';

import '../../widgets/widgets.dart';

class SearchTileScreen extends StatefulWidget {
  final String tag;
  const SearchTileScreen({
    super.key,
    required this.tag,
  });

  @override
  State<SearchTileScreen> createState() => _SearchTileScreenState();
}

class _SearchTileScreenState extends State<SearchTileScreen> {
  late Future<List<Recipe>> _futureRecipeList;
  @override
  void initState() {
    _futureRecipeList = RecipeRepository().getRecipes(tags: widget.tag);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.black,
            )),
        title: Text(
          widget.tag,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: CustomScrollView(
          slivers: [
            FutureBuilder(
                future: _futureRecipeList,
                builder: (_, snapshot) {
                  List<Recipe> recipeList = snapshot.data ?? [];
                  if (snapshot.hasData) {
                    return RecipeViewBuilder(recipeList: recipeList);
                  }
                  return const SliverToBoxAdapter(
                      child: Center(child: LottieLoader()));
                }),
          ],
        ),
      ),
    );
  }
}
