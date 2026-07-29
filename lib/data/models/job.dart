import 'package:freezed_annotation/freezed_annotation.dart';

part 'job.freezed.dart';
part 'job.g.dart';

@freezed 
class Job with _$Job{
  const factory Job({
    required String id,
    required String title,
    required String companyName,
    String? location,
    String? description,
    String? url,
    bool? remote,
    List<String>? tags,
    DateTime? createdAt,
  }) = _Job;

  factory Job.fromJson(Map<String , dynamic> json) => _$JobFromJson(json);
}