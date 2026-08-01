import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jobtrack/presentation/views/job_details_screen.dart';
import '../../presentation/viewmodels/auth_viewmodel.dart';
import '../../presentation/views/shell_scaffold.dart';
import '../../presentation/views/login_screen.dart';
import '../../presentation/views/register_screen.dart';
import '../../presentation/views/forgot_password_screen.dart';
import '../../presentation/views/home_screen.dart';
import '../../presentation/views/jobs_screen.dart';
import '../../presentation/views/applications_screen.dart';
import '../../presentation/views/saved_jobs_screens.dart';
import '../../presentation/views/profile_screen.dart';
import '../../presentation/views/add_application_screen.dart';
import '../../presentation/views/application_details_screen.dart';



final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/login',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLoggedIn = authState.valueOrNull != null;
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/forgot-password';

      if (!isLoggedIn && !isAuthRoute) return '/login';
      if (isLoggedIn && isAuthRoute) return '/home';

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context , state) => const LoginScreen()
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context , state , child){
          return ShellScaffold(
            child: child, 
            currentLocation: state.matchedLocation,
          );
        },
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/jobs',
            name: 'jobs',
            builder: (context, state) => const JobsScreen(),
          ),
          GoRoute(
            path: '/jobs/:id',
            name: 'job-details',
            builder: (context, state) {
              final jobId = state.pathParameters['id']!;
              return JobDetailsScreen(jobId: jobId);
            },

          ),
          GoRoute(
            path: '/applications',
            name: 'applications',
            builder: (context, state) => const ApplicationsScreen(),
          ),
          GoRoute(
            path: '/saved',
            name: 'saved',
            builder: (context, state) => const SavedJobsScreen(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/applications/new',
            name: 'add-application',
            builder: (context, state) => const AddApplicationScreen(),
          ),
          GoRoute(
            path: '/applications/:id',
            name: 'application-details',
            builder: (context, state) {
              final appId = state.pathParameters['id']!;
              return ApplicationDetailsScreen(applicationId: appId);
            },
          ),

        ]
      ),
    ]
  );

});