import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/job_application.dart';
import '../common/widgets/application_card.dart';
import '../common/widgets/empty_state_widget.dart';
import '../viewmodels/applications_viewmodel.dart';
import '../viewmodels/profile_viewmodel.dart';
import '../viewmodels/saved_jobs_viewmodel.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileViewModelProvider);
    final appsState = ref.watch(applicationsViewModelProvider);
    final savedState = ref.watch(savedJobsViewModelProvider);

    final userName = profileState.profile?.name ?? 'there';
    final totalApps = appsState.applications.length;
    final totalSaved = savedState.savedJobs.length;

    // Get 3 most recent applications
    final recentApps = appsState.applications.take(3).toList();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back,',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$userName! 👋',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    child: Text(
                      userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Stats cards
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: Icons.assignment_outlined,
                      iconColor: Theme.of(context).colorScheme.primary,
                      iconBgColor: Theme.of(context).colorScheme.primaryContainer,
                      label: 'Applications',
                      value: totalApps.toString(),
                      onTap: () => context.go('/applications'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.bookmark_border,
                      iconColor: const Color(0xFF059669),
                      iconBgColor: const Color(0xFFDCFCE7),
                      label: 'Saved Jobs',
                      value: totalSaved.toString(),
                      onTap: () => context.go('/saved'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Quick Actions
              Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              _QuickActionCard(
                icon: Icons.search,
                iconColor: Colors.white,
                iconBgColor: Theme.of(context).colorScheme.primary,
                title: 'Find Jobs',
                subtitle: 'Browse new opportunities',
                onTap: () => context.go('/jobs'),
              ),
              const SizedBox(height: 8),
              _QuickActionCard(
                icon: Icons.assignment,
                iconColor: Theme.of(context).colorScheme.onSurface,
                iconBgColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                title: 'My Applications',
                subtitle: 'Track your progress',
                onTap: () => context.go('/applications'),
              ),
              const SizedBox(height: 24),

              // Recent Applications
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Applications',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (appsState.applications.isNotEmpty)
                    TextButton(
                      onPressed: () => context.go('/applications'),
                      child: const Text('See All'),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              _buildRecentApplications(recentApps, context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentApplications(
    List<JobApplication> apps,
    BuildContext context,
  ) {
    if (apps.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const EmptyStateWidget(
          title: 'No applications yet',
          subtitle: 'Start tracking your job search',
          icon: Icons.assignment_outlined,
        ),
      );
    }

    return Column(
      children: apps.map((app) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: ApplicationCard(
            application: app,
            onTap: () => context.push('/applications/${app.id}'),
          ),
        );
      }).toList(),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String label;
  final String value;
  final VoidCallback? onTap;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.label,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF1E293B)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _QuickActionCard({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: iconBgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor == Colors.white
                    ? Colors.white.withOpacity(0.2)
                    : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 22, color: iconColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: iconColor == Colors.white ? Colors.white : null,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: iconColor == Colors.white
                              ? Colors.white.withOpacity(0.8)
                              : Theme.of(context).colorScheme.outline,
                        ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: iconColor == Colors.white
                  ? Colors.white.withOpacity(0.7)
                  : Theme.of(context).colorScheme.outline,
            ),
          ],
        ),
      ),
    );
  }
}