import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/expence.dart';
import 'package:flutter_application_1/widgets/add_new_expence.dart';
import 'package:flutter_application_1/widgets/expence_list.dart';

class Expences extends StatefulWidget {
  const Expences({super.key});

  @override
  State<Expences> createState() => _ExpencesState();
}

class _ExpencesState extends State<Expences> {
  final List<ExpenceModel> _expenceList = [
    ExpenceModel(
      title: "Foodball",
      amount: 12.5,
      date: DateTime.now(),
      category: Category.leasure,
    ),
    ExpenceModel(
      title: "Carrot",
      amount: 10,
      date: DateTime.now(),
      category: Category.food,
    ),
    ExpenceModel(
      title: "Bag",
      amount: 20,
      date: DateTime.now(),
      category: Category.travel,
    ),
  ];

  //function to open a modal overlay
  void _openAddExpenceOvrlay() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return AddNewExpence();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expence master"),
        backgroundColor: const Color.fromARGB(255, 61, 101, 221),
        elevation: 0,
        actions: [
          Container(
            color: Colors.yellow,
            child: IconButton(
              onPressed: _openAddExpenceOvrlay,
              icon: const Icon(Icons.add, color: Colors.black),
            ),
          ),
        ],
      ),
      body: Column(children: [ExpenceList(expenceList: _expenceList)]),
    );
  }
}
