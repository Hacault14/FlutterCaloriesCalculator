import 'package:uuid/uuid.dart';

class FoodItem {
  String name;
  int calories;

  FoodItem({
    required this.name,
    required this.calories,
  });

  // Create a map from the FoodItem object for database operations
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'calories': calories,
    };
  }

  // Create a FoodItem object from a map retrieved from the database
  static FoodItem fromMap(Map<String, dynamic> map) {
    return FoodItem(
      name: map['name'],
      calories: map['calories'],
    );
  }
}

List<FoodItem> sampleFoodItems = [
  FoodItem(name: 'Apple', calories: 95),
  FoodItem(name: 'Banana', calories: 105),
  FoodItem(name: 'Orange', calories: 62),
  FoodItem(name: 'Chicken Breast', calories: 165),
  FoodItem(name: 'Salmon', calories: 206),
  FoodItem(name: 'Broccoli', calories: 31),
  FoodItem(name: 'Carrot', calories: 41),
  FoodItem(name: 'Spinach', calories: 23),
  FoodItem(name: 'Brown Rice', calories: 215),
  FoodItem(name: 'Quinoa', calories: 120),
  FoodItem(name: 'Eggs', calories: 68),
  FoodItem(name: 'Almonds', calories: 7),
  FoodItem(name: 'Greek Yogurt', calories: 100),
  FoodItem(name: 'Cheese', calories: 113),
  FoodItem(name: 'Oatmeal', calories: 68),
  FoodItem(name: 'Tomato', calories: 22),
  FoodItem(name: 'Cucumber', calories: 45),
  FoodItem(name: 'Avocado', calories: 240),
  FoodItem(name: 'Black Beans', calories: 227),
  FoodItem(name: 'Lentils', calories: 230),
];

class MealPlan {
  int id;
  List<FoodItem> foodItems;
  DateTime date;

  MealPlan({
    required this.id,
    required this.foodItems,
    required this.date,
  });

  // Factory method to create a MealPlan from a map
  factory MealPlan.fromMap(Map<String, dynamic> map) {
    return MealPlan(
      id: map['id'],
      foodItems: List<FoodItem>.from(
        (map['foodItems'] as List).map((item) => FoodItem.fromMap(item)),
      ),
      date: DateTime.parse(map['date']),
    );
  }

  // Create a map from the MealPlan object for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'foodItems': foodItems.map((foodItem) => foodItem.toMap()).toList(),
      'date': date
    };
  }

  // Generate a unique ID for the new meal plan
  String generateUniqueId() {
    var uuid = Uuid();
    return uuid.v4();
  }

}

