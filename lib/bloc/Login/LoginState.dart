abstract class LoginState {}

class LoginLoadingState extends LoginState {}

class LoginLoadedState extends LoginState {
  LoginLoadedState(this.map);
  final Map<String, dynamic>? map;
}

class LoginErrorState extends LoginState {
  final String error;
  LoginErrorState(this.error);
}
