import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/expence.dart';

class AddNewExpence extends StatefulWidget {
  final void Function(ExpenceModel expence) onAddExpence;
  const AddNewExpence({super.key, required this.onAddExpence});

  @override
  State<AddNewExpence> createState() => _AddNewExpenceState();
}

class _AddNewExpenceState extends State<AddNewExpence> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  Category _selectedCategory = Category.leasure;

  //date variables
  final DateTime initialDate = DateTime.now();
  final DateTime firstDate = DateTime(
    DateTime.now().year - 1,
    DateTime.now().month,
    DateTime.now().day,
  );
  final DateTime lastDate = DateTime(
    DateTime.now().year + 1,
    DateTime.now().month,
    DateTime.now().day,
  );

  DateTime _selectedDate = DateTime.now();

  //date picker
  Future<void> _openDateModal() async {
    try {
      //show the date model then store the user selected date
      final pickedDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
      );

      setState(() {
        _selectedDate = pickedDate!;
      });
    } catch (err) {
      print(err.toString());
    }
  }

  //handle form submit
  void _handleFormSubmit() {
    //form validations
    //convert the amount in to a double
    final userAmount = double.parse(_amountController.text.trim());
    if (_titleController.text.trim().isEmpty || userAmount <= 0) {
      showDialog(
        context: context,
        builder: (context) {
          return (AlertDialog(
            title: const Text("Enter valid Data"),
            content: const Text(
              "Please enter valida data for the title and the amount here the title cant be emplty and the amount cant be less than zero",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("close"),
              ),
            ],
          ));
        },
      );
    } else {
      //create a newexpence
      ExpenceModel newExpence = ExpenceModel(
        title: _titleController.text.trim(),
        amount: userAmount,
        date: _selectedDate,
        category: _selectedCategory,
      );
      widget.onAddExpence(newExpence);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _amountController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          //title text field
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              hintText: "Add new expence title",
              label: Text("Title"),
            ),
            keyboardType: TextInputType.text,
            maxLength: 50,
          ),
          Row(
            children: [
              //amount
              Expanded(
                child: TextField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    helperText: "Enter the amount",
                    label: Text("Amount"),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),

              //datepicker
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(formattedDate.format(_selectedDate)),
                    IconButton(
                      onPressed: _openDateModal,
                      icon: const Icon(Icons.date_range_outlined),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              DropdownButton(
                value: _selectedCategory,
                items: Category.values
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(category.name),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    //close the model button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },

                      style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          Colors.redAccent,
                        ),
                      ),
                      child: const Text("Close"),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _handleFormSubmit,
                      style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.green),
                      ),
                      child: const Text("Save"),
                    ),

                    //save the data and close the model button
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
