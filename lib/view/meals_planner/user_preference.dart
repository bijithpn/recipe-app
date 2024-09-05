import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_app/core/constants/colors.dart';
import 'package:recipe_app/core/constants/strings.dart';
import 'package:recipe_app/core/core.dart';
import 'package:recipe_app/data/repositories/user_respository.dart';
import 'package:recipe_app/utils/utils.dart';

class UserPreference extends StatefulWidget {
  const UserPreference({super.key});

  @override
  State<UserPreference> createState() => _UserPreferenceState();
}

class _UserPreferenceState extends State<UserPreference> {
  PageController controller = PageController(initialPage: 0);
  int currentPageIndex = 0;
  List<UserPreferenceData> questionData = [
    UserPreferenceData(
      options: [
        'Gluten-free',
        'Dairy-free',
        'Vegan',
        'Vegetarian',
        'Pescatarian',
        'Ketogenic',
        'Paleo',
        'Non-vegetarian',
        "Other (Specify)"
      ],
      type: UserPreferenceType.multiple,
      question: 'Do you have any dietary preferences or restrictions?',
    ),
    UserPreferenceData(
      options: [
        "Nuts",
        "Seafood",
        "Dairy",
        "Gluten",
        "Eggs",
        "Other (Specify)",
      ],
      type: UserPreferenceType.multiple,
      question: 'Do you have any allergies or ingredients you want to avoid?',
    ),
    UserPreferenceData(
      options: [
        'Indian',
        'Chinese',
        'Italian',
        'Mexican',
        'Thai',
        'Mediterranean',
        'Japanese',
        'Korean',
        "Other (Specify)"
      ],
      type: UserPreferenceType.multiple,
      question: "What type of cuisine are you interested in?",
    ),
    UserPreferenceData(
      options: [
        'Breakfast',
        'Lunch',
        'Dinner',
        'Snacks',
      ],
      type: UserPreferenceType.multiple,
      question: 'What type of meal are you looking for?',
    ),
    UserPreferenceData(
      options: [
        'Spicy',
        'Sweet',
        'Salty',
        'Sour',
        'Bitter',
      ],
      type: UserPreferenceType.multiple,
      question:
          'Are there any specific flavors or ingredients you enjoy or dislike?',
    ),
    UserPreferenceData(
      options: [
        "Beginner",
        "Intermediate",
        "Advanced",
      ],
      type: UserPreferenceType.single,
      selectedChips: {
        "Beginner",
      },
      question: 'How comfortable are you in the kitchen?',
    ),
  ];
  List<String> mealTypes = [];
  List<String> tastePreferences = [];
  List<String> dietaryPreferences = [];
  List<String> dietaryRestrictions = [];
  List<String> cuisineList = [];
  TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    controller.dispose();
    super.dispose();
  }

  void updateUserSelection({
    required UserPreferenceData data,
  }) {
    if (data.question == 'What type of meal are you looking for?') {
      mealTypes.clear();
      mealTypes = data.selectedChips.toList();
    } else if (data.question ==
        'Are there any specific flavors or ingredients you enjoy or dislike?') {
      tastePreferences.clear();
      tastePreferences = data.selectedChips.toList();
    } else if (data.question ==
        'Do you have any dietary preferences or restrictions?') {
      dietaryPreferences.clear();
      dietaryPreferences = data.selectedChips.toList();
    } else if (data.question ==
        'Do you have any allergies or ingredients you want to avoid?') {
      dietaryRestrictions.clear();
      dietaryRestrictions = data.selectedChips.toList();
    } else if (data.question == 'What type of cuisine are you interested in?') {
      cuisineList.clear();
      cuisineList = data.selectedChips.toList();
    }
  }

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
        leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(Icons.arrow_back_ios_rounded)),
        backgroundColor: ColorPalette.primary,
        title: Text(
          "Set Your Recipe Preferences",
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Utils.saveToLocalStorage(
                  key: StorageStrings.userPreferenceStatus, data: true);
              context.go(Routes.home);
            },
            child: Text(
              "Skip",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
      backgroundColor: ColorPalette.primary,
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              separatorBuilder: (_, __) => const SizedBox(height: 25),
              itemCount: questionData.length,
              itemBuilder: (_, i) {
                var data = questionData[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${i + 1}. ${data.question}",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              letterSpacing: .5,
                              color: Colors.white,
                            ),
                      ),
                      const SizedBox(height: 15),
                      if (data.type == UserPreferenceType.multiple)
                        Wrap(
                          spacing: 7,
                          runSpacing: 10,
                          children: data.options.map((goal) {
                            return ChoiceChip(
                              checkmarkColor: Colors.white,
                              selectedColor: ColorPalette.primary,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: data.selectedChips.contains(goal)
                                          ? Colors.white
                                          : Colors.black.withOpacity(.5),
                                      width: 1.5),
                                  borderRadius: BorderRadius.circular(100)),
                              elevation: 2,
                              label: Text(
                                goal,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: .5,
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
                                  updateUserSelection(data: data);
                                });
                              },
                            );
                          }).toList(),
                        ),
                      if (data.selectedChips.contains(
                        "Other (Specify)",
                      ))
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: (data.selectedChips.contains(
                            "Other (Specify)",
                          ))
                              ? 1
                              : 0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: TextFormField(
                              controller: textEditingController,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (value) {
                                setState(() {
                                  data.options.add(value);
                                  data.selectedChips.add(value);
                                  textEditingController.clear();
                                });
                              },
                              decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Colors.black,
                                      )),
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          data.options.add(textEditingController
                                              .text
                                              .trim());
                                          data.selectedChips.add(
                                              textEditingController.text
                                                  .trim());
                                          textEditingController.clear();
                                        });
                                      },
                                      icon: const Icon(Icons.send))),
                            ),
                          ),
                        ),
                      if (data.type == UserPreferenceType.single)
                        SegmentedButton(
                          showSelectedIcon: false,
                          style: SegmentedButton.styleFrom(
                              selectedBackgroundColor:
                                  ColorPalette.primarylight,
                              backgroundColor: Colors.white),
                          selected: data.selectedChips,
                          multiSelectionEnabled: false,
                          onSelectionChanged: (Set<String> newSelection) {
                            setState(() {
                              data.selectedChips = newSelection;
                            });
                          },
                          segments: List.generate(
                              data.options.length,
                              (i) => ButtonSegment(
                                  value: data.options[i],
                                  label: Text(
                                    data.options[i],
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ))),
                        ),
                      if (i == questionData.length - 1)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: ElevatedButton(
                                onPressed: () async {
                                  final userData = Utils.getFomLocalStorage(
                                      key: StorageStrings.userData);
                                  userData['mealTypes'] = mealTypes;
                                  userData['tastePreferences'] =
                                      tastePreferences;
                                  userData['dietaryPreferences'] =
                                      dietaryPreferences;
                                  userData['dietaryRestrictions'] =
                                      dietaryRestrictions;
                                  userData['cuisineList'] = cuisineList;
                                  await UserRespository.updateUserData(
                                      userData['uid'], userData);
                                  final data =
                                      await UserRespository.getUserData(
                                          userData['uid']);
                                  if (data != null) {
                                    Utils.saveToLocalStorage(
                                        key: StorageStrings.userData,
                                        data: data.toMap());
                                    Utils.saveToLocalStorage(
                                        key:
                                            StorageStrings.userPreferenceStatus,
                                        data: true);
                                    if (context.mounted) {
                                      context.go(Routes.home);
                                    }
                                  }
                                },
                                child: Text(
                                  "Submit",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(fontWeight: FontWeight.bold),
                                )),
                          ),
                        )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/*
PageView.builder(
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
                    if (data.type == UserPreferenceType.multiple)
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
                                  .bodyMedium!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: .5,
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
                    if (data.type == UserPreferenceType.single)
                      SegmentedButton(
                        selected: data.selectedChips,
                        multiSelectionEnabled: true,
                        onSelectionChanged: (Set<String> newSelection) {
                          setState(() {
                            selected = newSelection.first;
                          });
                        },
                        segments: List.generate(
                            data.options.length,
                            (i) => ButtonSegment(
                                value: data.options[i],
                                label: Text(
                                  data.options[i],
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ))),
                      )
                  ],
                ),
              ));
        },
      ),*/

class UserPreferenceData {
  UserPreferenceData({
    required this.question,
    required this.options,
    required this.type,
    Set<String>? selectedChips,
  }) : selectedChips = selectedChips ?? <String>{};

  List<String> options;
  final String question;
  Set<String> selectedChips;
  final UserPreferenceType type;
}

enum UserPreferenceType { multiple, single }
