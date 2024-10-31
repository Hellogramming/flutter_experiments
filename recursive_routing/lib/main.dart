import 'package:flutter/material.dart';

import 'common/strings.dart' as strings;
import 'screens/recursive_routing_screen.dart';

void main() {
  runApp(const RecursiveRoutingApp());
}

class RecursiveRoutingApp extends StatelessWidget {
  const RecursiveRoutingApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: strings.appName,
      theme: ThemeData(),
      home: const RecursiveRoutingScreen(1),
    );
  }
}
