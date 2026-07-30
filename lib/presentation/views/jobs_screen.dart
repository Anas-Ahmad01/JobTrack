import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../common/widgets/job_card.dart';
import '../common/widgets/loading_widget.dart';
import '../common/widgets/error_widget.dart';
import '../common/widgets/empty_state_widget.dart';
import '../viewmodels/jobs_viewmodel.dart';

class JobsScreen extends ConsumerStatefulWidget {
  const JobsScreen({super.key});

  @override
  ConsumerState<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends ConsumerState<JobsScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final jobsState = ref.watch(jobsViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Jobs'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search jobs...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: jobsState.searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(jobsViewModelProvider.notifier).clearSearch();
                        },
                      )
                    : null,
              ),
              onSubmitted: (value) {
                ref.read(jobsViewModelProvider.notifier).search(value);
              },
            ),
          ),

          // Content
          Expanded(
            child: _buildContent(jobsState),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(JobsState state) {
    if (state.isLoading && state.jobs.isEmpty) {
      return const LoadingWidget();
    }

    if (state.error != null && state.jobs.isEmpty) {
      return ErrorMessageWidget(
        message: state.error!,
        onRetry: () => ref.read(jobsViewModelProvider.notifier).loadJobs(),
      );
    }

    if (state.jobs.isEmpty) {
      return const EmptyStateWidget(
        title: 'No jobs found',
        subtitle: 'Try a different search term',
        icon: Icons.search_off,
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(jobsViewModelProvider.notifier).loadJobs(),
      child: ListView.builder(
        itemCount: state.jobs.length,
        itemBuilder: (context, index) {
          final job = state.jobs[index];
          return JobCard(
            job: job,
            onTap: () => context.push('/jobs/${job.id}'),
            onSave: () {
              // Will implement in Chapter 6
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Save feature '),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          );
        },
      ),
    );
  }
}