import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/job_application.dart';
import '../common/widgets/status_badge.dart';
import '../viewmodels/applications_viewmodel.dart';

class ApplicationDetailsScreen extends ConsumerWidget {
  final String applicationId;

  const ApplicationDetailsScreen({super.key, required this.applicationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appsState = ref.watch(applicationsViewModelProvider);
    final application = appsState.applications.firstWhere(
      (a) => a.id == applicationId,
      orElse: () => JobApplication(
        id: '',
        userId: '',
        jobTitle: 'Not found',
        companyName: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    if (application.id.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Application Details')),
        body: const Center(child: Text('Application not found')),
      );
    }

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Application Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmDelete(context, ref),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status badge
            StatusBadge(
              label: application.status.displayName,
              backgroundColor: _getStatusColor(application.status),
              textColor: _getStatusTextColor(application.status),
            ),
            const SizedBox(height: 20),

            // Job info
            Text(
              application.jobTitle,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              application.companyName,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
            const SizedBox(height: 24),

            // Details
            _DetailRow(
              icon: Icons.location_on_outlined,
              label: 'Location',
              value: application.location ?? 'Not specified',
            ),
            _DetailRow(
              icon: Icons.calendar_today_outlined,
              label: 'Applied On',
              value: application.appliedAt != null
                  ? _formatDate(application.appliedAt!)
                  : 'Not specified',
            ),
            _DetailRow(
              icon: Icons.update_outlined,
              label: 'Last Updated',
              value: _formatDate(application.updatedAt),
            ),
            if (application.jobUrl != null) ...[
              const SizedBox(height: 8),
              InkWell(
                onTap: () => _launchUrl(application.jobUrl!),
                child: _DetailRow(
                  icon: Icons.link,
                  label: 'Job URL',
                  value: 'Open Link →',
                  valueColor: theme.colorScheme.primary,
                ),
              ),
            ],
            const SizedBox(height: 24),

            // Notes
            if (application.notes != null) ...[
              Text(
                'Notes',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  application.notes!,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Actions
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => _showStatusChange(context, ref, application),
                    icon: const Icon(Icons.edit),
                    label: const Text('Change Status'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.saved:
        return const Color(0xFFF1F5F9);
      case ApplicationStatus.applied:
        return const Color(0xFFDBEAFE);
      case ApplicationStatus.interview:
        return const Color(0xFFFEF3C7);
      case ApplicationStatus.offer:
        return const Color(0xFFDCFCE7);
      case ApplicationStatus.rejected:
        return const Color(0xFFFEE2E2);
    }
  }

  Color _getStatusTextColor(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.saved:
        return const Color(0xFF64748B);
      case ApplicationStatus.applied:
        return const Color(0xFF2563EB);
      case ApplicationStatus.interview:
        return const Color(0xFFD97706);
      case ApplicationStatus.offer:
        return const Color(0xFF166534);
      case ApplicationStatus.rejected:
        return const Color(0xFFDC2626);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showStatusChange(
    BuildContext context,
    WidgetRef ref,
    JobApplication application,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
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
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ApplicationStatus.values.map((status) {
                  return ChoiceChip(
                    label: Text(status.displayName),
                    selected: status == application.status,
                    onSelected: (_) {
                      ref
                          .read(applicationsViewModelProvider.notifier)
                          .changeStatus(application.id, status);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Application?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              ref
                  .read(applicationsViewModelProvider.notifier)
                  .deleteApplication(applicationId);
              Navigator.pop(context);
              context.pop();
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.outline),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: valueColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}