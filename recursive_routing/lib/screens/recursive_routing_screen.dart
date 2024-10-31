// Copyright 2020-2024 Hellogramming. All rights reserved.
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://hellogramming.com/flutter_experiments/license/.

import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

import '../common/strings.dart' as strings;
import '../common/urls.dart' as urls;
import '../utils/color_utils.dart' as color_utils;

/// The list of accent colors for the recursive routing screens.
///
/// The colors are used to visually distinguish the recursive routing screens when they are
/// navigated. The colors are generated randomly as the screens are navigated deeper.
List<Color> _accentColors = <Color>[];

/// A screen that demonstrates recursive routing and state keeping with a counter.
class RecursiveRoutingScreen extends StatefulWidget {
  const RecursiveRoutingScreen(
    this.level, {
    super.key,
  });

  /// The level of the recursive routing screen.
  final int level;

  @override
  State<RecursiveRoutingScreen> createState() => _RecursiveRoutingScreenState();
}

class _RecursiveRoutingScreenState extends State<RecursiveRoutingScreen> {
  /// The counter that is displayed on the screen to show the state keeping.
  int _counter = 0;

  /// The accent color of the current recursive routing screen.
  late final Color _accentColor;

  @override
  void initState() {
    super.initState();

    // Get the accent color for the current level, and add more colors if necessary
    if (widget.level >= _accentColors.length) {
      _accentColors.add(color_utils.getRandomColor());
    }
    _accentColor = _accentColors[widget.level - 1];
  }

  /// Navigates to a deeper recursive routing screen.
  void _goDown() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecursiveRoutingScreen(widget.level + 1),
      ),
    );
  }

  /// Navigates to a shallower recursive routing screen.
  void _goUp() {
    if (widget.level > 1) Navigator.pop(context);
  }

  /// Performs the tasks of the app bar actions.
  void _onAppBarAction(_AppBarActions action) {
    switch (action) {
      // Increment the counter
      case _AppBarActions.incrementCounter:
        setState(() => _counter++);
        break;
      // Go back to the first level of the recursive routing
      case _AppBarActions.goHome:
        Navigator.popUntil(context, (route) => route.isFirst);
        break;
      // Open the source code of the experiments in the browser
      case _AppBarActions.viewSource:
        launchUrl(Uri.parse(urls.viewSourceUrl));
        break;
      // Open the about page of the experiments in the browser
      case _AppBarActions.about:
        launchUrl(Uri.parse(urls.aboutUrl));
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
        level: widget.level,
        backgroundColor: _accentColor,
        foregroundColor: contrastColor,
        onAction: _onAppBarAction,
      ),

      // The body with just the counter text in the center
      body: Center(
        child: Text(
          '$_counter',
          style: Theme.of(context).textTheme.displayLarge!.copyWith(color: counterColor),
        ),
      ),

      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // The floating action button that navigates to a shallower recursive routing screen
          if (widget.level > 1) ...[
            FloatingActionButton.large(
              heroTag: 'goUp',
              backgroundColor: _accentColor,
              foregroundColor: contrastColor,
              tooltip: strings.goUpTooltip,
              onPressed: _goUp,
              child: const Icon(Icons.arrow_back),
            ),
            const SizedBox(width: 16.0),
          ],

          // The floating action button that navigates to a deeper recursive routing screen
          FloatingActionButton.large(
            heroTag: 'goDown',
            backgroundColor: _accentColor,
            foregroundColor: contrastColor,
            tooltip: strings.goDownTooltip,
            onPressed: _goDown,
            child: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }
}

/// Enum that defines the actions of the app bar.
enum _AppBarActions {
  incrementCounter,
  goHome,
  viewSource,
  about,
}

/// The app bar of the recursive routing screen.
class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({
    super.key, // ignore: unused_element
    required this.level,
    this.backgroundColor,
    this.foregroundColor,
    this.onAction,
  });

  /// The level of the recursive routing to display in the app bar title.
  final int level;

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
      title: ListTile(
        title: Text(strings.recursiveLevel(level)),
        subtitle: const Text(strings.recursiveRoutingScreenTitle),
        textColor: foregroundColor,
        contentPadding: EdgeInsets.zero,
      ),
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
              child: Text(strings.goHomeMenuItem),
            ),

            // Add a divider between the menu items
            const PopupMenuDivider(),

            const PopupMenuItem(
              value: _AppBarActions.viewSource,
              child: Text(strings.viewSourceMenuItem),
            ),

            const PopupMenuItem(
              value: _AppBarActions.about,
              child: Text(strings.aboutMenuItem),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
