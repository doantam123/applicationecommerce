import 'package:applicationecommerce/bloc/Address/AddressBloc.dart';
import 'package:applicationecommerce/bloc/Address/AddressEvent.dart';
import 'package:applicationecommerce/view_models/Addresses/AddressCreateVM.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class AddAdressScreen extends StatefulWidget {
  static String routeName = "/addadress";

  const AddAdressScreen({super.key});

  @override
  _AddAdressState createState() => _AddAdressState();
}

class _AddAdressState extends State<AddAdressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thêm địa chỉ',
          style: Theme.of(context).textTheme.displayLarge,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: const BodyAdressScreen(),
    );
  }
}

class BodyAdressScreen extends StatefulWidget {
  const BodyAdressScreen({super.key});

  @override
  _BodyAdressScreenState createState() => _BodyAdressScreenState();
}

class _BodyAdressScreenState extends State<BodyAdressScreen> {
  final _adressController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 20),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Tên',
                  suffixIcon: Icon(
                    Icons.person_pin,
                    color: Color(0xffFE724C),
                  ),
                  border: OutlineInputBorder(),
                ),
                controller: _nameController,
                onChanged: (text) {},
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Địa chỉ',
                  suffixIcon: Icon(
                    Icons.location_on,
                    color: Color(0xffFE724C),
                  ),
                  border: OutlineInputBorder(),
                ),
                controller: _adressController,
                onChanged: (text) {},
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async {
                  if (_nameController.text.isEmpty ||
                      _adressController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Tên và địa chỉ không được để trống!"),
                    ));
                    return;
                  }
                  var address = AddressCreateVM();
                  address.addressString = _adressController.text;
                  address.name = _nameController.text;
                  var result =
                      await context.read<AddressBloc>().createAddress(address);
                  if (result.isSuccessed) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Đã thêm địa chỉ"),
                    ));
                    context.read<AddressBloc>().add(AddressStarted());
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(result.errorMessage!),
                    ));
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Thêm địa chỉ',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
