import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../../../data/models/details.dart';

class CookingTipsScreen extends StatelessWidget {
  final Tips tips;

  const CookingTipsScreen({super.key, required this.tips});

  Widget _buildTipsList(
      String title, List<String> tipsList, IconData icon, Color color,
      {BuildContext? context}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
        ...tipsList.map((tip) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: HtmlWidget(
                      tip,
                      textStyle: Theme.of(context!).textTheme.bodyLarge,
                    ),
                  )),
            )),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          if (tips.health.isNotEmpty)
            _buildTipsList('Health Tips', tips.health, Icons.health_and_safety,
                Colors.green,
                context: context),
          if (tips.price.isNotEmpty)
            _buildTipsList(
                'Budget Tips', tips.price, Icons.attach_money, Colors.blue,
                context: context),
          if (tips.cooking.isNotEmpty)
            _buildTipsList(
                'Cooking Tips', tips.cooking, Icons.kitchen, Colors.orange,
                context: context),
          if (tips.green.isNotEmpty)
            _buildTipsList(
                'Eco-Friendly Tips', tips.green, Icons.eco, Colors.teal,
                context: context),
        ],
      ),
    );
  }
}
