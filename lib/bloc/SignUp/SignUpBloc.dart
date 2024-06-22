import 'package:applicationecommerce/bloc/SignUp/SignUpEvent.dart';
import 'package:applicationecommerce/bloc/SignUp/SignUpState.dart';
import 'package:applicationecommerce/services/UserServices.dart';
import 'package:applicationecommerce/view_models/Users/RegisterRequest.dart';
import 'package:applicationecommerce/view_models/Users/ResetPasswordVM.dart';
import 'package:applicationecommerce/view_models/Users/UserEditVM.dart';
import 'package:applicationecommerce/view_models/commons/ApiResult.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpLoadedState());
  final UserServices _userServices = UserServices();

  @override
  Stream<SignUpState> mapEventToState(SignUpEvent event) async* {
    if (event is SignUpStartedEvent) {
      yield SignUpLoadedState();
    }
  }

  Future<ApiResult<bool>> signUp(RegisterRequest registerRequest) async {
    return _userServices.register(registerRequest);
  }

  Future<ApiResult<bool>> resetPassword(ResetPasswordVM registerRequest) async {
    return _userServices.resetPassword(registerRequest);
  }

  Future<ApiResult<bool>> changePassword(
      String oldPassword, String newPassword) async {
    return _userServices.changePassword(oldPassword, newPassword);
  }

  Future<ApiResult<UserEditVM>> changeName(String newName) async {
    return _userServices.changeName(newName);
  }
}
