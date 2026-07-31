import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../common/widgets/loading_widget.dart';
import '../common/widgets/error_widget.dart';
import '../common/widgets/empty_state_widget.dart';
import '../viewmodels/saved_jobs_viewmodel.dart';

class SavedJobsScreen extends ConsumerWidget {
  const SavedJobsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedJobsState = ref.watch(savedJobsViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Jobs'),
        centerTitle: true,
      ),
      body: _buildContent(savedJobsState, ref),
    );
  }

  Widget _buildContent(SavedJobsState state, WidgetRef ref) {
    if (state.isLoading && state.savedJobs.isEmpty) {
      return const LoadingWidget();
    }

    if (state.error != null && state.savedJobs.isEmpty) {
      return ErrorMessageWidget(
        message: state.error!,
        onRetry: () {
          // Trigger reload by re-watching provider
        },
      );
    }

    if (state.savedJobs.isEmpty) {
      return const EmptyStateWidget(
        title: 'No saved jobs yet',
        subtitle: 'Save jobs you are interested in',
        icon: Icons.bookmark_border,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: state.savedJobs.length,
      itemBuilder: (context, index) {
        final savedJob = state.savedJobs[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          savedJob.companyName.isNotEmpty
                              ? savedJob.companyName[0].toUpperCase()
                              : '?',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            savedJob.title,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            savedJob.companyName,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (savedJob.location != null)
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        savedJob.location!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                      ),
                    ],
                  ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: savedJob.url != null
                          ? () => _launchUrl(savedJob.url!)
                          : null,
                      icon: const Icon(Icons.open_in_new, size: 18),
                      label: const Text('Open'),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () {
                        ref
                            .read(savedJobsViewModelProvider.notifier)
                            .removeSavedJob(savedJob.id);
                      },
                      icon: Icon(
                        Icons.delete_outline,
                        size: 18,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      label: Text(
                        'Remove',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}