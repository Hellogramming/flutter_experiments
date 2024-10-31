// Copyright 2020-2024 Hellogramming. All rights reserved.
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://hellogramming.com/flutter_experiments/license/.

import 'dart:math';

import 'package:flutter/material.dart';

/// A random number generator used to generate random colors.
final Random _random = Random();

/// Generates a random color.
Color getRandomColor() {
  return Color.fromRGBO(_random.nextInt(256), _random.nextInt(256), _random.nextInt(256), 1.0);
}

/// Returns an appropriate contast color for the given color (black or white).
Color bwContrastOf(Color color) {
  return ThemeData.estimateBrightnessForColor(color) == Brightness.light
      ? Colors.black
      : Colors.white;
}
