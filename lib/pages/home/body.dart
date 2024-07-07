// ignore_for_file: prefer_is_empty, no_leading_underscores_for_local_identifiers, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'dart:developer';
import 'package:applicationecommerce/bloc/Cart/CartBloc.dart';
import 'package:applicationecommerce/bloc/Cart/CartEvent.dart';
import 'package:applicationecommerce/bloc/Category/CategoryBloc.dart';
import 'package:applicationecommerce/bloc/Category/CategoryEvent.dart';
import 'package:applicationecommerce/bloc/FoodDetail/FoodDetailBloc.dart';
import 'package:applicationecommerce/bloc/Home/HomeBloc.dart';
import 'package:applicationecommerce/bloc/Home/HomeEvent.dart';
import 'package:applicationecommerce/bloc/Home/HomeState.dart';
import 'package:applicationecommerce/bloc/Promotions/PromotionBloc.dart';
import 'package:applicationecommerce/bloc/Promotions/PromotionEvent.dart';
import 'package:applicationecommerce/configs/AppConfigs.dart';
import 'package:applicationecommerce/pages/categoty/Category.dart';
import 'package:applicationecommerce/pages/food_detail/FoodDetail.dart';
import 'package:applicationecommerce/pages/home/AppLoadingScreen.dart';
import 'package:applicationecommerce/pages/home/ZigZacVerticalLine.dart';
import 'package:applicationecommerce/pages/presentation/themes.dart';
import 'package:applicationecommerce/pages/promotion/Body.dart';
import 'package:applicationecommerce/pages/promotion/Promotions.dart';
import 'package:applicationecommerce/pages/search/Search.dart';
import 'package:applicationecommerce/view_models/Categories/CategoryVM.dart';
import 'package:applicationecommerce/view_models/Foods/FoodVM.dart';
import 'package:applicationecommerce/view_models/Promotions/PromotionVM.dart';
import 'package:applicationecommerce/view_models/SaleCampaigns/SaleCampaignVM.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<String> _appBannerImages = [];
  @override
  void initState() {
    _appBannerImages = [
      "images/app_banner/banner1.png",
      "images/app_banner/banner4.png",
      "images/app_banner/banner5.png",
    ];
    super.initState();
  }

  Widget buidImageCarousel(List<String> images) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      height: 185,
      child: CarouselSlider(
        options: CarouselOptions(
          //height: 400.0,
          enlargeCenterPage: true,
          aspectRatio: 16 / 9,
          viewportFraction: 0.8,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
        ),
        items: images.map((i) {
          return Builder(
            builder: (BuildContext context) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 1.0),
                    decoration: const BoxDecoration(),
                    child: Image.asset(i)),
              );
            },
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      if (state is HomeLoadingState) {
        return const AppLoadingScreen();
      }
      if (state is HomeLoadedState) {
        return _buildLoadedState(context, state);
      }
      throw "Unknown state!";
    });
  }

  Widget _buildLoadedState(BuildContext context, HomeLoadedState state) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFEBF1FA),
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<HomeBloc>().add(HomeRefeshEvent());
          },
          child: ListView(
            children: [
              fakeSearchBox(),
              buidImageCarousel(_appBannerImages),
              // offers(state),
              _categoryList(state.listCategory),
              promotion(state),
              SaleContainer(state.listSaleCampaign),
              //PromotionContainer(state.listPromotion),
              BestSellingContainer(state.listBestSellingFood)
              //PromotionContainer(state.listPromotion[1]),
            ],
          ),
        ),
      ),
    );
  }

  Widget fakeSearchBox() {
    return Container(
      height: 65,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF00B14F), // Màu cho nửa trên
            Colors.white, // Màu cho nửa dưới
          ],
          begin: Alignment.topCenter, // Bắt đầu gradient từ trên xuống
          end: Alignment.bottomCenter, // Kết thúc gradient từ dưới lên
        ),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const Search(null)));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5), // Màu của đổ bóng
                  spreadRadius: 1, // Khoảng cách mà đổ bóng mở rộng ra
                  blurRadius: 4, // Độ mờ của đổ bóng
                  offset: const Offset(0,
                      3), // Vị trí của đổ bóng, trong trường hợp này, là ở dưới
                ),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            //margin: EdgeInsets.all(20),
            height: 40,
            child: Row(
              children: [
                Container(
                  child: Icon(
                    Icons.search,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  "Bạn muốn tìm gì?",
                  style: TextStyle(color: Colors.grey[500], fontSize: 15.0),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget promotion(HomeLoadedState state) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: const Text(
              "Ưu đãi dành cho bạn",
              overflow: TextOverflow.clip,
              maxLines: 1,
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF141619),
                  fontFamily: 'Montserrat'),
            ),
          ),
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.listPromotionsValid.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => promotionDetail(
                              state.listPromotionsValid[index]));
                    },
                    child: Container(
                      width: 330,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: const Color.fromARGB(146, 158, 158, 158),
                              style: BorderStyle.solid)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Container(
                                width: 200,
                                height: 130,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 167, 236, 133),
                                  borderRadius: BorderRadius.circular(
                                      12), // Đặt độ cong cho góc
                                ),
                                child: SizedBox(
                                  width: 150,
                                  height: 120,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: CachedNetworkImage(
                                        placeholder: (context, index) => Center(
                                          child: CircularProgressIndicator(
                                            color: AppTheme
                                                .circleProgressIndicatorColor,
                                          ),
                                        ),
                                        imageUrl:
                                            "${AppConfigs.URL_Images}/${state.listPromotionsValid[index].imagePath}",
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 30, bottom: 40),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${state.listPromotionsValid[index].desciption}",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Text(
                                        AppConfigs.toPrice(state
                                            .listPromotionsValid[index].max!),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFF00B14F))),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget offers(HomeLoadedState state) {
    if (state.listPromotionsValidForUser.length == 0) {
      return Container(
        height: 20,
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      //margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
      color: Colors.white,
      child: GestureDetector(
        onTap: () {
          context.read<PromotionBloc>().add(PromotionStartedEvent());
          Navigator.of(context).push(MaterialPageRoute(builder: (conetxt) {
            return const PromotionScreen();
          }));
        },
        child: Container(
          height: 50,
          //margin: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
          padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey),
              right: BorderSide.none,
              bottom: BorderSide(color: Colors.grey),
              left: BorderSide(color: Colors.grey),
            ),
            color: Color(0xFFEEEEEE),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Nhanh tay nào! Có ${state.listPromotionsValidForUser.length} khuyến mãi đang chờ nè",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13.0,
                      color: Color(0xFF5B5B5B)),
                  textAlign: TextAlign.left,
                ),
              ),
              const Positioned(
                  right: 0,
                  child: CustomPaint(
                    size: Size(1, 50),
                    painter: ZigZacVerticalLine(),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _categoryList(List<CategoryVM> categories) {
    log("Rebuild CategoryList with count = ${categories.length}");
    return Container(
      color: Colors.white,
      height: 100,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4, // 5 vì có thêm mục "Tất Cả"
        itemBuilder: (BuildContext context, int index) {
          if (index < 3) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: CategoryItem(
                  categories[index].name!,
                  categories[index].imagePath!,
                  categories[index].id!,
                  categories),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: CategoryItem(
                "Tất Cả",
                'a49ee469-c8e9-425f-b365-dcb86907b8cd.png', 
                99,
                categories,
              ),
            );
          }
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class CategoryItem extends StatelessWidget {
  Color transparentColor = const Color(0xFF00B14F);
  final String name;
  final String image;
  final int id;
  final List<CategoryVM> _listCategory;
  CategoryItem(this.name, this.image, this.id, this._listCategory);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (id == 99) {
          // Nếu id là 99, hiển thị bottom sheet
          _showBottomSheet(context, _listCategory);
        } else {
          // Nếu id không phải 99, điều hướng đến CategoryPage
          context.read<CategoryBloc>().add(CategoryStatedEvent(id));
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return const CategoryPage();
          }));
        }
      },
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF00B14F), // Màu cho nửa trên
                    Color.fromARGB(181, 225, 233, 228), // Màu cho nửa dưới
                  ],
                  begin: Alignment.topCenter, // Bắt đầu gradient từ trên xuống
                  end: Alignment.bottomCenter, // Kết thúc gradient từ dưới lên
                ),
                //border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(50),
                color: transparentColor),
            width: 50,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: SizedBox(
                width: 30,
                height: 30,
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(
                    color: AppTheme.circleProgressIndicatorColor,
                  )),
                  imageUrl: "${AppConfigs.URL_Images}/$image",
                ),
              ),
            ),
          ),
          Container(
              //margin: EdgeInsets.symmetric(vertical: 5),
              child: Text(
            name,
            style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: Colors.black,
                fontFamily: 'Montserrat'),
          ))
        ],
      ),
    );
  }
}

