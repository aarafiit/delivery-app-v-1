import 'package:flutter/material.dart';

/// Search tab placeholder screen. (Requirements 16.1, 16.2, 16.3)
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Search',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
