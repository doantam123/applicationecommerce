import 'package:applicationecommerce/bloc/Profile/ProfileEvent.dart';
import 'package:applicationecommerce/bloc/Profile/ProfileState.dart';
import 'package:applicationecommerce/services/UserServices.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileLoadingState());
  final UserServices _userServices = UserServices();

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is ProfileStartedEvent) {
      yield* _mapStartedEventToState(state, event);
    }
    if (event is ProfileRefreshEvent) {
      yield* _mapRefreshEventToState(state, event);
    }
  }

  Stream<ProfileState> _mapStartedEventToState(
      ProfileState currentState, ProfileStartedEvent event) async* {
    if ((currentState is ProfileLoadedState) == false) {
      yield ProfileLoadingState();
    }

    yield await _fetchAll();
  }

  Stream<ProfileState> _mapRefreshEventToState(
      ProfileState currentState, ProfileRefreshEvent event) async* {
    yield await _fetchAll();
  }

  Future<ProfileState> _fetchAll() async {
    var user = await _userServices.getUser();
    if (user.isSuccessed == true) {
      return ProfileLoadedState(user.payLoad!);
    }
    return ProfileErrorState(user.errorMessage!);
  }
}
