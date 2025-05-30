import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/expence.dart';
import 'package:flutter_application_1/server/database.dart';
import 'package:flutter_application_1/widgets/add_new_expence.dart';
import 'package:flutter_application_1/widgets/expence_list.dart';
import 'package:hive/hive.dart';
import 'package:pie_chart/pie_chart.dart';

class Expences extends StatefulWidget {
  const Expences({super.key});

  @override
  State<Expences> createState() => _ExpencesState();
}

class _ExpencesState extends State<Expences> {
  final _myBox = Hive.box("expenceDatabase");
  Database db = Database();
  // final List<ExpenceModel> _expenceList = [
  //   ExpenceModel(
  //     title: "Foodball",
  //     amount: 12.5,
  //     date: DateTime.now(),
  //     category: Category.leasure,
  //   ),
  //   ExpenceModel(
  //     title: "Carrot",
  //     amount: 10,
  //     date: DateTime.now(),
  //     category: Category.food,
  //   ),
  //   ExpenceModel(
  //     title: "Bag",
  //     amount: 20,
  //     date: DateTime.now(),
  //     category: Category.travel,
  //   ),
  // ];

  //add new expence
  void onAddNewExpence(ExpenceModel expence) {
    setState(() {
      db.expenceList.add(expence);
      calCategoryValues();
    });
    db.updateData();
  }

  //remove expence
  void onDeleteExpence(ExpenceModel expence) {
    //store the deleting expence
    ExpenceModel deletingExpence = expence;
    //get the index of the removing expence
    final int removingIndex = db.expenceList.indexOf(expence);
    setState(() {
      db.expenceList.remove(expence);
      db.updateData();
      calCategoryValues();
    });
    // show snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Delete Successful"),
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            setState(() {
              db.expenceList.insert(removingIndex, deletingExpence);
              db.updateData();
              calCategoryValues();
            });
          },
        ),
      ),
    );
  }

  //function to open a modal overlay
  void _openAddExpenceOvrlay() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return AddNewExpence(onAddExpence: onAddNewExpence);
      },
    );
  }

  //pie chart
  Map<String, double> dataMap = {
    "Food": 0,
    "Travel": 0,
    "Leasure": 0,
    "Work": 0,
  };

  double foodVal = 0;
  double travelVal = 0;
  double leasurelVal = 0;
  double workVal = 0;

  void calCategoryValues() {
    double foodValTotal = 0;
    double travelValTotal = 0;
    double leasurelValTotal = 0;
    double workValTotal = 0;

    for (final expence in db.expenceList) {
      if (expence.category == Category.food) {
        foodValTotal += expence.amount;
      }
      if (expence.category == Category.leasure) {
        leasurelValTotal += expence.amount;
      }
      if (expence.category == Category.work) {
        workValTotal += expence.amount;
      }
      if (expence.category == Category.travel) {
        travelValTotal += expence.amount;
      }
    }
    setState(() {
      foodVal = foodValTotal;
      travelVal = travelValTotal;
      leasurelVal = leasurelValTotal;
      workVal = workValTotal;
    });

    //update the data map
    dataMap = {
      "Food": foodVal,
      "Travel": travelVal,
      "Leasure": leasurelVal,
      "Work": workVal,
    };
  }

  @override
  void initState() {
    super.initState();
    calCategoryValues();
    //if this is the first time create the initial data
    if (_myBox.get("EXP_DATA") == null) {
      db.createInitialDatabase();
      calCategoryValues();
    } else {
      db.loadData();
      calCategoryValues();
    }
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
      body: Column(
        children: [
          PieChart(dataMap: dataMap),
          ExpenceList(
            expenceList: db.expenceList,
            onDeleteExpence: onDeleteExpence,
          ),
        ],
      ),
    );
  }
}
