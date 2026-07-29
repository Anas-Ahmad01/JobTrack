import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
class UserProfile  with _$UserProfile{
  const factory UserProfile({
    required String uid,
    required String name,
    required String email,
    required DateTime createdAt,

  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String , dynamic> json) => _$UserProfileFromJson(json);
}