import 'package:applicationecommerce/bloc/Login/LoginEvent.dart';
import 'package:applicationecommerce/bloc/Login/LoginState.dart';
import 'package:applicationecommerce/services/UserServices.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginLoadingState());
  final UserServices _userServices = UserServices();
  Stream<LoginState> _mapStartedEventToState(LoginEvent event) async* {
    yield LoginLoadingState();

    yield await _fetchAll();
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginStartedEvent) {
      yield* _mapStartedEventToState(event);
    }
  }

  Future<LoginState> _fetchAll() async {
    var cache = await _userServices.getUserAccountFromCache();
    if (cache.isSuccessed == true) {
      return LoginLoadedState(cache.payLoad!);
    }
    return LoginLoadedState(null);
  }
}
