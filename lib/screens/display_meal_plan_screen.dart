import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import '../models.dart';

class DisplayMealPlanScreen extends StatefulWidget {
  @override
  _DisplayMealPlanScreenState createState() => _DisplayMealPlanScreenState();
}

class _DisplayMealPlanScreenState extends State<DisplayMealPlanScreen> {
  final DatabaseHelper databaseHelper = DatabaseHelper();
  List<MealPlan> mealPlans = [];
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      Map<String, dynamic> arguments =
      ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      DateTime selectedDate = arguments['selectedDate'] as DateTime;

      // Query the database for a meal plan with the selected date
      List<MealPlan> fetchedMealPlans =
      await databaseHelper.getMealPlansByDate(selectedDate);

      print('Data fetched successfully: $fetchedMealPlans');

      setState(() {
        mealPlans = fetchedMealPlans;
        isLoading = false;
      });
    } catch (error) {
      print('Error fetching meal plans: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Display Meal Plan'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : mealPlans.isNotEmpty
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Meal Plan for ${mealPlans.first.date.toLocal()}'),
          for (var mealPlan in mealPlans)
            Column(
              children: [
                Text('Selected Food Items:'),
                for (var foodItem in mealPlan.foodItems)
                  ListTile(
                    title: Text(foodItem.name),
                    subtitle: Text('${foodItem.calories} calories'),
                  ),
              ],
            ),
        ],
      )
          : Center(
        child: Text('No meal plan found for the selected date'),
      ),
    );
  }
}
