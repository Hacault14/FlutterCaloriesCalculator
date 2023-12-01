import 'package:flutter/material.dart';

class EnterDateScreen extends StatefulWidget {
  @override
  _EnterDateScreenState createState() => _EnterDateScreenState();
}

class _EnterDateScreenState extends State<EnterDateScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Date'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Selected Date: ${selectedDate.toLocal()}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text('Select Date'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/displayMealPlan',
                  arguments: {'selectedDate': selectedDate},
                );
              },
              child: Text('Find Meal Plan'),
            ),
          ],
        ),
      ),
    );
  }
}
