import 'package:flutter/material.dart';
import 'package:flutter_calories_calculator/models.dart';

class SelectFoodScreen extends StatefulWidget {
  final List<FoodItem> foodItems;
  final DateTime? selectedDate;

  SelectFoodScreen({
    required this.foodItems,
    required this.selectedDate,
  });

  @override
  _SelectFoodScreenState createState() => _SelectFoodScreenState();
}

class _SelectFoodScreenState extends State<SelectFoodScreen> {
  List<FoodItem> selectedFoodItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Food Items'),
      ),
      body: ListView.builder(
        itemCount: widget.foodItems.length,
        itemBuilder: (context, index) {
          FoodItem foodItem = widget.foodItems[index];
          bool isSelected = selectedFoodItems.contains(foodItem);

          return ListTile(
            title: Text(foodItem.name),
            subtitle: Text('${foodItem.calories} calories'),
            onTap: () {
              setState(() {
                // Toggle selection
                if (isSelected) {
                  selectedFoodItems.remove(foodItem);
                } else {
                  selectedFoodItems.add(foodItem);
                }
              });
            },
            tileColor: isSelected ? Colors.blue.withOpacity(0.2) : null,
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // Navigate to the View Meal Plan Screen and pass the selected food items
            Navigator.pushNamed(
              context,
              '/viewMealPlan',
              arguments: {
                'selectedFoodItems': selectedFoodItems,
                'selectedDate': widget.selectedDate,
              },
            );
          },
          child: Text('View Meal Plan'),
        ),
      ),
    );
  }
}
