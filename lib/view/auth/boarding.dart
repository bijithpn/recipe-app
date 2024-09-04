import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/core.dart';
import '../../view_models/view_models.dart';

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
              height: 320,
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
                    height: 20,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors.black,
                          minimumSize: const Size(double.infinity, 50),
                          maximumSize: const Size(double.infinity, 50)),
                      onPressed: () {
                        context.go(Routes.login);
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Get Started",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                            ),
                          ),
                          Container(
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
                        ],
                      )),
                  const SizedBox(height: 15),
                  OutlinedButton(
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          side:
                              BorderSide(color: ColorPalette.primary, width: 2),
                          minimumSize: const Size(double.infinity, 50),
                          maximumSize: const Size(double.infinity, 50)),
                      onPressed: () {
                        context.go(Routes.register);
                      },
                      child: Text(
                        "Sign UP",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: ColorPalette.primary),
                      )),
                  const SizedBox(height: 15),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: ColorPalette.primary,
                          minimumSize: const Size(double.infinity, 50),
                          maximumSize: const Size(double.infinity, 50)),
                      onPressed: () async {
                        var status = await Provider.of<AuthProvider>(context,
                                listen: false)
                            .signInAnonymously();
                        if (context.mounted && status) {
                          context.go(Routes.home);
                        }
                      },
                      child: Text(
                        "Guest Login",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                      )),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
