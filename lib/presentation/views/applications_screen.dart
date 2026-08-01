import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/job_application.dart';
import '../common/widgets/application_card.dart';
import '../common/widgets/loading_widget.dart';
import '../common/widgets/error_widget.dart';
import '../common/widgets/empty_state_widget.dart';
import '../common/widgets/status_selector.dart';
import '../viewmodels/applications_viewmodel.dart';

class ApplicationsScreen extends ConsumerWidget {
  const ApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appsState = ref.watch(applicationsViewModelProvider);
    final filter = ref.watch(applicationFilterProvider);

    final filteredApps = appsState.getFilteredApplications(filter);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Applications'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/applications/new'),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // Filter chips
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: filter == null,
                  onSelected: (_) => ref.read(applicationFilterProvider.notifier).state = null,
                  showCheckmark: false,
                ),
                const SizedBox(width: 8),
                ...ApplicationStatus.values.map((status) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(status.displayName),
                      selected: filter == status,
                      onSelected: (_) => ref.read(applicationFilterProvider.notifier).state = status,
                      showCheckmark: false,
                    ),
                  );
                }),
              ],
            ),
          ),

          // Content
          Expanded(
            child: _buildContent(filteredApps, appsState, ref, context),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    List<JobApplication> apps,
    ApplicationsState state,
    WidgetRef ref,
    BuildContext context,
  ) {
    if (state.isLoading && state.applications.isEmpty) {
      return const LoadingWidget();
    }

    if (state.error != null && state.applications.isEmpty) {
      return ErrorMessageWidget(
        message: state.error!,
        onRetry: () {
          // Reload by reinitializing
          ref.invalidate(applicationsViewModelProvider);
        },
      );
    }

    if (state.applications.isEmpty) {
      return const EmptyStateWidget(
        title: 'No applications yet',
        subtitle: 'Track your job applications here',
        icon: Icons.assignment_outlined,
      );
    }

    if (apps.isEmpty) {
      return EmptyStateWidget(
        title: 'No applications in this status',
        subtitle: 'Try a different filter',
        icon: Icons.filter_list_off,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: apps.length,
      itemBuilder: (context, index) {
        final app = apps[index];
        return ApplicationCard(
          application: app,
          onTap: () => context.push('/applications/${app.id}'),
          onStatusChange: () => _showStatusChangeDialog(context, ref, app),
        );
      },
    );
  }

  void _showStatusChangeDialog(
    BuildContext context,
    WidgetRef ref,
    JobApplication application,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Change Status',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${application.jobTitle} at ${application.companyName}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                ),
                const SizedBox(height: 20),
                StatusSelector(
                  selectedStatus: application.status,
                  onSelected: (status) {
                    ref
                        .read(applicationsViewModelProvider.notifier)
                        .changeStatus(application.id, status);
                    Navigator.pop(context);
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Status updated to ${status.displayName}'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}