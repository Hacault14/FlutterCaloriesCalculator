import 'package:flutter/material.dart';

class TargetCaloriesScreen extends StatefulWidget {
  @override
  _TargetCaloriesScreenState createState() => _TargetCaloriesScreenState();
}

class _TargetCaloriesScreenState extends State<TargetCaloriesScreen> {
  TextEditingController targetCaloriesController = TextEditingController();
  DateTime selectedDate = DateTime.now(); // Default to the current date

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Target Calories'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: targetCaloriesController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Target Calories per Day',
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Text('Select Date: '),
                TextButton(
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2022),
                      lastDate: DateTime(2025),
                    );

                    if (pickedDate != null && pickedDate != selectedDate) {
                      setState(() {
                        selectedDate = pickedDate;
                      });
                    }
                  },
                  child: Text(
                    '${selectedDate.toLocal()}'.split(' ')[0], // Display date as 'YYYY-MM-DD'
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Validate the input and navigate to the Select Food Screen
                if (targetCaloriesController.text.isNotEmpty) {
                  int targetCalories = int.parse(targetCaloriesController.text);
                  Navigator.pushNamed(
                    context,
                    '/selectFood',
                    arguments: {
                      'targetCalories': targetCalories,
                      'selectedDate': selectedDate,
                    },
                  );
                } else {

                }
              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
