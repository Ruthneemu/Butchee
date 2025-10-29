import 'package:equatable/equatable.dart';
import 'package:myapp/features/customer/domain/entities/user_profile.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final UserProfile profile;

  const UpdateProfile(this.profile);

  @override
  List<Object?> get props => [profile];
}

class UpdateProfileField extends ProfileEvent {
  final String field;
  final dynamic value;

  const UpdateProfileField({required this.field, required this.value});

  @override
  List<Object?> get props => [field, value];
}

class AddAddress extends ProfileEvent {
  final Address address;

  const AddAddress(this.address);

  @override
  List<Object?> get props => [address];
}

class UpdateAddress extends ProfileEvent {
  final Address address;

  const UpdateAddress(this.address);

  @override
  List<Object?> get props => [address];
}

class DeleteAddress extends ProfileEvent {
  final String addressId;

  const DeleteAddress(this.addressId);

  @override
  List<Object?> get props => [addressId];
}

class SetDefaultAddress extends ProfileEvent {
  final String addressId;

  const SetDefaultAddress(this.addressId);

  @override
  List<Object?> get props => [addressId];
}

class ChangePassword extends ProfileEvent {
  final String currentPassword;
  final String newPassword;

  const ChangePassword({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [currentPassword, newPassword];
}

class LogOut extends ProfileEvent {}
