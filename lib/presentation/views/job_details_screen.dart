import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jobtrack/presentation/viewmodels/saved_jobs_viewmodel.dart';
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
    final savedJobsState = ref.watch(savedJobsViewModelProvider);
    
    
    final job = jobsState.jobs.firstWhere(
      (j) => j.id == jobId,
      orElse: () => Job(
        id: '',
        title: 'Job not found',
        companyName: '',
      ),
    );

    final isSaved = savedJobsState.isJobSaved(job.id);

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
            // Header with company info
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(14),
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

            // Meta info cards
            Row(
              children: [
                Expanded(
                  child: _MetaCard(
                    icon: Icons.location_on_outlined,
                    label: 'Location',
                    value: job.location ?? 'Not specified',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MetaCard(
                    icon: Icons.access_time,
                    label: 'Posted',
                    value: job.createdAt != null
                        ? _formatDate(job.createdAt!)
                        : 'Recently',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            if (job.remote == true)
              const StatusBadge(
                label: 'Remote Position',
                backgroundColor: Color(0xFFDCfce7),
                textColor: Color(0xFF166534),
              ),

            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => _toggleSave(context, ref, job),
              icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border),
              label: Text(isSaved ? 'Saved' : 'Save Job'),
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                backgroundColor: isSaved 
                  ? Theme.of(context).colorScheme.primaryContainer 
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
                foregroundColor: isSaved 
                  ? Theme.of(context).colorScheme.primary 
                  : Theme.of(context).colorScheme.onSurface,
              ),
            ),
            // Tags
            if (job.tags != null && job.tags!.isNotEmpty) ...[
              Text(
                'Tags',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
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
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                job.description ?? 'No description available.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.6,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Action buttons
            FilledButton.icon(
              onPressed: () => _saveJob(context),
              icon: const Icon(Icons.bookmark_border),
              label: const Text('Save Job'),
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
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
                    label: const Text('Apply Now'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(double.infinity, 52),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => _trackApplication(context, job),
                    icon: const Icon(Icons.assignment_add),
                    label: const Text('Track'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(double.infinity, 52),
                      backgroundColor: const Color(0xFF059669),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
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

  void _toggleSave(BuildContext context, WidgetRef ref, Job job) {
    ref.read(savedJobsViewModelProvider.notifier).toggleSaveJob(job);
  
    final isSaved = ref.read(savedJobsViewModelProvider).isJobSaved(job.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isSaved ? 'Job removed from saved' : 'Job saved!'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
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

class _MetaCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MetaCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(height: 6),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}