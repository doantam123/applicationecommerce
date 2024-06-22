// ignore_for_file: file_names

import 'package:applicationecommerce/bloc/Address/AddressBloc.dart';
import 'package:applicationecommerce/bloc/Address/AddressEvent.dart';
import 'package:applicationecommerce/pages/adress/EditAddressScreen.dart';
import 'package:applicationecommerce/view_models/Addresses/AddressVM.dart';
import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

import 'Address.dart';

class AdressItem extends StatelessWidget {
  final AddressScreenCallBack? addressScreenCallBack;
  const AdressItem(
      {Key? key, required this.adress, required this.addressScreenCallBack})
      : super(key: key);
  final AddressVM adress;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.white,
        padding: EdgeInsets.zero,
      ),
      onPressed: () {
        if (addressScreenCallBack != null) {
          addressScreenCallBack!(adress, context);
        }
      },
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey, // Màu của border bottom
              width: 1, // Độ dày của border bottom
            ),
          ),
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 50,
              child: Icon(
                Icons.location_pin,
                color: Color(0xffFE724C),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    adress.name,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    adress.addressString,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            PopupMenuButton(
              child: const Icon(
                Icons.more_vert,
                color: Colors.blue,
              ),
              onSelected: (index) async {
                if (index == 0) {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return EditAdressScreen(adress);
                  }));
                } else if (index == 1) {
                  var result = await context
                      .read<AddressBloc>()
                      .deleteAddress(adress.id);
                  if (result.isSuccessed) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Đã xóa địa chỉ")),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(result.errorMessage!)),
                    );
                  }
                  context.read<AddressBloc>().add(AddressStarted());
                }
              },
              itemBuilder: (context) {
                return <PopupMenuEntry<int>>[
                  const PopupMenuItem(
                    value: 0,
                    child: Text('Sửa'),
                  ),
                  const PopupMenuItem(
                    value: 1,
                    child: Text('Xóa'),
                  )
                ];
              },
            ),
          ],
        ),
      ),
    );
  }
}
