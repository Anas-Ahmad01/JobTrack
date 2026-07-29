import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/views/login_screen.dart';
import '../../presentation/views/register_screen.dart';
import '../../presentation/views/home_screen.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/login',
  debugLogDiagnostics: true,

  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context , state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),

  ]
);