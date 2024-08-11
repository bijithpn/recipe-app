import 'package:flutter/material.dart';

import '../../core/core.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black,
                    Colors.black.withOpacity(0.5),
                    Colors.transparent,
                  ],
                ),
                image: const DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(AssetsImages.boardingimg))),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              height: 300,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text.rich(
                    TextSpan(text: "Welcome to ", children: [
                      TextSpan(
                        text: AppStrings.appName,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: ColorPalette.primary,
                              letterSpacing: .6,
                              fontSize: 27,
                            ),
                      ),
                      const TextSpan(text: " \ngood things awaits")
                    ]),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        letterSpacing: .6,
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                      icon: Container(
                        margin: const EdgeInsets.all(4),
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 18,
                          color: ColorPalette.primary,
                        ),
                      ),
                      iconAlignment: IconAlignment.end,
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors.black,
                          minimumSize: const Size(double.infinity, 50),
                          maximumSize: const Size(double.infinity, 50)),
                      onPressed: () {},
                      label: Expanded(
                        child: Text(
                          "            Get Started ",
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      )),
                  OutlinedButton(
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          side:
                              BorderSide(color: ColorPalette.primary, width: 2),
                          minimumSize: const Size(double.infinity, 50),
                          maximumSize: const Size(double.infinity, 50)),
                      onPressed: () {},
                      child: Text(
                        "Sign UP",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: ColorPalette.primary),
                      ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
