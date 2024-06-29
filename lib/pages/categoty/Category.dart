import 'dart:developer';

import 'package:applicationecommerce/bloc/Cart/CartBloc.dart';
import 'package:applicationecommerce/bloc/Cart/CartEvent.dart';
import 'package:applicationecommerce/bloc/Category/CategoryBloc.dart';
import 'package:applicationecommerce/bloc/Category/CategoryState.dart';
import 'package:applicationecommerce/bloc/FoodDetail/FoodDetailBloc.dart';
import 'package:applicationecommerce/bloc/Search/SearchBloc.dart';
import 'package:applicationecommerce/bloc/Search/SearchEvent.dart';
import 'package:applicationecommerce/configs/AppConfigs.dart';
import 'package:applicationecommerce/pages/food_detail/FoodDetail.dart';
import 'package:applicationecommerce/pages/home/AppLoadingScreen.dart';
import 'package:applicationecommerce/pages/presentation/themes.dart';
import 'package:applicationecommerce/pages/search/Search.dart';
import 'package:applicationecommerce/view_models/Foods/FoodVM.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryPage extends StatefulWidget {
  static String routeName = "/category";

  const CategoryPage({Key? key}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  _CategoryPageState();

  Widget _buildLoadedState(BuildContext context, CategoryLoadedState state) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                context.read<SearchBloc>().add(SeachClearResultEvent());
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return Search(state.categoryVM.id);
                }));
              },
              icon: const Icon(Icons.search))
        ],
        backgroundColor: Theme.of(context).primaryColor,
        title: Text((state.categoryVM.name ?? "Category")),
      ),
      body: Container(
          //color: Colors.grey,
          child: Column(
        children: [
          BestSelling(state),
          _PromotingItems(state),
          Expanded(child: AllFood(state))
        ],
      )),
    );
  }

  Widget _buildErrorState(BuildContext context, CategoryErrorState state) {
    return Text(state.error);
  }

  @override
  Widget build(BuildContext context) {
    //log("Context:" + context.hashCode.toString());
    //final categoryID = context.read<CategoryModel>().currentID;
    // var category = context
    //     .select<CategoryModel, List<CategoryVM>>((value) => value.items)
    //     .firstWhere((element) => element.id == categoryID);
    return BlocBuilder<CategoryBloc, CategoryState>(builder: (context, state) {
      if (state is CategoryLoadingState) {
        return const AppLoadingScreen();
      }
      if (state is CategoryLoadedState) {
        return _buildLoadedState(context, state);
      }
      if (state is CategoryErrorState) {
        return _buildErrorState(context, state);
      }
      throw "Unknow state";
    });
  }
}

class BestSelling extends StatefulWidget {
  final CategoryLoadedState _categoryLoadedState;
  const BestSelling(this._categoryLoadedState, {super.key});
  @override
  _BestSellingState createState() => _BestSellingState(_categoryLoadedState);
}

class _BestSellingState extends State<BestSelling> {
  final CategoryLoadedState _categoryLoadedState;
  _BestSellingState(this._categoryLoadedState);
  @override
  Widget build(BuildContext context) {
    final categoryID = _categoryLoadedState.categoryVM.id;
    log("BestSelling: category: $categoryID");
    log("Context:${context.hashCode}");

    return Container(
      //padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
      height: 150,
      color: Colors.white,
      child: Container(
        margin: const EdgeInsets.fromLTRB(15.0, 10.0, 10.0, 0.0),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Món bán chạy",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(
              height: 110,
              child: ListView.builder(
                  //shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: _categoryLoadedState.bestSelling.length,
                  itemBuilder: (BuildContext context, int index) {
                    return FoodCard(
                        foodVM: _categoryLoadedState.bestSelling[index]);
                  }),
            )
          ],
        ),
      ),
    );
  }
}

class _PromotingItems extends StatelessWidget {
  final CategoryLoadedState _categoryLoadedState;
  const _PromotingItems(this._categoryLoadedState);
  @override
  Widget build(BuildContext context) {
    if (_categoryLoadedState.promoting.isEmpty) {
      return Container();
    }

    return Container(
      //padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
      height: 150,
      color: Colors.white,
      child: Container(
        margin: const EdgeInsets.fromLTRB(15.0, 10.0, 10.0, 0.0),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Món đang giảm giá",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(
              height: 110,
              child: ListView.builder(
                  //shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: _categoryLoadedState.promoting.length,
                  itemBuilder: (BuildContext context, int index) {
                    return FoodCard(
                        foodVM: _categoryLoadedState.promoting[index]);
                  }),
            )
          ],
        ),
      ),
    );
  }
}

