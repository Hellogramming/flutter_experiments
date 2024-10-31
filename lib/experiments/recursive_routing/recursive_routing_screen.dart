import 'package:flutter/material.dart';

import 'app_strings.dart';

/// Overflow menu items enumeration.
enum MenuAction { home }

class RecursiveRoutingScreen extends StatefulWidget {
  const RecursiveRoutingScreen(
    this.depth, {
    super.key,
  });

  final int depth;

  @override
  State<RecursiveRoutingScreen> createState() => _RecursiveRoutingScreenState();
}

class _RecursiveRoutingScreenState extends State<RecursiveRoutingScreen> {
  int _counter = 0;

  Color _counterColor = Colors.black26;

  @override
  void initState() {
    _counter = widget.depth;
    super.initState();
  }

  void _goDeep(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecursiveRoutingScreen(widget.depth + 1),
      ),
    );
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
      _counterColor = Colors.black;
    });
  }

  void _goHome(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  /// Performs the tasks of the popup menu items (home).
  void popupMenuSelection(MenuAction item) {
    switch (item) {
      case MenuAction.home:
        // Go home to the app dashboard.
        _goHome(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Color color = Colors.primaries[(widget.depth - 1) % Colors.primaries.length];

    return Theme(
      data: Theme.of(context).copyWith(
        primaryColor: color,
        colorScheme: Theme.of(context).colorScheme.copyWith(secondary: color),
      ),
      child: Scaffold(
        appBar: AppBar(title: Text('${AppStrings.screenTitle} ${widget.depth}'), actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_circle),
            tooltip: AppStrings.addTooltip,
            onPressed: _incrementCounter,
          ),
          PopupMenuButton<MenuAction>(
            onSelected: popupMenuSelection,
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: MenuAction.home,
                child: Text(AppStrings.goHomeTitle),
              ),
            ],
          ),
        ]),
        body: Center(
          child: Text(
            '$_counter',
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(color: _counterColor),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.arrow_drop_down_circle),
          label: const Text(AppStrings.goDeeperTitle),
          onPressed: () => _goDeep(context),
        ),
      ),
    );
  }
}
