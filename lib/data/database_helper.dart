import 'dart:convert';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_calories_calculator/models.dart'; // Import the data model

class DatabaseHelper {
  static late Database _database;

  static Future<Database> get database async {
    if (_database.isOpen) {
      return _database;
    } else {
      await initDatabase();
      return _database;
    }
  }

  static Future<void> initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'your_database_name.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE meal_plan(
            id INTEGER PRIMARY KEY,
            date TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE food_item(
            id INTEGER PRIMARY KEY,
            meal_plan_id INTEGER,
            name TEXT,
            calories INTEGER,
            FOREIGN KEY (meal_plan_id) REFERENCES meal_plan (id)
          )
        ''');
      },
    );
  }

  Future<int> insertMealPlan(MealPlan mealPlan) async {
    try {
      Database db = await database;

      // Convert the foodItems list to a JSON string
      String foodItemsJson = jsonEncode(mealPlan.foodItems);

      // Insert the meal plan
      int mealPlanId = await db.insert('meal_plan', {
        'id': mealPlan.id,
        'foodItems': foodItemsJson,
        'date': mealPlan.date,
      });

      return mealPlanId;
    } catch (e) {
      // Handle any errors that may occur during the insertion
      print('Error inserting meal plan: $e');
      // You might want to throw an exception or return an error code here
      throw Exception('Error inserting meal plan');
    }
  }

  Future<int> insertFoodItem(FoodItem foodItem, int mealPlanId) async {
    Database db = await database;
    return await db.insert(
      'food_items',
      {
        'meal_plan_id': mealPlanId,
        'name': foodItem.name,
        'calories': foodItem.calories,
      },
    );
  }

  Future<void> insertFoodItems(List<Map<String, dynamic>> foodItems) async {
    final db = await database;

    for (var item in foodItems) {
      await db.insert('food_item', item,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<List<MealPlan>> getMealPlans(DateTime date) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'meal_plans',
      where: 'date = ?',
      whereArgs: [date.toIso8601String()],
    );

    if (maps.isEmpty) {
      return [];
    }

    List<MealPlan> mealPlans = [];
    for (var map in maps) {
      List<Map<String, dynamic>> foodMaps = await db.query(
        'food_items',
        where: 'meal_plan_id = ?',
        whereArgs: [map['id']],
      );

      List<FoodItem> foodItems = foodMaps.map((foodMap) {
        return FoodItem.fromMap(foodMap);
      }).toList();

      mealPlans.add(
        MealPlan(
          id: map['id'],
          date: DateTime.parse(map['date']),
          foodItems: foodItems,
        ),
      );
    }

    return mealPlans;
  }

  Future<List<MealPlan>> getMealPlansByDate(DateTime date) async {
    final Database db = _database.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'meal_plan',
      where: 'date = ?',
      whereArgs: [date.toIso8601String()], // Convert DateTime to ISO8601 format
    );

    return List.generate(maps.length, (index) {
      return MealPlan.fromMap(maps[index]);
    });
  }

  Future<void> printAllMealPlans() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('meal_plan');

    print('All Meal Plans:');
    for (var map in maps) {
      print(MealPlan.fromMap(map));
    }
  }

  Future<void> printAllFoodItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('food_item');

    print('All Food Items:');
    for (var map in maps) {
      print(FoodItem.fromMap(map));
    }
  }

  Future<void> deleteMealPlanByDate(DateTime selectedDate) async {
    try {
      Database db = await database;
      await db.delete(
        'meal_plan',
        where: 'date = ?',
        whereArgs: [selectedDate.toIso8601String()],
      );
    } catch (e) {
      print('Error deleting meal plan: $e');
      // Handle errors as needed
      throw Exception('Error deleting meal plan');
    }
  }

  Future<void> updateMealPlanByDate(DateTime selectedDate) async {
    try {
      Database db = await database;

      // Fetch the existing meal plan based on the selected date
      MealPlan? existingMealPlan = await getMealPlanByDate(selectedDate);
      MealPlan? updatedMealPlan = await getMealPlanByDate(selectedDate);

      // Check if a meal plan exists for the selected date
      if (existingMealPlan != null) {
        // Update the fields of the existing meal plan with the new values
        await db.update(
          'meal_plan',
          updatedMealPlan!.toMap(),
          where: 'date = ?',
          whereArgs: [selectedDate.toIso8601String()],
        );
      } else {
        // Meal plan not found for the selected date, handle accordingly
        throw Exception('Meal plan not found for the selected date');
      }
    } catch (e) {
      print('Error updating meal plan: $e');
      // Handle errors as needed
      throw Exception('Error updating meal plan');
    }
  }

  // Fetch a meal plan based on the date
  Future<MealPlan?> getMealPlanByDate(DateTime selectedDate) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'meal_plan',
      where: 'date = ?',
      whereArgs: [selectedDate.toIso8601String()],
    );

    if (maps.isNotEmpty) {
      // If a meal plan is found, create a MealPlan object from the map
      return MealPlan.fromMap(maps.first);
    } else {
      // If no meal plan is found, return null
      return null;
    }
  }

}
