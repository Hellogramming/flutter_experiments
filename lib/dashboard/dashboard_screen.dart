import 'package:flutter/material.dart';

import '../common/app_strings.dart';
import '../experiments/recursive_routing/recursive_routing_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
      ),
      body: ListView(
        children: <Widget>[
          makeDashboardItem(
            context,
            AppStrings.recursiveRoutingTitle,
            (context) => const RecursiveRoutingScreen(1),
          ),
        ],
      ),
    );
  }

  Card makeDashboardItem(BuildContext context, String title, WidgetBuilder routeBuilder) {
    return Card(
      child: ListTile(
        title: Text(title),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: routeBuilder));
        },
      ),
    );
  }
}
