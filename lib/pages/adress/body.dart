import 'package:applicationecommerce/bloc/Address/AddressBloc.dart';
import 'package:applicationecommerce/bloc/Address/AddressState.dart';
import 'package:applicationecommerce/pages/adress/AddAdressScreen.dart';
import 'package:applicationecommerce/pages/presentation/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Address.dart';
import 'AddressItem.dart';

class Body extends StatefulWidget {
  final AddressScreenCallBack? addressScreenCallBack;
  const Body(this.addressScreenCallBack, {super.key});
  @override
  _BodyState createState() => _BodyState(addressScreenCallBack);
}

class _BodyState extends State<Body> {
  AddressScreenCallBack? addressScreenCallBack;
  _BodyState(this.addressScreenCallBack);
  @override
  void initState() => super.initState();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddressBloc, AddressState>(
      builder: (context, state) {
        if (state is AddressLoadingState) {
          return Center(
            child: CircularProgressIndicator(
              color: AppTheme.circleProgressIndicatorColor,
            ),
          );
        }
        if (state is AddressLoadedState) {
          return Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return const AddAdressScreen();
                      }),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.withOpacity(0.2),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.add,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Thêm địa chỉ mới',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: state.listAddress.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: AdressItem(
                      adress: state.listAddress[index],
                      addressScreenCallBack: addressScreenCallBack,
                    ),
                  ),
                ),
              ),
            ],
          );
        }
        return const Text("Some thing went wrong!!");
      },
    );
  }
}
