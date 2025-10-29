// lib/features/customer/presentation/bloc/profile/profile_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/features/customer/bloc/profile/profile_event.dart';
import 'package:myapp/features/customer/bloc/profile/profile_state.dart';
import 'package:myapp/features/customer/domain/entities/user_profile.dart';


class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(const ProfileState()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<UpdateProfileField>(_onUpdateProfileField);
    on<AddAddress>(_onAddAddress);
    on<UpdateAddress>(_onUpdateAddress);
    on<DeleteAddress>(_onDeleteAddress);
    on<SetDefaultAddress>(_onSetDefaultAddress);
    on<ChangePassword>(_onChangePassword);
    on<LogOut>(_onLogOut);
  }

  void _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(status: ProfileStatus.loading));

    try {
      await Future.delayed(const Duration(milliseconds: 800));
      
      final profile = _getMockProfile();
      
      emit(state.copyWith(
        status: ProfileStatus.loaded,
        profile: profile,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onUpdateProfile(UpdateProfile event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(status: ProfileStatus.updating));

    try {
      await Future.delayed(const Duration(milliseconds: 1000));
      
      emit(state.copyWith(
        status: ProfileStatus.loaded,
        profile: event.profile,
        successMessage: 'Profile updated successfully',
      ));
      
      await Future.delayed(const Duration(milliseconds: 100));
      emit(state.copyWith(successMessage: null));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: 'Failed to update profile: ${e.toString()}',
      ));
    }
  }

  void _onUpdateProfileField(
    UpdateProfileField event,
    Emitter<ProfileState> emit,
  ) async {
    if (state.profile == null) return;

    emit(state.copyWith(status: ProfileStatus.updating));

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      UserProfile updatedProfile = state.profile!;
      
      switch (event.field) {
        case 'name':
          updatedProfile = updatedProfile.copyWith(name: event.value);
          break;
        case 'email':
          updatedProfile = updatedProfile.copyWith(email: event.value);
          break;
        case 'phone':
          updatedProfile = updatedProfile.copyWith(phone: event.value);
          break;
        case 'profileImage':
          updatedProfile = updatedProfile.copyWith(profileImage: event.value);
          break;
      }
      
      emit(state.copyWith(
        status: ProfileStatus.loaded,
        profile: updatedProfile,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: 'Failed to update ${event.field}',
      ));
    }
  }

  void _onAddAddress(AddAddress event, Emitter<ProfileState> emit) async {
    if (state.profile == null) return;

    emit(state.copyWith(status: ProfileStatus.updating));

    try {
      await Future.delayed(const Duration(milliseconds: 800));
      
      final addresses = List<Address>.from(state.profile!.addresses)
        ..add(event.address);
      
      final updatedProfile = state.profile!.copyWith(addresses: addresses);
      
      emit(state.copyWith(
        status: ProfileStatus.loaded,
        profile: updatedProfile,
        successMessage: 'Address added successfully',
      ));
      
      await Future.delayed(const Duration(milliseconds: 100));
      emit(state.copyWith(successMessage: null));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: 'Failed to add address',
      ));
    }
  }

  void _onUpdateAddress(UpdateAddress event, Emitter<ProfileState> emit) async {
    if (state.profile == null) return;

    emit(state.copyWith(status: ProfileStatus.updating));

    try {
      await Future.delayed(const Duration(milliseconds: 800));
      
      final addresses = state.profile!.addresses.map((address) {
        if (address.id == event.address.id) {
          return event.address;
        }
        return address;
      }).toList();
      
      final updatedProfile = state.profile!.copyWith(addresses: addresses);
      
      emit(state.copyWith(
        status: ProfileStatus.loaded,
        profile: updatedProfile,
        successMessage: 'Address updated successfully',
      ));
      
      await Future.delayed(const Duration(milliseconds: 100));
      emit(state.copyWith(successMessage: null));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: 'Failed to update address',
      ));
    }
  }

  void _onDeleteAddress(DeleteAddress event, Emitter<ProfileState> emit) async {
    if (state.profile == null) return;

    emit(state.copyWith(status: ProfileStatus.updating));

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      final addresses = state.profile!.addresses
          .where((address) => address.id != event.addressId)
          .toList();
      
      final updatedProfile = state.profile!.copyWith(addresses: addresses);
      
      emit(state.copyWith(
        status: ProfileStatus.loaded,
        profile: updatedProfile,
        successMessage: 'Address deleted successfully',
      ));
      
      await Future.delayed(const Duration(milliseconds: 100));
      emit(state.copyWith(successMessage: null));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: 'Failed to delete address',
      ));
    }
  }

  void _onSetDefaultAddress(
    SetDefaultAddress event,
    Emitter<ProfileState> emit,
  ) async {
    if (state.profile == null) return;

    try {
      final addresses = state.profile!.addresses.map((address) {
        return address.copyWith(isDefault: address.id == event.addressId);
      }).toList();
      
      final updatedProfile = state.profile!.copyWith(addresses: addresses);
      
      emit(state.copyWith(profile: updatedProfile));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: 'Failed to set default address',
      ));
    }
  }

  void _onChangePassword(
    ChangePassword event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.updating));

    try {
      await Future.delayed(const Duration(milliseconds: 1000));
      
      // Validate current password
      if (event.currentPassword != 'password123') {
        throw Exception('Current password is incorrect');
      }
      
      emit(state.copyWith(
        status: ProfileStatus.loaded,
        successMessage: 'Password changed successfully',
      ));
      
      await Future.delayed(const Duration(milliseconds: 100));
      emit(state.copyWith(successMessage: null));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  void _onLogOut(LogOut event, Emitter<ProfileState> emit) {
    emit(const ProfileState());
  }

  UserProfile _getMockProfile() {
    return UserProfile(
      id: 'user_001',
      name: 'John Doe',
      email: 'john.doe@example.com',
      phone: '+1 234 567 8900',
      profileImage: null,
      addresses: [
        Address(
          id: 'addr_1',
          label: 'Home',
          street: '123 Main St',
          city: 'New York',
          state: 'NY',
          zipCode: '10001',
          country: 'USA',
          isDefault: true,
        ),
        Address(
          id: 'addr_2',
          label: 'Office',
          street: '456 Business Ave',
          city: 'New York',
          state: 'NY',
          zipCode: '10002',
          country: 'USA',
          isDefault: false,
        ),
      ],
      memberSince: DateTime(2023, 1, 15),
    );
  }
}
