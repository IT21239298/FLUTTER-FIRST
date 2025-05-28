import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

//create uuid
final uuid = const Uuid().v4();

//date formatter
final formattedDate = DateFormat.yMd();

enum Category { food, travel, leasure, work }

//category icons
final CategoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.leasure: Icons.leak_add,
  Category.travel: Icons.travel_explore,
  Category.work: Icons.work,
};

class ExpenceModel {
  //constructor
  ExpenceModel({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid;

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  //getter > formattedDate
  String get getFormatedDate {
    return formattedDate.format(date);
  }
}
