import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/core/constants/colors.dart';

import '../../core/core.dart';
import '../../utils/utils.dart';

class MealsPlanner extends StatefulWidget {
  const MealsPlanner({super.key});

  @override
  State<MealsPlanner> createState() => _MealsPlannerState();
}

class _MealsPlannerState extends State<MealsPlanner> {
  DateTime _focusDate = DateTime.now();
  final userData = Utils.getFomLocalStorage(key: StorageStrings.userData);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Hello ${userData['name']}",
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          EasyDateTimeLine(
            disabledDates: const [],
            initialDate: _focusDate,
            onDateChange: (selectedDate) {
              setState(() {
                _focusDate = selectedDate;
              });
            },
            activeColor: ColorPalette.primary,
            dayProps: EasyDayProps(
                todayHighlightStyle: TodayHighlightStyle.withBackground,
                todayHighlightColor: ColorPalette.primarylight,
                todayStrStyle: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Colors.white),
                todayNumStyle: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                todayMonthStrStyle: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Colors.white)),
          )
        ],
      ),
    );
  }
}
