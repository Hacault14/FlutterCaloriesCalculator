import 'package:flutter/material.dart';
import 'package:flutter_calories_calculator/screens/update_meal_plan_screen.dart';
import '../data/database_helper.dart';
import 'delete_meal_plan_screen.dart';
import 'display_meal_plan_screen.dart';
import 'target_calories_screen.dart';
import 'select_food_screen.dart';
import 'view_meal_plan_screen.dart';
import 'enter_date_screen.dart';
import 'package:flutter_calories_calculator/models.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the database
  await DatabaseHelper.initDatabase();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterCaloriesCalculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => HomeScreen(),
        '/targetCalories': (context) => TargetCaloriesScreen(),
        '/selectFood': (context) {
          // Fetch or provide the list of food items here
          List<FoodItem> foodItems = sampleFoodItems;

          DateTime? selectedDate;

          var arguments = ModalRoute.of(context)!.settings.arguments;

          if (arguments != null && arguments is Map<String, dynamic> && arguments.containsKey('selectedDate')) {
            selectedDate = arguments['selectedDate'] as DateTime?;
          }

          return SelectFoodScreen(foodItems: foodItems, selectedDate: selectedDate);
        },
        '/viewMealPlan': (context) => ViewMealPlanScreen(),
        '/enterDate': (context) => EnterDateScreen(),
        '/displayMealPlan': (context) => DisplayMealPlanScreen(),
        '/deleteMealPlan': (context) => DeleteMealPlanScreen(),
        '/updateMealPlan': (context) => UpdateMealPlanScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Planner Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/targetCalories');
              },
              child: Text('Create New Meal Plan'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/enterDate');
              },
              child: Text('Find Existing Meal Plan'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/deleteMealPlan');
              },
              child: Text('Delete Meal Plan'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/updateMealPlan');
              },
              child: Text('Update Meal Plan'),
            ),
          ],
        ),
      ),
    );
  }
}