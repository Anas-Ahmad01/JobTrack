// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$JobImpl _$$JobImplFromJson(Map<String, dynamic> json) => _$JobImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  companyName: json['companyName'] as String,
  location: json['location'] as String?,
  description: json['description'] as String?,
  url: json['url'] as String?,
  remote: json['remote'] as bool?,
  tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$JobImplToJson(_$JobImpl instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'companyName': instance.companyName,
  'location': instance.location,
  'description': instance.description,
  'url': instance.url,
  'remote': instance.remote,
  'tags': instance.tags,
  'createdAt': instance.createdAt?.toIso8601String(),
};
