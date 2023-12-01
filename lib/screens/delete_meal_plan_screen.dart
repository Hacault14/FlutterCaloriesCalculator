import 'package:flutter/material.dart';
import '../data/database_helper.dart';

class DeleteMealPlanScreen extends StatefulWidget {
  @override
  _DeleteMealPlanScreenState createState() => _DeleteMealPlanScreenState();
}

class _DeleteMealPlanScreenState extends State<DeleteMealPlanScreen> {
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _deleteMealPlan(BuildContext context) async {
    try {
      await DatabaseHelper().deleteMealPlanByDate(selectedDate);

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Meal plan deleted successfully!'),
        ),
      );
    } catch (e) {
      // Handle errors
      print('Error deleting meal plan: $e');

      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting meal plan. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Meal Plan'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Select date to delete meal plan:'),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text('Select Date'),
            ),
            Text(
              'Selected Date: ${selectedDate.toLocal()}',
              style: TextStyle(fontSize: 16),
            ),
            ElevatedButton(
              onPressed: () => _deleteMealPlan(context),
              child: Text('Delete Meal Plan'),
            ),
          ],
        ),
      ),
    );
  }
}
