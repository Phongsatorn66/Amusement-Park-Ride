// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/ride_provider.dart';
import 'screens/ride_list_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => RideProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Amusement Park Ride App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const RideListScreen(),
    );
  }
}
