import 'package:applicationecommerce/view_models/Foods/FoodVM.dart';
import 'package:flutter/material.dart';

class FoodDescription extends StatelessWidget {
  final FoodVM _foodVM;
  const FoodDescription(this._foodVM, {super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Text(
          _foodVM.description,
          style: const TextStyle(
              fontFamily: "OpenSans",
              color: Colors.black,
              fontSize: 18.0,
              fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
