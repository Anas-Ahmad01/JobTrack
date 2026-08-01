import 'package:flutter/material.dart';
import '../../../data/models/job_application.dart';
import 'status_badge.dart';

class ApplicationCard extends StatelessWidget {
  final JobApplication application;
  final VoidCallback? onTap;
  final VoidCallback? onStatusChange;

  const ApplicationCard({
    super.key,
    required this.application,
    this.onTap,
    this.onStatusChange,
  });

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

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          application.jobTitle,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          application.companyName,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  StatusBadge(
                    label: application.status.displayName,
                    backgroundColor: _getStatusColor(application.status),
                    textColor: _getStatusTextColor(application.status),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 14,
                    color: theme.colorScheme.outline,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Applied: ${_formatDate(application.appliedAt)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ],
              ),
              if (application.location != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: theme.colorScheme.outline,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      application.location!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ],
              if (onStatusChange != null) ...[
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: onStatusChange,
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('Change Status'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}