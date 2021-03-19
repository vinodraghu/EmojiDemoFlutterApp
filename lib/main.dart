// Created By Vinod Raghuwanshi
// Date 19-03-2021

import 'package:flutter/material.dart';
import 'package:flutter_gmail_login/helper/app_state.dart';
import 'package:flutter_gmail_login/screens/home.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>(
            create: (_) => AppState()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Demo',
        home: Home(),
      ),
    ),
  );
}


