// Copyright 2020-2024 Hellogramming. All rights reserved.
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://hellogramming.com/flutter_experiments/license/.

import 'package:flutter/material.dart';

import 'common/strings.dart' as strings;
import 'screens/recursive_routing_screen.dart';

void main() {
  runApp(const RecursiveRoutingExperiment());
}

/// The root widget of the Recursive Routing Flutter experiment.
class RecursiveRoutingExperiment extends StatelessWidget {
  const RecursiveRoutingExperiment({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: strings.appName,
      theme: ThemeData.light(),
      home: const RecursiveRoutingScreen(1),
    );
  }
}
