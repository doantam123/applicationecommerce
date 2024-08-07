import 'package:applicationecommerce/bloc/Cart/CartBloc.dart';
import 'package:applicationecommerce/bloc/Cart/CartEvent.dart';
import 'package:applicationecommerce/bloc/FoodDetail/FoodDetailBloc.dart';
import 'package:applicationecommerce/bloc/FoodDetail/FoodDetailEvent.dart';
import 'package:applicationecommerce/bloc/FoodDetail/FoodDetailState.dart';
import 'package:applicationecommerce/configs/AppConfigs.dart';
import 'package:applicationecommerce/pages/home/AppLoadingScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'FoodDetailComponents.dart';

class FoodDetailArguments {
  bool displayCartBtn;
  FoodDetailArguments({this.displayCartBtn = true});
}

class FoodDetail extends StatefulWidget {
  final int foodID;
  final int? promotionID;
  const FoodDetail({super.key, required this.foodID, this.promotionID});

  static String routeName = "/food_detail";

  @override
  // ignore: library_private_types_in_public_api
  _FoodDetailState createState() =>
      // ignore: no_logic_in_create_state
      _FoodDetailState(foodID: foodID, promotionID: promotionID);
}

class _FoodDetailState extends State<FoodDetail> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  int count = 1;

  final int foodID;
  final int? promotionID;

  _FoodDetailState({required this.foodID, this.promotionID});

  @override
  void initState() {
    context
        .read<FoodDetailBloc>()
        .add(FoodDetailStartedEvent(foodID: foodID, promotionID: promotionID));

    super.initState();
  }

  Widget bottomBtns(BuildContext context, FoodDetailLoadedState state) {
    final price = state.foodVM.price;
    final cartVM = state.cartVM;
    double discount = 0;
    if (cartVM != null) {
      count = cartVM.quantity;
    }
    if (state.foodVM.saleCampaignVM != null) {
      discount = state.foodVM.saleCampaignVM!.percent;
    }
    final totalPrice = (price * count) * (100 - discount) / 100;

    final salePrice = (price * count) - totalPrice;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (count > 1) count--;
                            if (cartVM != null) {
                              cartVM.quantity = count;
                            }
                          });
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(1000),
                              color: Color(0xFF00B14F),
                              border: Border.all(
                                  style: BorderStyle.solid,
                                  color: const Color(0xFF00B14F))),
                          child: const Icon(
                            Icons.remove,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 40.0,
                        height: 40.0,
                        child: Center(
                            child: Text("$count",
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600))),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            count++;
                            if (cartVM != null) {
                              cartVM.quantity = count;
                            }
                          });
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(1000),
                            color: const Color(0xFF00B14F),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: salePrice > 0
                        ? Row(
                            children: [
                              Text("Bạn đã tiết kiệm được "),
                              Text(
                                AppConfigs.toPrice(salePrice),
                                style: TextStyle(color: Colors.red),
                              ),
                              Text(" sau khi giảm giá"),
                            ],
                          )
                        : Container(), // Nếu salePrice không lớn hơn 0, trả về một widget Container trống
                  ),
                  InkWell(
                    onTap: () async {
                      var result = await context
                          .read<FoodDetailBloc>()
                          .createCart(state.foodVM.id, count);
                      if (result.isSuccessed == false) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(result.errorMessage!)),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Đã thêm vào giỏ hàng!")),
                        );
                        Navigator.of(context).pop();
                        context.read<CartBloc>().add(CartRefreshdEvent());
                      }
                    },
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Center(
                          child: Text(
                            "Thêm vào giỏ hàng - " +
                                AppConfigs.toPrice(totalPrice),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, FoodDetailLoadedState state) {
    return Scaffold(
        body: ListView(
          controller: _scrollController,
          children: <Widget>[
            IconButton(
              alignment: Alignment.topLeft,
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                // Xử lý sự kiện khi nút được nhấn
                Navigator.of(context).pop();
              },
            ),
            FoodImage(
              state: state,
            ),
            NamePrice(state),
            //Divider(),
            NotificationListener<OverscrollNotification>(
                onNotification: (OverscrollNotification value) {
                  if (value.overscroll < 0 &&
                      _scrollController.offset + value.overscroll <= 0) {
                    if (_scrollController.offset != 0) {
                      _scrollController.jumpTo(0);
                    }
                    return true;
                  }
                  if (_scrollController.offset + value.overscroll >=
                      _scrollController.position.maxScrollExtent) {
                    if (_scrollController.offset !=
                        _scrollController.position.maxScrollExtent) {
                      _scrollController
                          .jumpTo(_scrollController.position.maxScrollExtent);
                    }
                    return true;
                  }
                  _scrollController
                      .jumpTo(_scrollController.offset + value.overscroll);
                  return true;
                },
                child: DescriptionAndRating(state)),
          ],
        ),
        bottomNavigationBar: Container(
          height: 150,
          child: bottomBtns(context, state),
        ));
  }

  Widget _buildErrorState(BuildContext context, FoodDetailErrorState state) {
    return Scaffold(body: Container(child: Center(child: Text(state.error))));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodDetailBloc, FoodDetailState>(
        builder: (context, state) {
      if (state is FoodDetailLoadingState) {
        print("FoodDetailLoadingState");
        return const AppLoadingScreen();
      }
      if (state is FoodDetailLoadedState) {
        return _buildLoadedState(context, state);
      }
      if (state is FoodDetailErrorState) {
        return _buildErrorState(context, state);
      }
      throw "Unknown state!";
    });
  }
}
