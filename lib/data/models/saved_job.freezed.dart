// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'saved_job.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SavedJob _$SavedJobFromJson(Map<String, dynamic> json) {
  return _SavedJob.fromJson(json);
}

/// @nodoc
mixin _$SavedJob {
  String get id => throw _privateConstructorUsedError;
  String get jobId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get companyName => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  String? get url => throw _privateConstructorUsedError;
  DateTime get savedAt => throw _privateConstructorUsedError;

  /// Serializes this SavedJob to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SavedJob
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SavedJobCopyWith<SavedJob> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SavedJobCopyWith<$Res> {
  factory $SavedJobCopyWith(SavedJob value, $Res Function(SavedJob) then) =
      _$SavedJobCopyWithImpl<$Res, SavedJob>;
  @useResult
  $Res call({
    String id,
    String jobId,
    String userId,
    String title,
    String companyName,
    String? location,
    String? url,
    DateTime savedAt,
  });
}

/// @nodoc
class _$SavedJobCopyWithImpl<$Res, $Val extends SavedJob>
    implements $SavedJobCopyWith<$Res> {
  _$SavedJobCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SavedJob
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? jobId = null,
    Object? userId = null,
    Object? title = null,
    Object? companyName = null,
    Object? location = freezed,
    Object? url = freezed,
    Object? savedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            jobId: null == jobId
                ? _value.jobId
                : jobId // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            companyName: null == companyName
                ? _value.companyName
                : companyName // ignore: cast_nullable_to_non_nullable
                      as String,
            location: freezed == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String?,
            url: freezed == url
                ? _value.url
                : url // ignore: cast_nullable_to_non_nullable
                      as String?,
            savedAt: null == savedAt
                ? _value.savedAt
                : savedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SavedJobImplCopyWith<$Res>
    implements $SavedJobCopyWith<$Res> {
  factory _$$SavedJobImplCopyWith(
    _$SavedJobImpl value,
    $Res Function(_$SavedJobImpl) then,
  ) = __$$SavedJobImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String jobId,
    String userId,
    String title,
    String companyName,
    String? location,
    String? url,
    DateTime savedAt,
  });
}

/// @nodoc
class __$$SavedJobImplCopyWithImpl<$Res>
    extends _$SavedJobCopyWithImpl<$Res, _$SavedJobImpl>
    implements _$$SavedJobImplCopyWith<$Res> {
  __$$SavedJobImplCopyWithImpl(
    _$SavedJobImpl _value,
    $Res Function(_$SavedJobImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SavedJob
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? jobId = null,
    Object? userId = null,
    Object? title = null,
    Object? companyName = null,
    Object? location = freezed,
    Object? url = freezed,
    Object? savedAt = null,
  }) {
    return _then(
      _$SavedJobImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        jobId: null == jobId
            ? _value.jobId
            : jobId // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        companyName: null == companyName
            ? _value.companyName
            : companyName // ignore: cast_nullable_to_non_nullable
                  as String,
        location: freezed == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String?,
        url: freezed == url
            ? _value.url
            : url // ignore: cast_nullable_to_non_nullable
                  as String?,
        savedAt: null == savedAt
            ? _value.savedAt
            : savedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SavedJobImpl implements _SavedJob {
  const _$SavedJobImpl({
    required this.id,
    required this.jobId,
    required this.userId,
    required this.title,
    required this.companyName,
    this.location,
    this.url,
    required this.savedAt,
  });

  factory _$SavedJobImpl.fromJson(Map<String, dynamic> json) =>
      _$$SavedJobImplFromJson(json);

  @override
  final String id;
  @override
  final String jobId;
  @override
  final String userId;
  @override
  final String title;
  @override
  final String companyName;
  @override
  final String? location;
  @override
  final String? url;
  @override
  final DateTime savedAt;

  @override
  String toString() {
    return 'SavedJob(id: $id, jobId: $jobId, userId: $userId, title: $title, companyName: $companyName, location: $location, url: $url, savedAt: $savedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SavedJobImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.jobId, jobId) || other.jobId == jobId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.savedAt, savedAt) || other.savedAt == savedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    jobId,
    userId,
    title,
    companyName,
    location,
    url,
    savedAt,
  );

  /// Create a copy of SavedJob
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SavedJobImplCopyWith<_$SavedJobImpl> get copyWith =>
      __$$SavedJobImplCopyWithImpl<_$SavedJobImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SavedJobImplToJson(this);
  }
}

abstract class _SavedJob implements SavedJob {
  const factory _SavedJob({
    required final String id,
    required final String jobId,
    required final String userId,
    required final String title,
    required final String companyName,
    final String? location,
    final String? url,
    required final DateTime savedAt,
  }) = _$SavedJobImpl;

  factory _SavedJob.fromJson(Map<String, dynamic> json) =
      _$SavedJobImpl.fromJson;

  @override
  String get id;
  @override
  String get jobId;
  @override
  String get userId;
  @override
  String get title;
  @override
  String get companyName;
  @override
  String? get location;
  @override
  String? get url;
  @override
  DateTime get savedAt;

  /// Create a copy of SavedJob
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SavedJobImplCopyWith<_$SavedJobImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
