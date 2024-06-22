import 'package:applicationecommerce/view_models/Addresses/AddressVM.dart';
import 'package:flutter/material.dart';

import 'Body.dart';

typedef AddressScreenCallBack = void Function(
    AddressVM addressVM, BuildContext context);

class AddressScreen extends StatelessWidget {
  //static String routeName = "/adress";
  final AddressScreenCallBack? addressScreenCallBack;
  const AddressScreen({super.key, required this.addressScreenCallBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () async {
                Navigator.of(context).pop();
              }),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            'Địa chỉ',
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
        body: Body(addressScreenCallBack));
  }
}
