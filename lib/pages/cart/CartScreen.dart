
import 'package:flutter/material.dart';

import 'CartBody.dart';

class CartScreen extends StatelessWidget {
  static String routeName = "/cart";

  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: const Body(),
      //bottomNavigationBar: CheckoutCart()
    );
  }
}

AppBar buildAppBar(BuildContext context) {
  //var count = context.select<CartModel, int>((value) => value.items.length);
  return AppBar(
    centerTitle: true,
    backgroundColor: Theme.of(context).primaryColor,
    title: Column(
      children: [
        Text(
          'Giỏ Hàng',
          style: Theme.of(context).textTheme.displayLarge,
        ),
        // Text(
        //   '$count sản phẩm',
        //   style: Theme.of(context).textTheme.caption,
        // )
      ],
    ),
  );
}
