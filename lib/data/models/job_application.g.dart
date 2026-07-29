// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_application.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$JobApplicationImpl _$$JobApplicationImplFromJson(Map<String, dynamic> json) =>
    _$JobApplicationImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      jobId: json['jobId'] as String?,
      jobTitle: json['jobTitle'] as String,
      companyName: json['companyName'] as String,
      location: json['location'] as String?,
      jobUrl: json['jobUrl'] as String?,
      status:
          $enumDecodeNullable(_$ApplicationStatusEnumMap, json['status']) ??
          ApplicationStatus.saved,
      appliedAt: json['appliedAt'] == null
          ? null
          : DateTime.parse(json['appliedAt'] as String),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$JobApplicationImplToJson(
  _$JobApplicationImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'jobId': instance.jobId,
  'jobTitle': instance.jobTitle,
  'companyName': instance.companyName,
  'location': instance.location,
  'jobUrl': instance.jobUrl,
  'status': _$ApplicationStatusEnumMap[instance.status]!,
  'appliedAt': instance.appliedAt?.toIso8601String(),
  'notes': instance.notes,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

const _$ApplicationStatusEnumMap = {
  ApplicationStatus.saved: 'saved',
  ApplicationStatus.applied: 'applied',
  ApplicationStatus.interview: 'interview',
  ApplicationStatus.offer: 'offer',
  ApplicationStatus.rejected: 'rejected',
};
