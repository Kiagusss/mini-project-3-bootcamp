import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mini_project_3_bootcamp/model/profile_model.dart';
import 'package:mini_project_3_bootcamp/services/repository/profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;

  ProfileBloc(this.profileRepository) : super(ProfileInitial()) {
    on<LoadProfileEvent>((event, emit) async {
      emit(ProfileLoadingState());
      try {
        Profile profile = await profileRepository.fetchProfile();
        emit(ProfileLoadedState(profile: profile));
      } catch (e) {
        emit(ProfileErrorState(message: e.toString()));
      }
    });
  }
}
