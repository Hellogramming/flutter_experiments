// Copyright 2020-2024 Hellogramming. All rights reserved.
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://hellogramming.com/flutter_experiments/license/.

import 'package:flutter/material.dart';

import '../common/strings.dart' as strings;
import '../utils/color_utils.dart' as color_utils;

/// A screen that demonstrates recursive routing and state keeping with a counter.
class RecursiveRoutingScreen extends StatefulWidget {
  const RecursiveRoutingScreen(
    this.depth, {
    super.key,
  });

  /// The depth of the recursive routing screen.
  final int depth;

  @override
  State<RecursiveRoutingScreen> createState() => _RecursiveRoutingScreenState();
}

class _RecursiveRoutingScreenState extends State<RecursiveRoutingScreen> {
  /// The counter that is displayed on the screen to show the state keeping.
  int _counter = 0;

  /// The accent color of the current recursive routing screen.
  ///
  /// Used for the app bar background color and the floating action button color, in order to
  /// visually distinguish the recursive routing screens when they are navigated.
  late final Color _accentColor;

  @override
  void initState() {
    super.initState();

    // Generate a random color for the accent color of the current screen
    // Uses the depth as the seed to generate a different color for each screen but the same color
    // for the same screen when it is navigated back to
    _accentColor = color_utils.getRandomColorWithSeed(widget.depth);
  }

  /// Navigates to a deeper recursive routing screen.
  void _goDeep() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecursiveRoutingScreen(widget.depth + 1),
      ),
    );
  }

  /// Performs the tasks of the app bar actions.
  void _onAppBarAction(_AppBarActions action) {
    switch (action) {
      case _AppBarActions.incrementCounter:
        // Increment the counter
        setState(() => _counter++);
        break;
      case _AppBarActions.goHome:
        // Go back to the first level of the recursive routing
        Navigator.popUntil(context, (route) => route.isFirst);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color contrastColor = color_utils.bwContrastOf(_accentColor);
    final Color counterColor = _counter > 0 ? Colors.black : Colors.black26;

    return Scaffold(
      // The app bar with the title and actions, filled with the accent color of the current screen
      appBar: _AppBar(
        depth: widget.depth,
        backgroundColor: _accentColor,
        foregroundColor: contrastColor,
        onAction: _onAppBarAction,
      ),

      // The body with just the counter text in the center
      body: Center(
        child: Text(
          '$_counter',
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(color: counterColor),
        ),
      ),

      // The floating action button that navigates to a deeper recursive routing screen
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: _accentColor,
        foregroundColor: contrastColor,
        onPressed: _goDeep,
        icon: const Icon(Icons.arrow_drop_down_circle),
        label: const Text(strings.goDeeperTitle),
      ),
    );
  }
}

/// Enum that defines the actions of the app bar.
enum _AppBarActions {
  incrementCounter,
  goHome,
}

/// The app bar of the recursive routing screen.
class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({
    super.key, // ignore: unused_element
    required this.depth,
    this.backgroundColor,
    this.foregroundColor,
    this.onAction,
  });

  /// The depth of the recursive routing to display in the app bar title.
  final int depth;

  /// The background color of the app bar.
  final Color? backgroundColor;

  /// The foreground color of the app bar.
  final Color? foregroundColor;

  /// The callback that is called when an app bar action is pressed.
  final void Function(_AppBarActions action)? onAction;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      title: Text(strings.recursiveRoutingScreenTitle(depth)),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.add_circle),
          tooltip: strings.addTooltip,
          onPressed: () => onAction?.call(_AppBarActions.incrementCounter),
        ),
        PopupMenuButton<_AppBarActions>(
          onSelected: onAction,
          itemBuilder: (_) => [
            const PopupMenuItem(
              value: _AppBarActions.goHome,
              child: Text(strings.goHomeTitle),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
