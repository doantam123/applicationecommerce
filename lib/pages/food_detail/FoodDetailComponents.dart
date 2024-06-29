import 'package:applicationecommerce/bloc/FoodDetail/FoodDetailState.dart';
import 'package:applicationecommerce/configs/AppConfigs.dart';
import 'package:applicationecommerce/pages/presentation/themes.dart';
import 'package:applicationecommerce/view_models/Foods/FoodVM.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'pages/FoodDescription.dart';
import 'pages/UserReview.dart';

class NamePrice extends StatelessWidget {
  final FoodDetailLoadedState _loadedState;
  const NamePrice(this._loadedState, {super.key});
  Widget _priceWidget() {
    FoodVM foodVM = _loadedState.foodVM;
    double discount = 0;
    if (_loadedState.foodVM.saleCampaignVM != null) {
      discount = _loadedState.foodVM.saleCampaignVM!.percent;
      final finalPrice = foodVM.price * (100 - discount) / 100;
      return Column(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              AppConfigs.toPrice(finalPrice),
              style: const TextStyle(
                  fontSize: 23.0,
                  color: Color(0xFF00B14F),
                  fontWeight: FontWeight.w400),
            ),
            Text(
              AppConfigs.toPrice(foodVM.price),
              style: const TextStyle(
                  fontSize: 18.0,
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey),
            ),
          ]);
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
      Text(
        AppConfigs.toPrice(foodVM.price),
        style: const TextStyle(
          fontSize: 20.0,
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    FoodVM foodVM = _loadedState.foodVM;

    return Padding(
      padding: const EdgeInsets.only(
          left: 20.0, right: 20.0, top: 10.0, bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            flex: 5,
            child: Column(
              children: [
                Text(
                  foodVM.name,
                  style: const TextStyle(
                      fontSize: 20.0,
                      fontFamily: "OpenSans",
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ],
            ),
          ),
          Flexible(
            flex: 2,
            child: _priceWidget(),
          )
        ],
      ),
    );
  }
}

class DescriptionAndRating extends StatefulWidget {
  final FoodDetailLoadedState _loadedState;
  const DescriptionAndRating(this._loadedState, {super.key});
  @override
  _DescriptionAndRatingState createState() =>
      _DescriptionAndRatingState(_loadedState);
}

class _DescriptionAndRatingState extends State<DescriptionAndRating>
    with SingleTickerProviderStateMixin {
  final FoodDetailLoadedState _loadedState;
  _DescriptionAndRatingState(this._loadedState);
  late List<Tab> _tabs;
  late List<Widget> _pages;
  static late TabController _controller;
  @override
  void initState() {
    super.initState();

    _tabs = [
      const Tab(
        child: Text(
          "Giới Thiệu",
        ),
      ),
      const Tab(
        child: Text(
          "Đánh Giá",
        ),
      ),
    ];
    _pages = [
      FoodDescription(_loadedState.foodVM),
      UserReview(_loadedState.userRatingList)
    ];
    _controller = TabController(
      length: _tabs.length,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          TabBar(
            labelPadding: const EdgeInsets.symmetric(horizontal: 35),
            labelColor: const Color(0xFF00B14F),
            labelStyle:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            isScrollable: true,
            controller: _controller,
            tabs: _tabs,
          ),
          const Divider(
            height: 1.0,
          ),
          SizedBox.fromSize(
            size: const Size.fromHeight(500.0),
            child: TabBarView(
              controller: _controller,
              children: _pages,
            ),
          ),
        ],
      ),
    );
  }
}

class FoodImage extends StatelessWidget {
  final FoodDetailLoadedState state;
  const FoodImage({super.key, required this.state});
  @override
  Widget build(BuildContext context) {
    final foodVM = state.foodVM;
    final sale = state.foodVM.saleCampaignVM;
    int discount = 0;
    if (sale != null) {
      discount = sale.percent.toInt();
    }

    return Column(
      children: [
        SizedBox(
          height: 280.0,
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.0),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          color: Colors.grey.withOpacity(0.7),
                          spreadRadius: 7,
                          offset: const Offset(0, 3),
                        )
                      ]),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(7.0),
                        child: CachedNetworkImage(
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.fill,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(
                                  color: AppTheme.circleProgressIndicatorColor),
                          imageUrl:
                              "${AppConfigs.URL_Images}/${foodVM.imagePath}",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              sale != null
                  ? Positioned(
                      bottom: 30,
                      right: 30,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.yellow,
                        ),
                        width: 70,
                        height: 30,
                        child: Center(
                          child: Text(
                            "-$discount%",
                            style: const TextStyle(
                                color: Colors.red,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              Positioned(
                left: 30,
                bottom: 30,
                child: Container(
                  // Đánh giá
                  width: 100,
                  height: 30.0,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10.0,
                            offset: Offset(0.0, 10.0))
                      ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Icon(
                        Icons.star,
                        color: Color.fromARGB(255, 255, 121, 11),
                      ),
                      Text(
                          "${foodVM.agvRating.toStringAsPrecision(2)} (${foodVM.totalRating})")
                    ],
                  ),
                ),
              ),
              //Appbar()
            ],
          ),
        ),
      ],
    );
  }
}
