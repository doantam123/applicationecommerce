import 'package:applicationecommerce/bloc/Cart/CartBloc.dart';
import 'package:applicationecommerce/bloc/Cart/CartEvent.dart';
import 'package:applicationecommerce/bloc/Cart/CartState.dart';
import 'package:applicationecommerce/configs/AppConfigs.dart';
import 'package:applicationecommerce/pages/adress/Address.dart';
import 'package:applicationecommerce/pages/cart/CheckoutBar.dart';
import 'package:applicationecommerce/pages/food_detail/FoodDetail.dart';
import 'package:applicationecommerce/pages/home/AppLoadingScreen.dart';
import 'package:applicationecommerce/pages/presentation/LightColor.dart';
import 'package:applicationecommerce/pages/presentation/themes.dart';
import 'package:applicationecommerce/view_models/Addresses/AddressVM.dart';
import 'package:applicationecommerce/view_models/Carts/CartVM.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  Widget _priceWidget(CartVM cartVM) {
    if (cartVM.foodVM.saleCampaignVM != null) {
      double discount = cartVM.foodVM.saleCampaignVM!.percent;
      return Row(
        children: <Widget>[
          // Text('\$ ',
          //     style: TextStyle(
          //       color: LightColor.red,
          //       fontSize: 12,
          //     )),
          Text(
              "${AppConfigs.toPrice(cartVM.foodVM.price * cartVM.quantity * (100 - discount) / 100)}  ",
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          Text(AppConfigs.toPrice(cartVM.foodVM.price * cartVM.quantity),
              style: const TextStyle(
                  fontSize: 14, decoration: TextDecoration.lineThrough)),
        ],
      );
    }
    return Row(
      children: <Widget>[
        // Text('\$ ',
        //     style: TextStyle(
        //       color: LightColor.red,
        //       fontSize: 12,
        //     )),
        Text(AppConfigs.toPrice(cartVM.foodVM.price * cartVM.quantity),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _item(CartVM model, BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // context
        //     .read<FoodDetailBloc>()
        //     .add(FoodDetailStartedEvent(model.foodID));
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return FoodDetail(foodID: model.foodID, promotionID: null);
        }));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 3),
        decoration:
            const BoxDecoration(color: Colors.white, boxShadow: <BoxShadow>[
          BoxShadow(
            blurRadius: 3.0,
            color: Colors.black12,
            //offset: new Offset(0.0, 10.0))
          )
        ]),
        height: 80,
        child: Row(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1.2,
              child: Container(
                  padding: const EdgeInsets.all(10.0),
                  height: 70,
                  width: 70,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(
                              color: AppTheme.circleProgressIndicatorColor)),
                      imageUrl:
                          "${AppConfigs.URL_Images}/${model.foodVM.imagePath}",
                    ),
                  )),
            ),
            Expanded(
                child: ListTile(
                    title: Text(
                      model.foodVM.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: _priceWidget(model),
                    trailing: Container(
                      width: 35,
                      height: 35,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: LightColor.lightGrey.withAlpha(150),
                          borderRadius: BorderRadius.circular(10)),
                      child: Text('x${model.quantity}',
                          style: const TextStyle(
                            fontSize: 12,
                          )),
                    )))
          ],
        ),
      ),
    );
  }

  Widget totalSession(BuildContext context, CartLoadedState state) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Tổng số lượng: ",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                " (${state.getTotalProduct()} sản phẩm)",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const Spacer(),
              Text(
                AppConfigs.toPrice(
                  state.getTotalPrice(),
                ),
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ],
          ),
          Row(
            children: [
              Text(
                "Mã giảm giá: ",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const Spacer(),
              Text(
                "-${AppConfigs.toPrice(state.getPromotedAmount())}",
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget addressSession(BuildContext context, AddressVM? addressVM) {
    return Container(
      //height: 150,
      child: Column(
        children: [
          SizedBox(
            height: 100,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(10, 10, 0, 5),
                        child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Color(0xffFE724C),
                                ),
                                Text(
                                  "Địa điểm nhận hàng",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ),
                              ],
                            )),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(35, 0, 0, 10),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              addressVM == null
                                  ? "Không tìm thấy địa chỉ nào!"
                                  : addressVM.addressString,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 197, 56, 0),
                                  fontSize: 18),
                            )),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    //await context.read<AddressBloc>().fetchAll();
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return AddressScreen(
                        addressScreenCallBack:
                            (AddressVM addressVM, BuildContext context) async {
                          context
                              .read<CartBloc>()
                              .add(CartSetAddressEvent(addressVM));

                          Navigator.of(context).pop();
                        },
                      );
                    }));
                  },
                  child: const SizedBox(
                    width: 80,
                    child: Text(
                      "SỬA",
                      style: TextStyle(
                          color: Color.fromARGB(255, 243, 107, 16),
                          fontSize: 22),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            thickness: 2,
            height: 16,
            //indent: 20,
            //endIndent: 20,
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 0, 10),
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

  _buildLoadedState(BuildContext context, CartLoadedState state) {
    var carts = state.listCartVM;

    return Scaffold(
      bottomNavigationBar: CheckoutBar(
        state: state,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<CartBloc>().add(CartRefreshdEvent());
        },
        child: ListView.builder(
          itemCount: carts.length + 2,
          itemBuilder: (context, index) {
            if (index == 0) {
              return addressSession(context, state.address);
            } else if (index == carts.length + 1) {
              return totalSession(context, state);
            }

            return Dismissible(
              key: ObjectKey(carts[index - 1]),
              direction: DismissDirection.endToStart,
              background: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFE6E6),
                  ),
                  child: const Row(
                    children: [
                      Spacer(),
                      Icon(
                        Icons.delete,
                        color: Colors.red,
                      )
                    ],
                  )),
              onDismissed: (direction) async {
                context
                    .read<CartBloc>()
                    .add(CartDeletedEvent(carts[index - 1].foodID));
              },
              child: _item(carts[index - 1], context),
            );
          },
        ),
      ),
    );
  }

  _buildErrorState(BuildContext context, CartErrorState state) {
    return Container(
      child: Center(
        child: Text(state.error),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(builder: (context, state) {
      //return _buildErrorState(context, CartErrorState("test error"));
      if (state is CartLoadingState) {
        return const AppLoadingScreen();
      }
      if (state is CartLoadedState) {
        return _buildLoadedState(context, state);
      }
      if (state is CartErrorState) {
        return _buildErrorState(context, state);
      }
      throw "Unknow state";
    });
  }
}
