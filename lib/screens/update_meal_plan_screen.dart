import 'package:flutter/material.dart';

class UpdateMealPlanScreen extends StatefulWidget {
  @override
  _UpdateMealPlanScreenState createState() => _UpdateMealPlanScreenState();
}

class _UpdateMealPlanScreenState extends State<UpdateMealPlanScreen> {
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

  void _updateMealPlan(BuildContext context) {
    Navigator.pushNamed(context, '/selectFood', arguments: {
      'selectedDate': selectedDate,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Meal Plan'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Select date to update meal plan:'),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text('Select Date'),
            ),
            Text(
              'Selected Date: ${selectedDate.toLocal()}',
              style: TextStyle(fontSize: 16),
            ),
            ElevatedButton(
              onPressed: () => _updateMealPlan(context),
              child: Text('Update Meal Plan'),
            ),
          ],
        ),
      ),
    );
  }
}
