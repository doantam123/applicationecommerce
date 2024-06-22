import 'package:applicationecommerce/bloc/Cart/CartBloc.dart';
import 'package:applicationecommerce/bloc/Cart/CartEvent.dart';
import 'package:applicationecommerce/bloc/OrderHistory/OrderHistoryBloc.dart';
import 'package:applicationecommerce/bloc/OrderHistory/OrderHistoryEvent.dart';
import 'package:applicationecommerce/bloc/Profile/ProfileBloc.dart';
import 'package:applicationecommerce/bloc/Profile/ProfileEvent.dart';
import 'package:applicationecommerce/pages/cart/CartScreen.dart';
import 'package:applicationecommerce/pages/home/Home.dart';
import 'package:applicationecommerce/pages/oders/Orders.dart';
import 'package:applicationecommerce/pages/profile/Profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:applicationecommerce/bloc/Cart/CartBloc.dart';
import 'package:applicationecommerce/bloc/Cart/CartState.dart';

// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

class MotherBoard extends StatefulWidget {
  const MotherBoard({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MotherBoardState createState() => _MotherBoardState();
}

class _MotherBoardState extends State<MotherBoard> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    const HomeScreen(),
    const OderScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var rs = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Bạn có muốn thoát ứng dụng?"),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text("Có")),
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text("Không"))
                ],
              );
            });
        return rs == true;
      },
      child: Scaffold(
        body: _children[_currentIndex],
        bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            int cartItemCount = 0;
            if (state is CartLoadedState) {
              cartItemCount = state.getTotalProduct();
            }
            return BottomNavigationBar(
              currentIndex: _currentIndex,
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: "Home",
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.receipt_long),
                  label: "Order",
                ),
                BottomNavigationBarItem(
                  icon: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      const Icon(Icons.shopping_cart),
                      if (cartItemCount > 0)
                        CircleAvatar(
                          radius: 8,
                          backgroundColor: Colors.red,
                          child: Text(
                            cartItemCount.toString(),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                  label: "Cart",
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: "Profile",
                ),
              ],
              onTap: (int index) {
                onTabTapped(index, context);
              },
            );
          },
        ),
      ),
    );
  }


  Future<void> onTabTapped(int index, BuildContext context) async {
    _currentIndex = index;
    switch (_currentIndex) {
      case 0:
        //context.read<HomeBloc>().add(HomeRefeshEvent());
        break;
      case 1:
        context.read<OrderHistoryBloc>().add(OrderHistoryStartedEvent());
        break;
      case 2:
        //await context.read<CartModel>().fetchCartItems();
        //await context.read<CartModel>().fetchAddress();
        // context.read<ad>().fetchAll();
        context.read<CartBloc>().add(CartStartedEvent());
        break;
      case 3:
        context.read<ProfileBloc>().add(ProfileStartedEvent());
        break;
      //case 4:
      //context.read<ChatBloc>().add(ChatStartedEvent());
      //break;
      default:
    }

    setState(() {});
  }
}
