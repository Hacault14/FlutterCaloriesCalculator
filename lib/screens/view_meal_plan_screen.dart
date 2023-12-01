import 'package:flutter/material.dart';
import 'package:flutter_calories_calculator/models.dart';
import '../data/database_helper.dart';

class ViewMealPlanScreen extends StatelessWidget {
  final DatabaseHelper databaseHelper = DatabaseHelper(); // Create an instance of DatabaseHelper

  @override
  Widget build(BuildContext context) {
    // Extract the selectedFoodItems and selectedDate from the arguments
    Map<String, dynamic> arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    List<FoodItem> selectedFoodItems = arguments['selectedFoodItems'];
    DateTime selectedDate = arguments['selectedDate'];

    return Scaffold(
      appBar: AppBar(
        title: Text('View Meal Plan'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Selected Food Items:'),
          for (var foodItem in selectedFoodItems)
            ListTile(
              title: Text(foodItem.name),
              subtitle: Text('${foodItem.calories} calories'),
            ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              // Save the selected meal plan to the database
              saveMealPlan(context, selectedFoodItems, selectedDate);
            },
            child: Text('Save Meal Plan'),
          ),
        ],
      ),
    );
  }

  void saveMealPlan(BuildContext context, List<FoodItem> selectedFoodItems, DateTime selectedDate) async {
    DatabaseHelper().insertMealPlan(
      MealPlan(
        id: 0,
        foodItems: selectedFoodItems,
        date: selectedDate,
      ),
    );

    // Show a confirmation message using SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Meal plan saved successfully!'),
      ),
    );

    // Navigate back to the home screen
    Navigator.popUntil(context, ModalRoute.withName('/home'));
  }
}
