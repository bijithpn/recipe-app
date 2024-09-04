import 'package:flutter/material.dart';
import 'package:recipe_app/core/constants/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class UserPreference extends StatefulWidget {
  const UserPreference({super.key});

  @override
  State<UserPreference> createState() => _UserPreferenceState();
}

class _UserPreferenceState extends State<UserPreference> {
  List<UserPreferenceData> datas = [
    UserPreferenceData(
      options: [
        "Vegetarian/Vegan",
        "Gluten-Free",
        "Dairy-Free",
        "Pescatarian",
        "Paleo",
        "Ketogenic",
        "Other",
      ],
      question: 'Do you have any dietary restrictions?',
    ),
    UserPreferenceData(
      options: ["Nuts", "Seafood", "Dairy", "Gluten"],
      question: 'Do you have any food allergies or sensitivities?',
    ),
    UserPreferenceData(
      options: [
        "Weight Loss",
        "Weight Gain",
        "Muscle Building",
        "Maintenance",
      ],
      question: 'What are your primary meal goals?',
    ),
    UserPreferenceData(
      options: [
        "Beginner",
        "Intermediate",
        "Advanced",
      ],
      question: 'How comfortable are you in the kitchen?',
    ),
  ];
  PageController controller = PageController(initialPage: 0);
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if (controller.hasClients) {
        setState(() {
          currentPageIndex = controller.page!.round();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: ColorPalette.primary.withOpacity(.5),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Center(
                      child: SmoothPageIndicator(
                        controller: controller,
                        count: datas.length,
                        effect: ExpandingDotsEffect(
                            dotWidth: 45,
                            spacing: 10,
                            dotHeight: 20,
                            dotColor: Colors.white,
                            activeDotColor: ColorPalette.primary),
                        onDotClicked: (index) {
                          controller.animateToPage(index,
                              curve: Curves.easeIn,
                              duration: const Duration(milliseconds: 500));
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 80,
                  padding: const EdgeInsets.only(right: 10),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      final slideAnimation = Tween<Offset>(
                        begin: child.key == const ValueKey<int>(1)
                            ? const Offset(0.0, 0.2)
                            : const Offset(0.0, -0.2),
                        end: Offset.zero,
                      ).animate(animation);
                      return SlideTransition(
                        position: slideAnimation,
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      );
                    },
                    child: currentPageIndex == datas.length - 1
                        ? TextButton(
                            key: const ValueKey<int>(1),
                            onPressed: () {},
                            child: Text(
                              "Next",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                            ),
                          )
                        : IconButton(
                            key: const ValueKey<int>(2),
                            onPressed: () {},
                            icon: const Icon(
                              Icons.close,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          )),
      body: PageView.builder(
        controller: controller,
        itemCount: datas.length,
        itemBuilder: (_, i) {
          var data = datas[i];
          return Scaffold(
              backgroundColor: ColorPalette.primary.withOpacity(.5),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.question,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            letterSpacing: .5,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 20,
                      runSpacing: 10,
                      children: data.options.map((goal) {
                        return ChoiceChip(
                          checkmarkColor: Colors.white,
                          selectedColor: ColorPalette.primary,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: ColorPalette.primary, width: 1.5),
                              borderRadius: BorderRadius.circular(100)),
                          elevation: 2,
                          label: Text(
                            goal,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: data.selectedChips.contains(goal)
                                        ? Colors.white
                                        : null),
                          ),
                          selected: data.selectedChips.contains(goal),
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                data.selectedChips.add(goal);
                              } else {
                                data.selectedChips.remove(goal);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ));
        },
      ),
    );
  }
}

class UserPreferenceData {
  UserPreferenceData({
    required this.question,
    required this.options,
    Set<String>? selectedChips,
  }) : selectedChips = selectedChips ?? <String>{};

  final List<String> options;
  final String question;
  Set<String> selectedChips;
}
