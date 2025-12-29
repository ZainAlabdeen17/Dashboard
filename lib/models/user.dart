import 'dart:convert';

import 'package:dashboard/core/manager/types_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final String type;
  final String id;
  final UserAttributes attributes;
  User({required this.type, required this.id, required this.attributes});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      type: json['type'] ?? '',
      id: json['id']?.toString() ?? '',
      attributes: UserAttributes.fromJson(json['attributes'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'id': id, 'attributes': attributes.toJson()};
  }

  Future<void> saveToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userJson = jsonEncode(toJson());
    await prefs.setString('user', userJson);
  }

  static Future<User?> getUserFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user');
    if (userJson != null) {
      Map<String, dynamic> userMap = jsonDecode(userJson);
      return User.fromJson(userMap);
    }
    return null;
  }

  static Future<void> removFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
  }
}

class UserAttributes {
  final String fullName;
  final String firstName;
  final String lastName;
  final String role;
  final String avatarUrl;
  final String createdAt;
  final String phoneNumber;
  final String birthDate;
  final bool isVerified;
  final String identityUrl;

  UserAttributes({
    required this.fullName,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.avatarUrl,
    required this.createdAt,
    required this.phoneNumber,
    required this.birthDate,
    required this.isVerified,
    required this.identityUrl,
  });

  factory UserAttributes.fromJson(Map<String, dynamic> json) {
    return UserAttributes(
      fullName: TypeManager.stringT(json['full_name']),
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      role: json['role'] ?? '',
      avatarUrl: json['avatar_url'] ?? '',
      createdAt: json['created_at'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      birthDate: json['birth_date'] ?? '',
      isVerified: json['is_verified'] ?? false,
      identityUrl: json['identity_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'first_name': firstName,
      'last_name': lastName,
      'role': role,
      'avatar_url': avatarUrl,
      'created_at': createdAt,
      'phone_number': phoneNumber,
      'birth_date': birthDate,
      'is_verified': isVerified,
      'identity_url': identityUrl,
    };
  }
}
