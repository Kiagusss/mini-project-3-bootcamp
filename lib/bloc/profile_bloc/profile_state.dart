part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  @override
  List<Object> get props => [];
}

class ProfileInitialState extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileLoadedState extends ProfileState {
  final Profile profile;

  ProfileLoadedState({required this.profile});

  @override
  List<Object> get props => [profile];
}

class ProfileErrorState extends ProfileState {}
