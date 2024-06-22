import 'package:flutter/material.dart';

import 'Body.dart';

class PromotionScreen extends StatelessWidget {
  const PromotionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Mã khuyến mãi',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: const Body());
  }
}
