// //import 'dart:ffi';

// // ignore_for_file: use_key_in_widget_constructors, unnecessary_new

// import 'package:applicationecommerce/bloc/SignUp/SignUpBloc.dart';
// import 'package:applicationecommerce/view_models/Users/ResetPasswordVM.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';

// class ResetPasswordPage extends StatefulWidget {
//   @override
//   // ignore: library_private_types_in_public_api
//   _ResetPasswordPageState createState() => _ResetPasswordPageState();
// }

// class _ResetPasswordPageState extends State<ResetPasswordPage> {
//   TextEditingController _phoneNumberController = TextEditingController();
//   TextEditingController _passwordController = TextEditingController();
//   //TextEditingController _confirmPasswordController = TextEditingController();

//   final _formKey = GlobalKey<FormState>();

//   @override
//   void dispose() {
//     _phoneNumberController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//         resizeToAvoidBottomInset: false,
//         body: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Container(
//                 child: Stack(
//                   children: <Widget>[
//                     Container(
//                       padding: EdgeInsets.fromLTRB(15.0, 70.0, 0.0, 0.0),
//                       // ignore: prefer_const_constructors
//                       child: Text(
//                         'Khôi phục tài khoản',
//                         style: TextStyle(
//                             fontSize: 30.0,
//                             fontWeight: FontWeight.bold,
//                             fontFamily: 'Montserrat'),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                   padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       children: <Widget>[
//                         SizedBox(height: 10.0),
//                         TextFormField(
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return "Vui lòng điền số điện thoại";
//                             }
//                             return null;
//                           },
//                           controller: _phoneNumberController,
//                           keyboardType: TextInputType.phone,
//                           decoration: InputDecoration(
//                             labelText: 'Số điện thoại',
//                             labelStyle: Theme.of(context).textTheme.bodyText1,
//                           ),
//                         ),
//                         SizedBox(height: 10.0),
//                         TextFormField(
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return "Vui lòng điền mật khẩu";
//                             }
//                             return null;
//                           },
//                           controller: _passwordController,
//                           obscureText: true,
//                           decoration: InputDecoration(
//                             labelText: 'Mật khẩu mới',
//                             labelStyle: Theme.of(context).textTheme.bodyText1,
//                           ),
//                         ),
//                         SizedBox(height: 10.0),
//                         TextFormField(
//                           validator: (a) {
//                             if (a == null ||
//                                 a.isEmpty ||
//                                 a != _passwordController.text) {
//                               return "Mật khẩu không khớp";
//                             }
//                             return null;
//                           },
//                           obscureText: true,
//                           decoration: InputDecoration(
//                             labelText: 'Nhập lại mật khẩu',
//                             labelStyle: Theme.of(context).textTheme.bodyText1,
//                           ),
//                         ),
//                         SizedBox(height: 50.0),
//                         Container(
//                             height: 40.0,
//                             child: Material(
//                               borderRadius: BorderRadius.circular(20.0),
//                               shadowColor: Colors.blueAccent,
//                               color: Colors.redAccent,
//                               elevation: 7.0,
//                               child: GestureDetector(
//                                 onTap: () async {
//                                   if (_formKey.currentState!.validate()) {
//                                     var request = ResetPasswordVM(
//                                         _phoneNumberController.text,
//                                         _passwordController.text);
//                                     var result = await context
//                                         .read<SignUpBloc>()
//                                         .resetPassword(request);
//                                     if (result.isSuccessed == true) {
//                                       ScaffoldMessenger.of(context)
//                                           .showSnackBar(SnackBar(
//                                               content: Text(
//                                                   "Khôi phục tài khoản thành công!")));
//                                       Navigator.of(context).pop();
//                                     } else {
//                                       ScaffoldMessenger.of(context)
//                                           .showSnackBar(SnackBar(
//                                               content:
//                                                   Text(result.errorMessage!)));
//                                     }
//                                   }
//                                 },
//                                 child: Center(
//                                   child: Text(
//                                     'Đồng ý',
//                                     style: Theme.of(context).textTheme.button,
//                                   ),
//                                 ),
//                               ),
//                             )),
//                         SizedBox(height: 20.0),
//                         Container(
//                           height: 40.0,
//                           color: Colors.transparent,
//                           child: Container(
//                             decoration: BoxDecoration(
//                                 border: Border.all(
//                                     color: Colors.black,
//                                     style: BorderStyle.solid,
//                                     width: 1.0),
//                                 color: Colors.transparent,
//                                 borderRadius: BorderRadius.circular(20.0)),
//                             child: InkWell(
//                               onTap: () {
//                                 Navigator.of(context).pop();
//                               },
//                               child: Center(
//                                 child: Text('Quay lại',
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontFamily: 'Montserrat')),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   )),
//             ]));
//   }
// }

//import 'dart:ffi';

// ignore_for_file: use_key_in_widget_constructors, unnecessary_new

import 'package:flutter/material.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // ignore: unused_field
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Khôi phục tài khoản',
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
            const Text(
              'Số điện thoại',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8.0),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.grey),
              ),
              child: TextField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(12.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Mật khẩu mới',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8.0),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.grey),
              ),
              child: TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(12.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Nhập lại mật khẩu',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8.0),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.grey),
              ),
              child: TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(12.0), // Remove default border
                ),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Kiểm tra tính hợp lệ của dữ liệu đầu vào
                    if (_phoneNumberController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Vui lòng nhập số điện thoại')),
                      );
                      return;
                    }

                    if (_passwordController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Vui lòng nhập mật khẩu mới')),
                      );
                      return;
                    }

                    if (_confirmPasswordController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Vui lòng nhập lại mật khẩu')),
                      );
                      return;
                    }

                    if (_passwordController.text !=
                        _confirmPasswordController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Mật khẩu mới không khớp')),
                      );
                      return;
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFE724C),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Đồng ý'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.black),
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Quay lại'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
