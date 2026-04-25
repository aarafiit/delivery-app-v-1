import 'package:flutter/material.dart';

/// Categories tab placeholder screen. (Requirements 16.1, 16.2, 16.3)
class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Categories',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
