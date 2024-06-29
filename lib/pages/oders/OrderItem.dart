import 'package:applicationecommerce/bloc/OrderDetails/OrderDetailsBloc.dart';
import 'package:applicationecommerce/bloc/OrderDetails/OrderDetailsEvent.dart';
import 'package:applicationecommerce/configs/AppConfigs.dart';
import 'package:applicationecommerce/pages/OrderDetails/OrderDetails.dart';
import 'package:applicationecommerce/view_models/Orders/OrderVM.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderItem extends StatelessWidget {
  final OrderVM orderVM;
  const OrderItem(this.orderVM, {super.key});
  @override
  Widget build(BuildContext context) {
    String name = "";
    int foodCount = orderVM.orderDetailVMs.length;
    double price = 0;
    DateTime? datetime;
    if (orderVM.orderStatusID == 4 || orderVM.orderStatusID == 5) {
      datetime = orderVM.datePaid;
    } else {
      datetime = orderVM.createdDate;
    }
    for (var item in orderVM.orderDetailVMs) {
      name += "${item.foodVM!.name}, ";
      price += item.price *
          item.amount *
          (item.salePercent == null ? 1 : (100 - item.salePercent!) / 100);
    }
    if (orderVM.promotionAmount != null) {
      price -= orderVM.promotionAmount!;
    }

    return GestureDetector(
      onTap: () {
        context
            .read<OrderDetailsBloc>()
            .add(OrderDetailStartedEvent(orderVM.id));
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return const OrderDetails();
        }));
      },
      child: Container(
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(5), boxShadow: [
          BoxShadow(blurRadius: 2, color: Colors.grey.shade300, spreadRadius: 2)
        ]),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: 115,
            color: const Color(0xFF00B14F),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  color: Colors.white,
                  height: 30,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 15,
                        color: Colors.green,
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(2, 0, 0, 0),
                        child: Text(
                          orderVM.orderStatusVM.name,
                          style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w500,
                              fontSize: 13),
                        ),
                      ),
                      const Icon(
                        Icons.remove,
                        size: 15,
                        color: Colors.grey,
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(2, 0, 0, 0),
                        child: Text(
                          datetime == null
                              ? ""
                              : DateFormat.MMMd().format(datetime),
                          style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                              fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  color: Colors.white,
                  height: 15,
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(2, 0, 0, 0),
                        child: const Text(
                          "Giao đến: ",
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                              fontSize: 13),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(2, 0, 0, 0),
                        child: Text(
                          orderVM.addressString,
                          style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                              fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  height: 45,
                  color: Colors.white,
                  //color: Colors.grey.shade200,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 20),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  color: Colors.white,
                  height: 25,
                  child: Row(
                    children: [
                      const Text(
                        "\$ ",
                        style: TextStyle(
                          color: Color(0xFF00B14F),
                        ),
                      ),
                      Text(
                        AppConfigs.toPrice(price),
                        style: const TextStyle(
                          color: Color(0xFF00B14F),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        " ($foodCount Món)",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      // GestureDetector(
                      //   onTap: () {},
                      //   child: Center(
                      //     child: Icon(
                      //       Icons.more_horiz,
                      //       color: Colors.grey,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
