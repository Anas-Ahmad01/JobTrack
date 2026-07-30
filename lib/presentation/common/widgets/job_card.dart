import 'package:flutter/material.dart';
import '../../../data/models/job.dart';
import 'status_badge.dart';

class JobCard extends StatelessWidget {
  final Job job;
  final VoidCallback? onTap;
  final VoidCallback? onSave;
  final bool isSaved;

  const JobCard({
    super.key,
    required this.job,
    this.onTap,
    this.onSave,
    this.isSaved = false,
  });

  String _getTimeAgo(DateTime? date) {
    if (date == null) return 'Recently';
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) return '${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago';
    if (diff.inHours > 0) return '${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago';
    return 'Just now';
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
                          job.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          job.companyName,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (onSave != null)
                    IconButton(
                      onPressed: onSave,
                      icon: Icon(
                        isSaved ? Icons.bookmark : Icons.bookmark_border,
                        color: isSaved ? theme.colorScheme.primary : null,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 14,
                    color: theme.colorScheme.outline,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    job.location ?? 'Location not specified',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  if (job.remote == true) ...[
                    const SizedBox(width: 8),
                    const StatusBadge(
                      label: 'Remote',
                      backgroundColor: Color(0xFFDCfce7),
                      textColor: Color(0xFF166534),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  ...(job.tags ?? []).take(3).map(
                        (tag) => StatusBadge(
                          label: tag,
                          backgroundColor: theme.colorScheme.surfaceContainerHighest,
                          textColor: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Posted ${_getTimeAgo(job.createdAt)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}