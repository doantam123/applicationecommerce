import 'package:applicationecommerce/bloc/Profile/ProfileBloc.dart';
import 'package:applicationecommerce/bloc/Profile/ProfileState.dart';
import 'package:applicationecommerce/pages/adress/Address.dart';
import 'package:applicationecommerce/pages/home/AppLoadingScreen.dart';
import 'package:applicationecommerce/pages/login_signup/Login.dart';
import 'package:applicationecommerce/pages/profile/ChangeEmail.dart';
import 'package:applicationecommerce/pages/profile/ChangeName.dart';
import 'package:applicationecommerce/pages/profile/ChangePasswordScreen.dart';
import 'package:applicationecommerce/services/UserServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

import 'ProfileMenu.dart';
import 'ProfilePicture.dart';

class Body extends StatelessWidget {
  const Body({super.key});
  Future<String?> _getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }

  Future<void> _saveDate(DateTime date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    await prefs.setString('birthdate', formattedDate);
  }

  Future<String?> _getBirthdate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? birthdate = prefs.getString('birthdate');
    return birthdate;
  }

  Widget _buildLoadedState(BuildContext context, ProfileLoadedState state) {
    String fullname = state.userVM.name;

    return FutureBuilder<String?>(
      future: _getEmail(),
      builder: (context, emailSnapshot) {
        String? email = emailSnapshot.data;

        return FutureBuilder<String?>(
          future: _getBirthdate(),
          builder: (context, birthdateSnapshot) {
            String? birthdate = birthdateSnapshot.data;

            return Column(
              children: [
                const ProfilePic(),
                ProfileMenu(
                  icon: Icon(
                    Icons.person,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  text: fullname,
                  press: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ChangeNameScreen(fullname)));
                  },
                ),
                ProfileMenu(
                  icon: Icon(Icons.location_on_outlined,
                      color: Theme.of(context).iconTheme.color),
                  text: 'Địa chỉ',
                  press: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddressScreen(
                                  addressScreenCallBack: null,
                                )));
                  },
                ),
                ProfileMenu(
                  icon: Icon(Icons.lock_outline_rounded,
                      color: Theme.of(context).iconTheme.color),
                  text: 'Đổi mật khẩu',
                  press: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const ChangePasswordScreen()));
                  },
                ),
                ProfileMenu(
                  icon: Icon(Icons.phone,
                      color: Theme.of(context).iconTheme.color),
                  text: state.userVM.username,
                  press: () {},
                ),
                ProfileMenu(
                  icon: Icon(Icons.mail_outline,
                      color: Theme.of(context).iconTheme.color),
                  text: email ?? "Vui lòng cập nhật email",
                  press: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ChangeEmailScreen()));
                  },
                ),
                ProfileMenu(
                  icon: Icon(Icons.date_range,
                      color: Theme.of(context).iconTheme.color),
                  text: birthdate ?? "Vui lòng cập nhật ngày sinh",
                  press: () {
                    DatePicker.showDatePicker(
                      context,
                      showTitleActions: true,
                      minTime: DateTime(1900),
                      maxTime: DateTime.now(),
                      onConfirm: (date) async {
                        await _saveDate(date);
                      },
                      currentTime: DateTime.now(),
                      locale: LocaleType
                          .vi, // Optionally, you can specify the locale
                    );
                  },
                ),
                ProfileMenu(
                  icon: Icon(Icons.logout,
                      color: Theme.of(context).iconTheme.color),
                  text: 'Đăng xuất',
                  press: () async {
                    UserServices userServices = UserServices();
                    await userServices.logout();
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) {
                      return const LoginPage();
                    }), (Route<dynamic> route) => false);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return const AppLoadingScreen();
  }

  Widget _buildErrorState(ProfileErrorState state) {
    return Container(
      child: Center(child: Text(state.error)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoadedState) {
          return _buildLoadedState(context, state);
        }
        if (state is ProfileLoadingState) {
          return _buildLoadingState();
        }
        if (state is ProfileErrorState) {
          return _buildErrorState(state);
        }
        throw "Unknow state";
      },
    );
  }
}