class AllFood extends StatelessWidget {
  final CategoryLoadedState _categoryLoadedState;
  const AllFood(this._categoryLoadedState, {super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(15.0, 10.0, 10.0, 0.0),
      child: Column(
        children: [
          // Divider(
          //   thickness: 2,
          // ),
          const SizedBox(
            height: 30,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Tất cả",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                //scrollDirection: Axis.vertical,
                itemCount: _categoryLoadedState.allFood.length,
                itemBuilder: (BuildContext context, int index) {
                  return FoodCard(
                    foodVM: _categoryLoadedState.allFood[index],
                    bottomBorder:
                        BorderSide(width: 1.0, color: Colors.grey.shade300),
                  );
                }),
          )
        ],
      ),
    );
  }
}

class FoodCard extends StatelessWidget {
  final FoodVM foodVM;
  const FoodCard(
      {super.key, required this.foodVM, this.bottomBorder = BorderSide.none});
  final BorderSide bottomBorder;

  Widget _priceWidget(FoodVM foodVM) {
    if (foodVM.saleCampaignVM != null) {
      double discount = foodVM.saleCampaignVM!.percent;
      return Row(
        children: [
          const Icon(
            Icons.sell_outlined,
            size: 15,
            color: Colors.red,
          ),
          Text(
            "${AppConfigs.toPrice(foodVM.price * (100 - discount) / 100)}  ",
            style: const TextStyle(
                fontSize: 12, color: Colors.red, fontWeight: FontWeight.w500),
          ),
          Text(
            AppConfigs.toPrice(foodVM.price),
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.lineThrough,
                color: Colors.grey),
          ),
        ],
      );
    }

    return Row(
      children: [
        Text(
          AppConfigs.toPrice(foodVM.price),
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: bottomBorder,
        ),
      ),
      padding: const EdgeInsets.all(0.0),
      child: Stack(
        children: [
          InkWell(
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FoodDetail(
                    foodID: foodVM.id,
                    promotionID: null,
                  ),
                ),
              );
            },
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color.fromARGB(158, 158, 158, 158),
                    width: 0.3,
                  ),
                ),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    // ignore: avoid_unnecessary_containers
                    child: Container(
                      child: Stack(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color(0xFF00B14F),
                                width: 2.0,
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: CachedNetworkImage(
                              fit: BoxFit.fill,
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(
                                  color: AppTheme.circleProgressIndicatorColor,
                                ),
                              ),
                              imageUrl:
                                  "${AppConfigs.URL_Images}/${foodVM.imagePath}",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        //width: 170,
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 200,
                              margin: const EdgeInsets.fromLTRB(0, 10, 5, 10),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  foodVM.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            _priceWidget(foodVM),
                            SizedBox(
                              height: 40,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                        size: 18,
                                      ),
                                      Text(
                                        foodVM.agvRating.toStringAsPrecision(2),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        " (${foodVM.totalRating})",
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 45,
                        width: 45,
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: InkWell(
                          onTap: () async {
                            var result = await context
                                .read<FoodDetailBloc>()
                                .createCart(foodVM.id, 1);
                            if (result.isSuccessed == false) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(result.errorMessage!)),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Đã thêm vào giỏ hàng!")),
                              );
                              context.read<CartBloc>().add(CartRefreshdEvent());
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Icon(
                              Icons.shopping_cart,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: unused_element
class _Search extends SearchDelegate {
  String selectedResult = "";
  final List<String> listExample;
  _Search(this.listExample);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: Center(
        child: Text(selectedResult),
      ),
    );
  }

  List<String> recentList = [];

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestionList = [];
    query.isEmpty
        ? suggestionList = recentList
        : suggestionList
            .addAll(listExample.where((element) => element.contains(query)));
    recentList = suggestionList;
    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(suggestionList[index]),
            onTap: () {
              selectedResult = suggestionList[index];
              showResults(context);
            },
          );
        });
  }
}
