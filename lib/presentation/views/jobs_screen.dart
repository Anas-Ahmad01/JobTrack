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

  final List<String> _quickFilters = [
    'All',
    'Flutter',
    'Dart',
    'Remote',
    'Mobile',
    'Software',
  ];

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
              onChanged: (value) {
                ref.read(jobsViewModelProvider.notifier).search(value);
              },
            ),
          ),

          // Quick filter chips
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _quickFilters.length,
              itemBuilder: (context, index) {
                final filter = _quickFilters[index];
                final isSelected = jobsState.searchQuery.toLowerCase() == filter.toLowerCase() ||
                    (filter == 'All' && jobsState.searchQuery.isEmpty);
                
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (filter == 'All') {
                        _searchController.clear();
                        ref.read(jobsViewModelProvider.notifier).clearSearch();
                      } else {
                        _searchController.text = filter;
                        ref.read(jobsViewModelProvider.notifier).search(filter);
                      }
                    },
                    showCheckmark: false,
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // Results count
          if (jobsState.searchQuery.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Results for "${jobsState.searchQuery}"',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                ),
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
      return EmptyStateWidget(
        title: state.searchQuery.isEmpty 
            ? 'No jobs available' 
            : 'No jobs found',
        subtitle: state.searchQuery.isEmpty
            ? 'Try again later'
            : 'Try a different search term',
        icon: state.searchQuery.isEmpty ? Icons.work_off : Icons.search_off,
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
            onSave: () => _showSaveComingSoon(context),
          );
        },
      ),
    );
  }

  void _showSaveComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Save feature coming in Chapter 6'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}