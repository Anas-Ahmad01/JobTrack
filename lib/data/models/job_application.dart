import 'package:freezed_annotation/freezed_annotation.dart';

part 'job_application.freezed.dart';
part 'job_application.g.dart';

enum ApplicationStatus{
  saved,
  applied,
  interview,
  offer,
  rejected,
}
extension ApplicationStatusX on ApplicationStatus {
  String get displayName {
    switch (this) {
      case ApplicationStatus.saved:
        return 'Saved';
      case ApplicationStatus.applied:
        return 'Applied';
      case ApplicationStatus.interview:
        return 'Interview';
      case ApplicationStatus.offer:
        return 'Offer';
      case ApplicationStatus.rejected:
        return 'Rejected';
    }
  }
}

@freezed
class JobApplication with _$JobApplication{
  const factory JobApplication({
    required String id,
    required String userId,
    String? jobId,
    required String jobTitle,
    required String companyName,
    String? location,
    String? jobUrl,
    @Default(ApplicationStatus.saved) ApplicationStatus status,
    DateTime? appliedAt,
    String? notes,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _JobApplication;

  factory JobApplication.fromJson(Map<String, dynamic> json) => _$JobApplicationFromJson(json);
}