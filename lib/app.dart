import 'package:SendMe/viewmodels/home_viewmodel.dart';
import 'package:SendMe/views/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/theme.dart';


class SendMeApp extends StatelessWidget {
  const SendMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeViewModel());

    return GetMaterialApp(
      title: 'Send Me',
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
