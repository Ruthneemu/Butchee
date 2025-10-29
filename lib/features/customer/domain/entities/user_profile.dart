import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? profileImage;
  final List<Address> addresses;
  final DateTime memberSince;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profileImage,
    required this.addresses,
    required this.memberSince,
  });

  Address? get defaultAddress =>
      addresses.where((addr) => addr.isDefault).firstOrNull;

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? profileImage,
    List<Address>? addresses,
    DateTime? memberSince,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      addresses: addresses ?? this.addresses,
      memberSince: memberSince ?? this.memberSince,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phone,
        profileImage,
        addresses,
        memberSince,
      ];
}

class Address extends Equatable {
  final String id;
  final String label;
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final bool isDefault;

  const Address({
    required this.id,
    required this.label,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    this.isDefault = false,
  });

  String get fullAddress => '$street, $city, $state $zipCode, $country';

  Address copyWith({
    String? id,
    String? label,
    String? street,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    bool? isDefault,
  }) {
    return Address(
      id: id ?? this.id,
      label: label ?? this.label,
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      country: country ?? this.country,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  List<Object?> get props => [
        id,
        label,
        street,
        city,
        state,
        zipCode,
        country,
        isDefault,
      ];
}