//import 'dart:html';

import 'package:applicationecommerce/bloc/OrderDetails/OrderDetailsBloc.dart';
import 'package:applicationecommerce/bloc/OrderDetails/OrderDetailsEvent.dart';
import 'package:applicationecommerce/bloc/OrderDetails/OrderDetailsState.dart';
import 'package:applicationecommerce/configs/AppConfigs.dart';
import 'package:applicationecommerce/pages/commons/StarRating.dart';
import 'package:applicationecommerce/pages/food_detail/FoodDetail.dart';
import 'package:applicationecommerce/pages/presentation/LightColor.dart';
import 'package:applicationecommerce/pages/presentation/themes.dart';
import 'package:applicationecommerce/view_models/Orders/OrderDetailVM.dart';
import 'package:applicationecommerce/view_models/Orders/OrderVM.dart';
import 'package:applicationecommerce/view_models/ratings/RatingCreateVM.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderDetailsBody extends StatelessWidget {
  final _commentController = TextEditingController();
  int countItem = 1;
  OrderDetailsBody({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderDetailsBloc, OrderDetailsState>(
        builder: (context, state) {
      if (state is OrderDetailsLoadingState) {
        return Container(
          child: Center(
            child: CircularProgressIndicator(
                color: AppTheme.circleProgressIndicatorColor),
          ),
        );
      }
      if (state is OrderDetailsLoadedState) {
        countItem = state.orderVM.orderDetailVMs.length;
        return _buildLoadedState(context, state);
      }
      if (state is OrderDetailsErrorState) {
        return Container(
          child: Center(child: Text(state.error)),
        );
      }
      throw "Unknow state";
    });
  }

  Widget _buildLoadedState(
      BuildContext context, OrderDetailsLoadedState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          SizedBox(
            height: 40,
            child: Row(children: [
              const Text("Trạng thái", style: TextStyle(color: Colors.black)),
              const Spacer(),
              Text(state.orderVM.orderStatusVM.name,
                  style: const TextStyle(
                      color: Colors.green,
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
            ]),
          ),
          const Divider(),
          addressSession(
              context, state.orderVM.addressName, state.orderVM.addressString),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return _item(state.orderVM.orderDetailVMs[index], state.orderVM,
                    context);
              },
              itemCount: state.orderVM.orderDetailVMs.length,
            ),
          ),
          const Divider(),
          SizedBox(
            height: 30,
            child: Row(
              children: [
                const Text("Số lượng", style: TextStyle(color: Colors.black)),
                const Spacer(),
                Text(countItem.toString(),
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                Text(" loại sản phẩm",
                    style: const TextStyle(
                      color: Colors.black,
                    ))
              ],
            ),
          ),
          const Divider(),
          SizedBox(
            height: 30,
            child: Row(
              children: [
                const Text("Tạm tính", style: TextStyle(color: Colors.black)),
                const Spacer(),
                Text(AppConfigs.toPrice(state.tempPrice),
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold))
              ],
            ),
          ),
          const Divider(),
          SizedBox(
            height: 30,
            child: Row(
              children: [
                const Text("Mã giảm giá",
                    style: TextStyle(color: Colors.black)),
                const Spacer(),
                Text("-${AppConfigs.toPrice(state.promotedAmount)}",
                    style: const TextStyle(color: Color(0xffFE724C)))
              ],
            ),
          ),
          const Divider(),
          SizedBox(
            height: 30,
            child: Row(
              children: [
                const Text("Tổng cộng", style: TextStyle(color: Colors.black)),
                const Spacer(),
                Text(AppConfigs.toPrice(state.finalPrice),
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green))
              ],
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }

  Widget addressSession(
      BuildContext context, String addressName, String addressString) {
    return Container(
      //height: 150,
      child: Column(
        children: [
          SizedBox(
            height: 80,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                        child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Giao đến",
                              style: TextStyle(color: Colors.black),
                            )),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.my_location,
                                  color: Color(0xffFE724C),
                                  size: 20,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  addressString,
                                  style:
                                      Theme.of(context).textTheme.displaySmall,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            )),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(

              //indent: 20,
              //endIndent: 20,
              ),
          Container(
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Đơn hàng",
                style: TextStyle(color: Colors.black),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _comment(BuildContext context, OrderDetailVM model) {
    double rating = 0;
    if (model.ratingVM == null) {
      _commentController.text = "";
      return Container(
        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
        child: Container(
          child: RatingButton((rating) async {
            rating = rating;
            var result = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    actions: [
                      TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor),
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: Text(
                            "OK",
                            style: Theme.of(context).textTheme.labelLarge,
                          )),
                      TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor),
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: Text("Cancel",
                              style: Theme.of(context).textTheme.labelLarge))
                    ],
                    title: const Text("Đánh giá"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: RatingButton((rating) {
                            rating = rating;
                          }, rating),
                        ),
                        Container(
                          //height: 100,
                          margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          alignment: Alignment.center,
                          child: TextField(
                            controller: _commentController,
                            textAlignVertical: TextAlignVertical.center,
                            style: const TextStyle(fontSize: 13, height: 1),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Bạn thấy món này như thế nào?',
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                });
            if (result == true) {
              var rs = await context.read<OrderDetailsBloc>().createReview(
                  RatingCreateVM(model.orderID, model.foodID, rating.toInt(),
                      _commentController.text));
              if (rs.isSuccessed == false) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(rs.errorMessage!)));
              }
              _commentController.text = "";
              context
                  .read<OrderDetailsBloc>()
                  .add(OrderDetailStartedEvent(model.orderID));
            }
          }, rating),
        ),
      );
    }
    return Container();
  }

  Widget _item(OrderDetailVM model, OrderVM orderVM, BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return FoodDetail(foodID: model.foodID, promotionID: null);
        }));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration:
            const BoxDecoration(color: Colors.white, boxShadow: <BoxShadow>[
          BoxShadow(
            blurRadius: 3.0,
            color: Colors.black12,
            //offset: new Offset(0.0, 10.0))
          )
        ]),
        child: Column(
          children: [
            Container(
              height: 85,
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 1.2,
                    child: SizedBox(
                        height: 70,
                        width: 70,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(
                                    color:
                                        AppTheme.circleProgressIndicatorColor)),
                            imageUrl:
                                "${AppConfigs.URL_Images}/${model.foodVM!.imagePath}",
                          ),
                        )),
                  ),
                  Container(
                    width: 10,
                  ),
                  Expanded(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(
                          model.foodVM!.name,
                          textAlign: TextAlign.left,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        _priceWidget(model),
                      ])),
                  Container(
                    width: 35,
                    height: 35,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: LightColor.lightGrey.withAlpha(150),
                        borderRadius: BorderRadius.circular(5)),
                    child: Text('x${model.amount}',
                        style: const TextStyle(
                          fontSize: 12,
                        )),
                  )
                ],
              ),
            ),
            orderVM.orderStatusID == OrderStatus.DaNhanHang
                ? _comment(context, model)
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget _priceWidget(OrderDetailVM cartVM) {
    if (cartVM.saleCampaignID != null) {
      double discount = cartVM.salePercent!;
      return Row(
        children: <Widget>[
          Text(
              "${AppConfigs.toPrice(cartVM.price * cartVM.amount * (100 - discount) / 100)}  ",
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffFE724C))),
          Text(AppConfigs.toPrice(cartVM.price * cartVM.amount),
              style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                  decoration: TextDecoration.lineThrough)),
        ],
      );
    }
    return Row(
      children: <Widget>[
        Text(AppConfigs.toPrice(cartVM.foodVM!.price * cartVM.amount),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class RatingButton extends StatefulWidget {
  final RatingChangeCallback _ratingChangeCallback;
  final double _startStar;
  const RatingButton(this._ratingChangeCallback, this._startStar, {super.key});
  @override
  _RatingButtonState createState() =>
      _RatingButtonState(_ratingChangeCallback, _startStar);
}

class _RatingButtonState extends State<RatingButton> {
  final RatingChangeCallback _ratingChangeCallback;

  _RatingButtonState(this._ratingChangeCallback, this.start);
  double start;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: StarRating(
        iconSize: 30,
        rating: start,
        onRatingChanged: (rating) {
          start = rating;
          _ratingChangeCallback(rating);
          setState(() {});
        },
      ),
    );
  }
}