void _showBottomSheet(BuildContext context, List<CategoryVM> categories) {
  showModalBottomSheet(
    context: context,
    isScrollControlled:
        true, // Allow content to scroll if it exceeds the height
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.0), // Bo góc trái trên
        topRight: Radius.circular(20.0), // Bo góc phải trên
      ),
    ),
    builder: (BuildContext context) {
      return Container(
        constraints: const BoxConstraints(maxHeight: 500),
        child: Stack(
          // Use Stack for more flexible content positioning
          children: [
            // Background color
            Positioned.fill(
              child: Container(
                color: Colors.blue[50], // Adjust background color as needed
              ),
            ),
            // Content with padding
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const ListTile(
                    title: Text(
                      "      Mời Bạn Xem Danh Mục Món Ăn",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, // Make title bolder
                          fontSize: 18.0,
                          color: Colors.green // Adjust title font size
                          ),
                    ),
                  ),

                  // Grid view with spacing
                  Expanded(
                    // Use Expanded to fill remaining space
                    child: GridView.builder(
                      shrinkWrap: true, // Optimize for content size
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4, // Number of columns
                        crossAxisSpacing: 10.0, // Column spacing
                        mainAxisSpacing: 10.0, // Row spacing
                      ),
                      itemCount: categories.length,
                      itemBuilder: (BuildContext context, int index) {
                        final category = categories[index];
                        return CategoryItemList(
                          category.name!,
                          category.imagePath!,
                          category.id!,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

class CategoryItemList extends StatelessWidget {
  final String name;
  final String image;
  final int id;

  CategoryItemList(this.name, this.image, this.id);

  @override
  Widget build(BuildContext context) {
    if (name == "Tất Cả") {
      return const SizedBox.shrink();
    }
    return GestureDetector(
      onTap: () {
        context.read<CategoryBloc>().add(CategoryStatedEvent(id));
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return const CategoryPage();
        }));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Container(
                    child: CachedNetworkImage(
                      imageUrl: "${AppConfigs.URL_Images}/$image",
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.circleProgressIndicatorColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.black,
                    fontFamily: 'Montserrat',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _priceWidget(FoodVM foodVM, SaleCampaignVM? saleCampaignVM) {
  if (saleCampaignVM == null) {
    return Text(
      AppConfigs.toPrice(foodVM.price),
      style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w200,
          color: Colors.black.withOpacity(0.9)),
    );
  } else {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.local_offer_outlined,
                  size: 14,
                  color: Colors.red,
                ),
                Text(
                  "${saleCampaignVM.percent.toInt()}% ",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            Text(
              AppConfigs.toPrice(foodVM.price),
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black.withOpacity(0.6),
                  decoration: TextDecoration.lineThrough),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: Text(
              AppConfigs.toPrice(
                  foodVM.price * (100 - saleCampaignVM.percent) / 100),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 190, 79, 79),
              ),
              textAlign: TextAlign.left),
        ),
      ],
    );
  }
}

class _FoodWidget extends StatelessWidget {
  _FoodWidget({
    Key? key,
    required this.foodVM,
    this.saleCampaignVM,
    this.promotionVM,
  }) : super(key: key);
  final FoodVM foodVM;
  final SaleCampaignVM? saleCampaignVM;
  final PromotionVM? promotionVM;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      child: Card(
        elevation: 5,
        clipBehavior: Clip.antiAlias,
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return FoodDetail(
                  foodID: foodVM.id,
                  promotionID: promotionVM != null ? promotionVM!.id : null,
                );
              }));
            },
            child: Container(
              height:
                  220, // Increase the height to fit the "Add to Cart" button
              width: 125,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 110,
                    width: 125,
                    child: CachedNetworkImage(
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.circleProgressIndicatorColor,
                        ),
                      ),
                      imageUrl: "${AppConfigs.URL_Images}/${foodVM.imagePath}",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    width: 150,
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(7, 7, 7, 0),
                    child: Text(
                      foodVM.name,
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 7,
                    ),
                    width: 150,
                    child: _priceWidget(foodVM, saleCampaignVM),
                  ),
                  Spacer(),
                  Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.green, // Đặt màu nền là màu cam
                      //  shape: BoxShape.circle, // Đặt hình dạng là hình tròn
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
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BestSellingContainer extends StatelessWidget {
  final List<FoodVM> _listFoodVM;
  BestSellingContainer(this._listFoodVM);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      color: Colors.white,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0.0, 3.0, 8.0, 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Các món bán chạy".toUpperCase(),
                overflow: TextOverflow.clip,
                maxLines: 1,
                textAlign: TextAlign.left,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xFF141619),
                    fontFamily: 'Montserrat'),
              ),
            ),
          ),
          Column(
            children: List.generate(
              _listFoodVM.length,
              (index) => Column(
                children: [
                  FoodCard(foodVM: _listFoodVM[index]),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class PromotionContainer extends StatelessWidget {
  final List<PromotionVM> _listPromotionVM;
  PromotionContainer(this._listPromotionVM);
  @override
  Widget build(BuildContext context) {
    if (_listPromotionVM.length == 0) {
      return Container();
    }
    var _promotionVM = _listPromotionVM[0];
    return Container(
      //color: Colors.grey[50],
      padding: const EdgeInsets.fromLTRB(15.0, 3.0, 15.0, 50.0),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0.0, 3.0, 8.0, 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _promotionVM.name.toUpperCase(),
                overflow: TextOverflow.clip,
                maxLines: 1,
                textAlign: TextAlign.left,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xFF141619)),
              ),
            ),
          ),
          Container(
            //margin: const EdgeInsets.fromLTRB(20.0, 3.0, 8.0, 3.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _promotionVM.desciption!,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Color(0xFF646D7A), fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            height: 250,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _promotionVM.foodVMs.length,
                itemBuilder: (BuildContext context, int index) {
                  final foodVM = _promotionVM.foodVMs[index];

                  return _FoodWidget(
                    foodVM: foodVM,
                    promotionVM: _promotionVM,
                    saleCampaignVM: foodVM.saleCampaignVM,
                  );
                }),
          )
        ],
      ),
    );
  }
}

class SaleContainer extends StatelessWidget {
  final List<SaleCampaignVM> _listSaleCampaignVM;
  SaleContainer(this._listSaleCampaignVM);
  @override
  Widget build(BuildContext context) {
    if (_listSaleCampaignVM.length > 0) {
      var _saleCampaignVM = _listSaleCampaignVM[0];

      return Container(
        margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
        padding: const EdgeInsets.symmetric(vertical: 10),
        color: Colors.white,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _saleCampaignVM.name.toUpperCase(),
                  textAlign: TextAlign.left,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color(0xFF141619)),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _saleCampaignVM.desciption,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Color(0xFF646D7A)),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              height: 285,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _saleCampaignVM.foodVMs!.length,
                  itemBuilder: (BuildContext context, int index) {
                    final foodVM = _saleCampaignVM.foodVMs![index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: _FoodWidget(
                        foodVM: foodVM,
                        promotionVM: null,
                        saleCampaignVM: _saleCampaignVM,
                      ),
                    );
                  }),
            )
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}
