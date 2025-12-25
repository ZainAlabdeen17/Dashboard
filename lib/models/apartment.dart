import 'package:flutter/material.dart';

class Apartment {
  final String type;
  final String id;
  final ApartmentAttributes attributes;

  Apartment({required this.type, required this.id, required this.attributes});

  factory Apartment.fromJson(Map<String, dynamic> json) {
    return Apartment(
      type: json['type'] ?? '',
      id: json['id']?.toString() ?? '',
      attributes: ApartmentAttributes.fromJson(json['attributes'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'id': id, 'attributes': attributes.toJson()};
  }
}

class ApartmentLocation {
  final String governorate;
  final String city;
  final String address;

  ApartmentLocation({
    required this.governorate,
    required this.city,
    required this.address,
  });

  factory ApartmentLocation.fromJson(Map<String, dynamic> json) {
    return ApartmentLocation(
      governorate: json['governorate'] ?? '',
      city: json['city'] ?? '',
      address: json['address'] ?? '',
    );
  }

  String get fullAddress => '$governorate, $city - $address';
}

class ApartmentSpecs {
  final int area;
  final int rooms;
  final int floor;
  final bool hasBalcony;

  ApartmentSpecs({
    required this.area,
    required this.rooms,
    required this.floor,
    required this.hasBalcony,
  });

  factory ApartmentSpecs.fromJson(Map<String, dynamic> json) {
    return ApartmentSpecs(
      area: json['area'] ?? 0,
      rooms: json['rooms'] ?? 0,
      floor: json['floor'] ?? 0,
      hasBalcony: json['has_balcony'] ?? false,
    );
  }
}

class ApartmentGallery {
  final int id;
  final String url;
  final String type;

  ApartmentGallery({required this.id, required this.url, required this.type});

  factory ApartmentGallery.fromJson(Map<String, dynamic> json) {
    return ApartmentGallery(
      id: json['id'] ?? 0,
      url: json['url'] ?? '',
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'url': url, 'type': type};
  }
}

class ApartmentAttributes {
  final String title;
  final String description;
  final double price;
  final String formattedPrice;
  final ApartmentLocation location;
  final ApartmentSpecs specs;
  final List<String> features;
  final String createdAtHuman;
  final List<ApartmentGallery> gallery;

  ApartmentAttributes({
    required this.title,
    required this.description,
    required this.price,
    required this.formattedPrice,
    required this.location,
    required this.specs,
    required this.features,
    required this.createdAtHuman,
    required this.gallery,
  });

  factory ApartmentAttributes.fromJson(Map<String, dynamic> json) {
    return ApartmentAttributes(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] is double
          ? json['price']
          : double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      formattedPrice: json['formatted_price'] ?? '',
      location: ApartmentLocation.fromJson(json['location'] ?? {}),
      specs: ApartmentSpecs.fromJson(json['specs'] ?? {}),
      features: List<String>.from(json['features'] ?? []),
      createdAtHuman: json['created_at_human'] ?? '',
      gallery:
          (json['gallery'] as List<dynamic>?)
              ?.map((item) => ApartmentGallery.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'formatted_price': formattedPrice,
      'location': location,
      'specs': specs,
      'features': features,
      'created_at_human': createdAtHuman,
      'gallery': gallery.map((item) => item.toJson()).toList(),
    };
  }

  // For backward compatibility with the data grid
  String get name => title;
  String get rooms => '${specs.rooms} rooms';
  String get bathrooms => specs.hasBalcony ? 'Has balcony' : 'No balcony';
  String get status => 'Available'; // Default status since it's not in the API
  String get occupancyRate => 'N/A'; // Not available in API
  String get createdAt => createdAtHuman;
  String get imageUrl => gallery.isNotEmpty ? gallery.first.url : '';

  Color get statusColor => Colors.green; // Default to available

  Color get imageColor => Colors.blue.shade200; // Default color
}
