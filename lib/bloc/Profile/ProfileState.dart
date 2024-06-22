import 'package:applicationecommerce/view_models/Users/UserVM.dart';

abstract class ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileLoadedState extends ProfileState {
  final UserVM userVM;
  //final List<AddressVM> addresses;
  ProfileLoadedState(
    this.userVM,
  );
}

class ProfileErrorState extends ProfileState {
  final String error;
  ProfileErrorState(this.error);
}
