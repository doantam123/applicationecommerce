import 'package:flutter/material.dart';

import 'Body.dart';

class ProfileScreen extends StatelessWidget {
  static String routeName = "/profile";

  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: const Body(),
    );
  }
}

AppBar buildAppBar(BuildContext context) {
  return AppBar(
    centerTitle: true,
    backgroundColor: Theme.of(context).primaryColor,
    title: Column(
      children: [
        Text(
          'Thông tin cá nhân',
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ],
    ),
  );
}
