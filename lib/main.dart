import 'package:flutter/material.dart';

import 'app.dart';
import 'data/hive_boxes.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveBoxes.init();
  runApp(const SendMeApp());
}
