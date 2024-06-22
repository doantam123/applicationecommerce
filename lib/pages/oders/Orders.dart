import 'package:flutter/material.dart';

import 'Body.dart';

class OderScreen extends StatelessWidget {
  static String routeName = "/oders";

  const OderScreen({super.key});
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
          'Hóa đơn của bạn',
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ],
    ),
  );
}
