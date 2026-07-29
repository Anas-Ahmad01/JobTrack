// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_job.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SavedJobImpl _$$SavedJobImplFromJson(Map<String, dynamic> json) =>
    _$SavedJobImpl(
      id: json['id'] as String,
      jobId: json['jobId'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      companyName: json['companyName'] as String,
      location: json['location'] as String?,
      url: json['url'] as String?,
      savedAt: DateTime.parse(json['savedAt'] as String),
    );

Map<String, dynamic> _$$SavedJobImplToJson(_$SavedJobImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'jobId': instance.jobId,
      'userId': instance.userId,
      'title': instance.title,
      'companyName': instance.companyName,
      'location': instance.location,
      'url': instance.url,
      'savedAt': instance.savedAt.toIso8601String(),
    };
