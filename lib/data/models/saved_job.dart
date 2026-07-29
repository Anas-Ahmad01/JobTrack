import 'package:freezed_annotation/freezed_annotation.dart';

part 'saved_job.freezed.dart';
part 'saved_job.g.dart';

@freezed 
class SavedJob with _$SavedJob{
  const factory SavedJob({
    required String id,
    required String jobId,
    required String userId,
    required String title,
    required String companyName,
    String? location,
    String? url,
    required DateTime savedAt,
  }) = _SavedJob;

  factory SavedJob.fromJson(Map<String , dynamic> json) => _$SavedJobFromJson(json);
}