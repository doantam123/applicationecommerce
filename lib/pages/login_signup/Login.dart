// ignore: file_names
import 'dart:developer';

import 'package:applicationecommerce/app.dart';
import 'package:applicationecommerce/bloc/Home/HomeBloc.dart';
import 'package:applicationecommerce/bloc/Home/HomeEvent.dart';
import 'package:applicationecommerce/bloc/Login/LoginBloc.dart';
import 'package:applicationecommerce/bloc/Login/LoginState.dart';
import 'package:applicationecommerce/pages/login_signup/ResetPassword.dart';
import 'package:applicationecommerce/pages/login_signup/SignUp.dart';
import 'package:applicationecommerce/pages/presentation/themes.dart';
import 'package:applicationecommerce/pages/youtobe/youtube_player_custom_subtitles.dart';
import 'package:applicationecommerce/services/UserServices.dart';
import 'package:applicationecommerce/view_models/Users/LoginVM.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final UserServices _userServices = UserServices();
  bool isHiddenPassword = true;
  final _usenameTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = false;

  @override
  void dispose() {
    _usenameTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  Future<void> login(BuildContext context) async {
    if (!_isLogin) {
      _isLogin = true;
      if (_formKey.currentState!.validate()) {
        LoginVM loginVM = LoginVM(
            _usenameTextController.text, _passwordTextController.text, false);
        var loginResult = _userServices.login(loginVM);
        loginResult.then((value) {
          if (value.isSuccessed == false) {
            log(value.errorMessage!.toString());

            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(value.errorMessage!)));
          } else {
            _usenameTextController.text = "";
            _passwordTextController.text = "";
            context.read<HomeBloc>().add(HomeStartedEvent());
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) {
                return const MotherBoard();
              },
            ));
          }
        }, onError: (e) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.toString())));
        });
      }
      _isLogin = false;
    }
  }

  Widget _buildLoaedState(BuildContext context, LoginLoadedState state) {
    if (state.map != null) {
      _usenameTextController.text = state.map!["username"]! as String;
      _passwordTextController.text = state.map!["password"]! as String;
    }

    return Form(
      key: _formKey,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 150,
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'images/nen.jpg'), // Thay đổi đường dẫn của hình ảnh
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 30,
              ),
              const Text(
                "Đăng nhập",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text("Số điện thoại"),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: TextFormField(
                  controller: _usenameTextController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập số điện thoại!';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.phone,
                      color: Color(0xffFD6960),
                    ),
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffC2BABA)),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
              const Text("Mật khẩu"),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: TextFormField(
                  controller: _passwordTextController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mật khẩu';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Color(0xffFD6960),
                    ),
                    border: InputBorder.none,
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffC2BABA)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                    suffixIcon: InkWell(
                        onTap: _togglePasswordView,
                        child: Icon(isHiddenPassword
                            ? Icons.visibility_off
                            : Icons.visibility)),
                  ),
                  obscureText: isHiddenPassword,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return ResetPasswordPage();
                    }));
                  },
                  child: const Text(
                    "Quên mật khẩu?",
                    style: TextStyle(color: Color(0xffFE724C), fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(height: 70),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffFE724C), // Màu nền của nút
                  ),
                  onPressed: () {
                    login(context);
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => AppLoadingScreen()));
                  },
                  child: const Text(
                    "Đăng nhập",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Bạn chưa có tài khoản ?',
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return const SignupPage();
                        }));
                      },
                      child: const Text(
                        'Đăng ký',
                        style: TextStyle(color: Color(0xffFE724C)),
                      )),
                ],
              ),
              const SizedBox(
                height: 200,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    Icons.help_outline,
                    size: 20,
                    color: Color(0xffFE724C),
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return const YoutubePlayerCustomSubtitle();
                        }));
                      },
                      child: const Text(
                        'Hướng Dẫn Sử Dụng',
                        style:
                            TextStyle(color: Color(0xffFE724C), fontSize: 16),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _togglePasswordView() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

  Widget _buildErrorState(BuildContext context, LoginErrorState state) {
    // ignore: avoid_unnecessary_containers
    return Container(
        child: Center(
      child: Text(
        state.error,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        var rs = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Bạn có muốn thoát ứng dụng?"),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text("Có")),
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text("Không"))
                ],
              );
            });
        return rs == true;
      },
      child: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
        if (state is LoginLoadingState) {
          return CircularProgressIndicator(
              color: AppTheme.circleProgressIndicatorColor);
        } else if (state is LoginLoadedState) {
          return _buildLoaedState(context, state);
        } else if (state is LoginErrorState) {
          return _buildErrorState(context, state);
        }
        throw "Unknow state";
      }),
    );
  }
}
