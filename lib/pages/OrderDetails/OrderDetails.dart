import 'package:flutter/material.dart';

import 'OrderDetailsBody.dart';

class OrderDetails extends StatelessWidget {
  const OrderDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: OrderDetailsBody(),
      appBar: _buildAppBar(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Theme.of(context).primaryColor,
      title: Column(
        children: [
          Text(
            'Chi tiết hóa đơn',
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ],
      ),
    );
  }
}
