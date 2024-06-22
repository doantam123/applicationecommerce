import 'package:applicationecommerce/bloc/Address/AddressBloc.dart';
import 'package:applicationecommerce/bloc/Address/AddressEvent.dart';
import 'package:applicationecommerce/view_models/Addresses/AddressEditVM.dart';
import 'package:applicationecommerce/view_models/Addresses/AddressVM.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class EditAdressScreen extends StatelessWidget {
  EditAdressScreen(this.addressVM, {super.key});
  final AddressVM addressVM;
  final _adressController = TextEditingController();
  final _nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sửa địa chỉ',
          style: Theme.of(context).textTheme.displayLarge,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    _adressController.text = addressVM.addressString;
    _nameController.text = addressVM.name;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Tên',
                  border: OutlineInputBorder(),
                ),
                controller: _nameController,
                onChanged: (text) {},
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Địa chỉ',
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
                  final editVM = AddressEditVM();
                  editVM.id = addressVM.id;
                  editVM.appUserID = addressVM.appUserID;
                  editVM.name = _nameController.text;
                  editVM.addressString = _adressController.text;
                  var result =
                      await context.read<AddressBloc>().editAddress(editVM);
                  if (result.isSuccessed) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Đã cập nhật địa chỉ"),
                    ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(result.errorMessage!),
                    ));
                  }
                  context.read<AddressBloc>().add(AddressStarted());
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Sửa',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
