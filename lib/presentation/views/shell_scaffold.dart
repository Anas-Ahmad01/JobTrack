import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ShellScaffold extends StatelessWidget {
  final Widget child;
  final String currentLocation;

  const ShellScaffold({
    super.key,
    required this.child,
    required this.currentLocation,
  });

  int get _currentIndex {
    if (currentLocation.startsWith('/home')) return 0;
    if (currentLocation.startsWith('/jobs')) return 1;
    if (currentLocation.startsWith('/applications')) return 2;
    if (currentLocation.startsWith('/saved')) return 3;
    if (currentLocation.startsWith('/profile')) return 4;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
      case 1:
        context.go('/jobs');
      case 2:
        context.go('/applications');
      case 3:
        context.go('/saved');
      case 4:
        context.go('/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => _onTap(context, index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: 'Jobs',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment),
            label: 'Apps',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_border),
            selectedIcon: Icon(Icons.bookmark),
            label: 'Saved',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}