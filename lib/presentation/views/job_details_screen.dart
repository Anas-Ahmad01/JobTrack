import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/job.dart';
import '../common/widgets/status_badge.dart';
import '../viewmodels/jobs_viewmodel.dart';

class JobDetailsScreen extends ConsumerWidget {
  final String jobId;

  const JobDetailsScreen({super.key, required this.jobId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobsState = ref.watch(jobsViewModelProvider);
    final job = jobsState.jobs.firstWhere(
      (j) => j.id == jobId,
      orElse: () => Job(
        id: '',
        title: 'Job not found',
        companyName: '',
      ),
    );

    if (job.id.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Job Details')),
        body: const Center(child: Text('Job not found')),
      );
    }

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company logo placeholder
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      job.companyName.isNotEmpty
                          ? job.companyName[0].toUpperCase()
                          : '?',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        job.companyName,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Meta info
            Row(
              children: [
                Icon(Icons.location_on_outlined,
                    size: 18, color: theme.colorScheme.outline),
                const SizedBox(width: 6),
                Text(
                  job.location ?? 'Location not specified',
                  style: theme.textTheme.bodyMedium,
                ),
                if (job.remote == true) ...[
                  const SizedBox(width: 16),
                  const StatusBadge(
                    label: 'Remote',
                    backgroundColor: Color(0xFFDCfce7),
                    textColor: Color(0xFF166534),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time,
                    size: 18, color: theme.colorScheme.outline),
                const SizedBox(width: 6),
                Text(
                  job.createdAt != null
                      ? 'Posted on ${_formatDate(job.createdAt!)}'
                      : 'Recently posted',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Tags
            if (job.tags != null && job.tags!.isNotEmpty) ...[
              Text(
                'Tags',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: job.tags!
                    .map((tag) => StatusBadge(
                          label: tag,
                          backgroundColor:
                              theme.colorScheme.surfaceContainerHighest,
                          textColor: theme.colorScheme.onSurfaceVariant,
                        ))
                    .toList(),
              ),
              const SizedBox(height: 24),
            ],

            // Description
            Text(
              'Description',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              job.description ?? 'No description available.',
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.6,
              ),
            ),
            const SizedBox(height: 32),

            // Action buttons
            FilledButton.icon(
              onPressed: () => _saveJob(context),
              icon: const Icon(Icons.bookmark_border),
              label: const Text('Save Job'),
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                foregroundColor: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: job.url != null ? () => _launchUrl(job.url!) : null,
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('Apply'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => _trackApplication(context, job),
                    icon: const Icon(Icons.assignment),
                    label: const Text('Track'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: const Color(0xFF059669),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _saveJob(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Save feature coming in Chapter 6'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _trackApplication(BuildContext context, Job job) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Track feature coming in Chapter 7'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}