import 'package:flutter/material.dart';
import '../../../data/models/job_application.dart';

class StatusSelector extends StatelessWidget {
  final ApplicationStatus selectedStatus;
  final ValueChanged<ApplicationStatus> onSelected;

  const StatusSelector({
    super.key,
    required this.selectedStatus,
    required this.onSelected,
  });

  Color _getStatusColor(ApplicationStatus status) {
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

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: ApplicationStatus.values.map((status) {
        final isSelected = status == selectedStatus;
        return ChoiceChip(
          label: Text(status.displayName),
          selected: isSelected,
          onSelected: (_) => onSelected(status),
          selectedColor: _getStatusColor(status).withOpacity(0.15),
          labelStyle: TextStyle(
            color: isSelected ? _getStatusColor(status) : null,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        );
      }).toList(),
    );
  }
}