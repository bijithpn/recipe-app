import 'package:flutter/material.dart';

import '../../../core/core.dart';
import '../../../data/data.dart';
import '../../../widgets/widgets.dart';

class InstructionViewer extends StatelessWidget {
  final AnalyzedInstruction instruction;

  const InstructionViewer({super.key, required this.instruction});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      itemCount: instruction.steps.length,
      itemBuilder: (context, index) {
        final step = instruction.steps[index];
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                      text: 'Step ${step.number}: ',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: step.step,
                          style: Theme.of(context).textTheme.bodyLarge!,
                        )
                      ]),
                ),
                const SizedBox(height: 10),
                if (step.ingredients.isNotEmpty) ...[
                  Text('Ingredients:',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: ColorPalette.primary)),
                  const SizedBox(height: 5),
                  Column(
                    children: step.ingredients
                        .map((ingredient) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: ListTile(
                                leading: ImageWidget(
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white),
                                  imageUrl:
                                      'https://spoonacular.com/cdn/ingredients_100x100/${ingredient.image}',
                                  width: 60,
                                  height: 60,
                                  errorWidget: Container(
                                      width: 60,
                                      height: 60,
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white),
                                      child: Image.asset(
                                          AssetsImages.ingredients)),
                                ),
                                title: Text(
                                  ingredient.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 10),
                ],
                if (step.equipment.isNotEmpty) ...[
                  Text('Equipment:',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: ColorPalette.primary)),
                  const SizedBox(height: 5),
                  Column(
                    children: step.equipment
                        .map((equipment) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: ListTile(
                                leading: ImageWidget(
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white),
                                  imageUrl: equipment.image,
                                  width: 60,
                                  height: 60,
                                  errorWidget: Container(
                                    width: 60,
                                    height: 60,
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white),
                                    child: Image.asset(
                                      AssetsImages.cookingTool,
                                      width: 50,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  equipment.localizedName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 10),
                ],
                if (step.length != null)
                  Row(
                    children: [
                      Icon(Icons.timer_outlined, color: ColorPalette.primary),
                      const SizedBox(width: 8),
                      Text(
                          'Cooking Time: ${step.length?.number} ${step.length?.unit}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: Colors.black54)),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
