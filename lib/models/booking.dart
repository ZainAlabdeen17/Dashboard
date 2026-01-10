import 'package:flutter/material.dart';

class Booking {
  final String type;
  final String id;
  final BookingAttributes attributes;
  final BookingRelationships relationships;

  Booking({
    required this.type,
    required this.id,
    required this.attributes,
    required this.relationships,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      type: json['type'] ?? '',
      id: json['id']?.toString() ?? '',
      attributes: BookingAttributes.fromJson(json['attributes'] ?? {}),
      relationships: BookingRelationships.fromJson(json['relationships'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'id': id,
      'attributes': attributes.toJson(),
      'relationships': relationships.toJson(),
    };
  }
}

class BookingAttributes {
  final String startDate;
  final String endDate;
  final int nightsCount;
  final double totalPrice;
  final String totalPriceFormatted;
  final String status;
  final String createdAt;
  final String createdAtHuman;

  BookingAttributes({
    required this.startDate,
    required this.endDate,
    required this.nightsCount,
    required this.totalPrice,
    required this.totalPriceFormatted,
    required this.status,
    required this.createdAt,
    required this.createdAtHuman,
  });

  factory BookingAttributes.fromJson(Map<String, dynamic> json) {
    return BookingAttributes(
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      nightsCount: json['nights_count'] ?? 0,
      totalPrice: json['total_price'] is double
          ? json['total_price']
          : double.tryParse(json['total_price']?.toString() ?? '0') ?? 0.0,
      totalPriceFormatted: json['total_price_formatted'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      createdAtHuman: json['created_at_human'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start_date': startDate,
      'end_date': endDate,
      'nights_count': nightsCount,
      'total_price': totalPrice,
      'total_price_formatted': totalPriceFormatted,
      'status': status,
      'created_at': createdAt,
      'created_at_human': createdAtHuman,
    };
  }

  // Helper methods for UI
  String get statusText {
    switch (status.toLowerCase()) {
      case 'approved':
        return 'Approved';
      case 'pending':
        return 'Pending';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  Color get statusColor {
    switch (status.toLowerCase()) {
      case 'approved':
        return const Color(0xFF4CAF50); // Green
      case 'pending':
        return const Color(0xFFFF9800); // Orange
      case 'completed':
        return const Color(0xFF2196F3); // Blue
      case 'cancelled':
        return const Color(0xFFF44336); // Red
      default:
        return const Color(0xFF9E9E9E); // Grey
    }
  }

  Color get statusBgColor {
    switch (status.toLowerCase()) {
      case 'approved':
        return const Color(0xFFE8F5E8); // Light green
      case 'pending':
        return const Color(0xFFFFF3E0); // Light orange
      case 'completed':
        return const Color(0xFFE3F2FD); // Light blue
      case 'cancelled':
        return const Color(0xFFFFEBEE); // Light red
      default:
        return const Color(0xFFF5F5F5); // Light grey
    }
  }
}

class BookingRelationships {
  final BookingApartment apartment;
  final BookingUser tenant;
  final BookingUser landlord;

  BookingRelationships({
    required this.apartment,
    required this.tenant,
    required this.landlord,
  });

  factory BookingRelationships.fromJson(Map<String, dynamic> json) {
    return BookingRelationships(
      apartment: BookingApartment.fromJson(json['apartment'] ?? {}),
      tenant: BookingUser.fromJson(json['tenant'] ?? {}),
      landlord: BookingUser.fromJson(json['landlord'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'apartment': apartment.toJson(),
      'tenant': tenant.toJson(),
      'landlord': landlord.toJson(),
    };
  }
}

class BookingApartment {
  final String type;
  final String id;
  final BookingApartmentAttributes attributes;

  BookingApartment({
    required this.type,
    required this.id,
    required this.attributes,
  });

  factory BookingApartment.fromJson(Map<String, dynamic> json) {
    return BookingApartment(
      type: json['type'] ?? '',
      id: json['id']?.toString() ?? '',
      attributes: BookingApartmentAttributes.fromJson(json['attributes'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'id': id,
      'attributes': attributes.toJson(),
    };
  }
}

class BookingApartmentAttributes {
  final String title;
  final String description;
  final double price;
  final String formattedPrice;
  final BookingApartmentLocation location;
  final BookingApartmentSpecs specs;
  final List<String> features;
  final String createdAtHuman;

  BookingApartmentAttributes({
    required this.title,
    required this.description,
    required this.price,
    required this.formattedPrice,
    required this.location,
    required this.specs,
    required this.features,
    required this.createdAtHuman,
  });

  factory BookingApartmentAttributes.fromJson(Map<String, dynamic> json) {
    return BookingApartmentAttributes(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] is double
          ? json['price']
          : double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      formattedPrice: json['formatted_price'] ?? '',
      location: BookingApartmentLocation.fromJson(json['location'] ?? {}),
      specs: BookingApartmentSpecs.fromJson(json['specs'] ?? {}),
      features: List<String>.from(json['features'] ?? []),
      createdAtHuman: json['created_at_human'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'formatted_price': formattedPrice,
      'location': location.toJson(),
      'specs': specs.toJson(),
      'features': features,
      'created_at_human': createdAtHuman,
    };
  }

  String get fullAddress => '${location.governorate}, ${location.city} - ${location.address}';
}

class BookingApartmentLocation {
  final String governorate;
  final String city;
  final String address;

  BookingApartmentLocation({
    required this.governorate,
    required this.city,
    required this.address,
  });

  factory BookingApartmentLocation.fromJson(Map<String, dynamic> json) {
    return BookingApartmentLocation(
      governorate: json['governorate'] ?? '',
      city: json['city'] ?? '',
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'governorate': governorate,
      'city': city,
      'address': address,
    };
  }
}

class BookingApartmentSpecs {
  final int area;
  final int rooms;
  final int floor;
  final bool hasBalcony;

  BookingApartmentSpecs({
    required this.area,
    required this.rooms,
    required this.floor,
    required this.hasBalcony,
  });

  factory BookingApartmentSpecs.fromJson(Map<String, dynamic> json) {
    return BookingApartmentSpecs(
      area: json['area'] ?? 0,
      rooms: json['rooms'] ?? 0,
      floor: json['floor'] ?? 0,
      hasBalcony: json['has_balcony'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'area': area,
      'rooms': rooms,
      'floor': floor,
      'has_balcony': hasBalcony,
    };
  }
}

class BookingUser {
  final String type;
  final String id;
  final BookingUserAttributes attributes;

  BookingUser({
    required this.type,
    required this.id,
    required this.attributes,
  });

  factory BookingUser.fromJson(Map<String, dynamic> json) {
    return BookingUser(
      type: json['type'] ?? '',
      id: json['id']?.toString() ?? '',
      attributes: BookingUserAttributes.fromJson(json['attributes'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'id': id,
      'attributes': attributes.toJson(),
    };
  }
}

class BookingUserAttributes {
  final String fullName;
  final String firstName;
  final String lastName;
  final String role;
  final BookingUserAvatar avatar;
  final String createdAt;
  final String? phoneNumber;
  final String? birthDate;
  final bool? isVerified;
  final BookingUserIdentity? identity;

  BookingUserAttributes({
    required this.fullName,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.avatar,
    required this.createdAt,
    this.phoneNumber,
    this.birthDate,
    this.isVerified,
    this.identity,
  });

  factory BookingUserAttributes.fromJson(Map<String, dynamic> json) {
    return BookingUserAttributes(
      fullName: json['full_name'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      role: json['role'] ?? '',
      avatar: BookingUserAvatar.fromJson(json['avatar'] ?? {}),
      createdAt: json['created_at'] ?? '',
      phoneNumber: json['phone_number'],
      birthDate: json['birth_date'],
      isVerified: json['is_verified'],
      identity: json['identity'] != null
          ? BookingUserIdentity.fromJson(json['identity'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'first_name': firstName,
      'last_name': lastName,
      'role': role,
      'avatar': avatar.toJson(),
      'created_at': createdAt,
      'phone_number': phoneNumber,
      'birth_date': birthDate,
      'is_verified': isVerified,
      'identity': identity?.toJson(),
    };
  }
}

class BookingUserAvatar {
  final int id;
  final String url;
  final String type;

  BookingUserAvatar({
    required this.id,
    required this.url,
    required this.type,
  });

  factory BookingUserAvatar.fromJson(Map<String, dynamic> json) {
    return BookingUserAvatar(
      id: json['id'] ?? 0,
      url: json['url'] ?? '',
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'type': type,
    };
  }
}

class BookingUserIdentity {
  final int id;
  final String url;
  final String type;

  BookingUserIdentity({
    required this.id,
    required this.url,
    required this.type,
  });

  factory BookingUserIdentity.fromJson(Map<String, dynamic> json) {
    return BookingUserIdentity(
      id: json['id'] ?? 0,
      url: json['url'] ?? '',
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'type': type,
    };
  }
}
