import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/core.dart';
import '../../../view_models/view_models.dart';

class DetailsErrorWidget extends StatelessWidget {
  const DetailsErrorWidget({
    super.key,
    required this.recipeId,
  });

  final String recipeId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
                style:
                    IconButton.styleFrom(backgroundColor: ColorPalette.primary),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: Column(
              children: [
                Image.asset(AssetsImages.noInternet),
                Text(
                  "Unable to load details. Please check your internet connection or try again later.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold, letterSpacing: .6),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ColorPalette.primary),
                    onPressed: () {
                      // Provider.of<DetailsProvider>(context, listen: false)
                      //     .getDetails(recipeId);
                    },
                    child: Text(
                      "Try again",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
