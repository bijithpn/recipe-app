import 'package:flutter/material.dart';

import '../../../data/data.dart';
import '../../../widgets/widgets.dart';

class IncredientsViewer extends StatelessWidget {
  final List<Ingredient> ingredients;
  const IncredientsViewer({
    super.key,
    required this.ingredients,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: ingredients.length,
      itemBuilder: (_, i) {
        var ingredient = ingredients[i];
        return ListTile(
          leading: ImageWidget(
            width: 60,
            height: 60,
            padding: const EdgeInsets.all(10),
            color: Colors.white,
            imagePlaceholder: (_, image) {
              return Container(
                width: 60,
                height: 60,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade600, width: .5),
                    borderRadius: BorderRadius.circular(10)),
                child: Image(
                  image: image,
                  width: double.infinity,
                ),
              );
            },
            imageUrl:
                'https://img.spoonacular.com/ingredients_100x100/${ingredient.image}',
            fit: BoxFit.cover,
          ),
          title: Text(
            ingredient.name,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            ingredient.original,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Colors.grey.shade800),
          ),
        );
      },
    );
  }
}
