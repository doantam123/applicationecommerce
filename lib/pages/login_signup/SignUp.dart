import 'package:applicationecommerce/bloc/SignUp/SignUpBloc.dart';
import 'package:applicationecommerce/view_models/Users/RegisterRequest.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

class SignupPage extends StatefulWidget {
  static String routeName = "/signup";

  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repasswordController = TextEditingController();
  bool isHiddenPassword = true;
  bool isHiddenRePassword = true;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 10,
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/register.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/register.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 120,
                    ),
                    const Text(
                      "Đăng ký",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text("Tên người dùng"),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: TextFormField(
                        controller: _usernameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Vui lòng điền tên";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffC2BABA)),
                          ),
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        ),
                      ),
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Vui lòng điền số điện thoại";
                          }
                          return null;
                        },
                        controller: _phoneNumberController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffC2BABA)),
                          ),
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Vui lòng điền mật khẩu";
                          }
                          return null;
                        },
                        controller: _passwordController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffC2BABA)),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
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
                      height: 10,
                    ),
                    const Text("Nhập lại mật khẩu"),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value != _passwordController.text) {
                            return "Mật khẩu không khớp";
                          }
                          return null;
                        },
                        controller: _repasswordController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffC2BABA)),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                          suffixIcon: InkWell(
                              onTap: _toggleRePasswordView,
                              child: Icon(
                                isHiddenRePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              )),
                        ),
                        obscureText: isHiddenRePassword,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Center(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xFF00B14F)),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          side: MaterialStateProperty.all<BorderSide>(
                              const BorderSide(color: Colors.grey, width: 1)),
                          elevation: MaterialStateProperty.all<double>(5),
                          shadowColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            var registerRequest = RegisterRequest(
                                "",
                                _usernameController.text,
                                _phoneNumberController.text,
                                _passwordController.text);
                            var result = await context
                                .read<SignUpBloc>()
                                .signUp(registerRequest);
                            if (result.isSuccessed == true) {
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Đăng ký thành công")));
                              // ignore: use_build_context_synchronously
                              Navigator.of(context).pop();
                            } else {
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(result.errorMessage!)));
                            }
                          }
                        },
                        child: const Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                          child: Text(
                            "Đăng ký",
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                          side: MaterialStateProperty.all<BorderSide>(
                            const BorderSide(color: Colors.grey, width: 1),
                          ), // Viề
                          elevation: MaterialStateProperty.all<double>(5),
                          shadowColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                          child: Text(
                            "Quay lại",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _togglePasswordView() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

  void _toggleRePasswordView() {
    setState(() {
      isHiddenRePassword = !isHiddenRePassword;
    });
  }
}
