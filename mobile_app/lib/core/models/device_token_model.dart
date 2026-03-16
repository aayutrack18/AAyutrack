import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class DeviceTokenModel {
  final String deviceId;
  final String token;
  final String platform;
  final String appVersion;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime lastSeenAt;

  const DeviceTokenModel({
    required this.deviceId,
    required this.token,
    required this.platform,
    required this.appVersion,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.lastSeenAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'deviceId': deviceId,
      'token': token,
      'platform': platform,
      'appVersion': appVersion,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'lastSeenAt': Timestamp.fromDate(lastSeenAt),
    };
  }

  factory DeviceTokenModel.fromMap(Map<String, dynamic> map) {
    DateTime? _readDate(dynamic value) {
      if (value == null) return null;
      if (value is Timestamp) return value.toDate();
      if (value is DateTime) return value;
      return null;
    }

    return DeviceTokenModel(
      deviceId: (map['deviceId'] ?? '') as String,
      token: (map['token'] ?? '') as String,
      platform: (map['platform'] ?? 'unknown') as String,
      appVersion: (map['appVersion'] ?? '1.0.0') as String,
      isActive: (map['isActive'] ?? true) as bool,
      createdAt: _readDate(map['createdAt']) ?? DateTime.now(),
      updatedAt: _readDate(map['updatedAt']) ?? DateTime.now(),
      lastSeenAt: _readDate(map['lastSeenAt']) ?? DateTime.now(),
    );
  }

  factory DeviceTokenModel.create({
    required String token,
    required String appVersion,
  }) {
    final now = DateTime.now();
    final platform = defaultTargetPlatform.name;
    final deviceId =
        '${platform}_${token.hashCode.abs().toRadixString(16)}';

    return DeviceTokenModel(
      deviceId: deviceId,
      token: token,
      platform: platform,
      appVersion: appVersion,
      isActive: true,
      createdAt: now,
      updatedAt: now,
      lastSeenAt: now,
    );
  }

  DeviceTokenModel copyWith({
    String? deviceId,
    String? token,
    String? platform,
    String? appVersion,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastSeenAt,
  }) {
    return DeviceTokenModel(
      deviceId: deviceId ?? this.deviceId,
      token: token ?? this.token,
      platform: platform ?? this.platform,
      appVersion: appVersion ?? this.appVersion,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
    );
  }
}