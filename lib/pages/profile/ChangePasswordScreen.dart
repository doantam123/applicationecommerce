import 'package:applicationecommerce/bloc/SignUp/SignUpBloc.dart';
import 'package:applicationecommerce/pages/login_signup/Login.dart';
import 'package:applicationecommerce/services/UserServices.dart';
import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Đổi mật khẩu',
          style: Theme.of(context).textTheme.displayLarge,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: const Body(),
    );
  }
}

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isHiddendenOldPassword = true;
  bool isHiddendenNewPassword = true;
  bool isHiddendenConfirmPassword = true;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  void _toggleOldPasswordView() {
    isHiddendenOldPassword = !isHiddendenOldPassword;
    setState(() {});
  }

  void _toggleNewPasswordView() {
    isHiddendenNewPassword = !isHiddendenNewPassword;
    setState(() {});
  }

  void _toggleConfirmPasswordView() {
    isHiddendenConfirmPassword = !isHiddendenConfirmPassword;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu cũ',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: InkWell(
                      onTap: _toggleOldPasswordView,
                      child: const Icon(Icons.visibility),
                    ),
                  ),
                  obscureText: isHiddendenOldPassword,
                  controller: _oldPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Vui lòng nhập mật khẩu hiện tại";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu mới',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: InkWell(
                      onTap: _toggleNewPasswordView,
                      child: const Icon(Icons.visibility),
                    ),
                  ),
                  obscureText: isHiddendenNewPassword,
                  controller: _newPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Vui lòng nhập mật khẩu mới";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nhập lại mật khẩu mới',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: InkWell(
                      onTap: _toggleConfirmPasswordView,
                      child: const Icon(Icons.visibility),
                    ),
                  ),
                  obscureText: isHiddendenConfirmPassword,
                  controller: _confirmNewPasswordController,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value != _newPasswordController.text) {
                      return "Mật khẩu nhập lại không khớp";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      var result = await context
                          .read<SignUpBloc>()
                          .changePassword(_oldPasswordController.text,
                              _newPasswordController.text);
                      if (result.isSuccessed == true) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Thay đổi mật khẩu thành công!"),
                          ),
                        );
                        UserServices userServices = UserServices();
                        await userServices.logout();
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) {
                            return const LoginPage();
                          }),
                          (Route<dynamic> route) => false,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(result.errorMessage!)),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Xác nhận',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
