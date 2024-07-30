import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';


import '../../model/profile_model.dart';
import '../../services/repository/profile_repository.dart';
part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;

  ProfileBloc(this.profileRepository) : super(ProfileInitialState()) {
    on<LoadProfileEvent>((event, emit) async {
      emit(ProfileLoadingState());
      try {
        final profile = await profileRepository.fetchProfile();
        emit(ProfileLoadedState(profile: profile));
      } catch (e) {
        emit(ProfileErrorState());
      }
    });
  }
}
