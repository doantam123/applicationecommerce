import 'package:applicationecommerce/bloc/Cart/CartBloc.dart';
import 'package:applicationecommerce/bloc/Cart/CartEvent.dart';
import 'package:applicationecommerce/bloc/Promotions/PromotionBloc.dart';
import 'package:applicationecommerce/bloc/Promotions/PromotionState.dart';
import 'package:applicationecommerce/configs/AppConfigs.dart';
import 'package:applicationecommerce/pages/home/AppLoadingScreen.dart';
import 'package:applicationecommerce/view_models/Promotions/PromotionVM.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const List<Key> keys = [Key('Network')];

class Body extends StatelessWidget {
  const Body({super.key});

  Widget _buildLoadedState(BuildContext context, PromotionLoadedState state) {
    return SafeArea(
      child: ListView.builder(
        itemCount: state.listPromotionVMs.length,
        itemBuilder: (context, index) {
          // return (totalPreis != null &&
          //         (totalPreis < state.listPromotionVMs[index].minPrice! ||
          //             totalPreis == 0))
          //     ? DisableItemPromotion(state.listPromotionVMs[index], totalPreis)
          //     : UseableItemPromotion(state.listPromotionVMs[index], totalPreis);
          return PromotionItem(state.listPromotionVMs[index]);
        },
      ),
    );
  }

  Widget _buildErrorState(PromotionErrorState state) {
    return Container(
        child: Center(
      child: Text(
        state.error,
      ),
    ));
  }

  Widget _buildLoadingState() {
    return const AppLoadingScreen();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PromotionBloc, PromotionState>(
      builder: (context, state) {
        if (state is PromotionLoadingState) {
          return _buildLoadingState();
        }
        if (state is PromotionLoadedState) {
          return _buildLoadedState(context, state);
        }
        if (state is PromotionErrorState) {
          return _buildErrorState(state);
        }
        throw "Unknow state";
      },
    );
  }
}

class PromotionItem extends StatelessWidget {
  final PromotionVM _promotionVM;

  const PromotionItem(this._promotionVM, {super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 5),
      child: SizedBox(
        height: 180,
        width: MediaQuery.of(context).size.width,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5), // Màu của bóng
                spreadRadius: 3, // Bán kính bóng
                blurRadius: 5, // Độ mờ của bóng
                offset: const Offset(0, 3), // Vị trí bóng (dx, dy)
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding:
                            const EdgeInsets.only(left: 5, top: 5, bottom: 5),
                        minimumSize: const Size.fromHeight(100),
                      ),
                      onPressed: () {
                        context
                            .read<CartBloc>()
                            .add(CartAddPromotionEvent(_promotionVM.id));
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "Đã áp dụng mã khuyến mãi vào giỏ hàng")));
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                _promotionVM.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 17),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              child: Row(
                                children: [
                                  const Text(
                                    "CODE: ",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  Center(
                                      child: Text(
                                    _promotionVM.code,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal),
                                  )),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  const Text(
                                    "HSD: ",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    AppConfigs.AppDateFormat.format(
                                        _promotionVM.endDate),
                                    style: const TextStyle(
                                        color: Color(0xFF00B14F),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    key: keys[0],
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => promotionDetail(_promotionVM));
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 20, 0),
                      child: Stack(children: [
                        const SizedBox(
                          height: 100,
                          width: 120,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("images/voucher.png"),
                                    fit: BoxFit.fill)),
                          ),
                        ),
                        Positioned(
                            top: 10,
                            right: 42,
                            child: Center(
                              child: Column(
                                children: [
                                  Text(
                                    "${(_promotionVM.percent).round()}%",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                  const Text(
                                    "OFF",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  )
                                ],
                              ),
                            ))
                      ]),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Divider(
                  thickness: 1,
                ),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => promotionDetail(_promotionVM));
                },
                child: const Text(
                  "Xem",
                  style: TextStyle(
                      color: Color(0xFF00B14F),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Dialog promotionDetail(PromotionVM promotionVM) {
  return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            //height: 200,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: Colors.white),
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(promotionVM.name,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              const SizedBox(height: 20),
              Text(promotionVM.desciption.toString(),
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700)),
              Text("\nĐiều kiện:",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700)),
              const SizedBox(height: 3),
              Text(
                  "Thời gian: ${AppConfigs.AppDateFormat.format(promotionVM.startDate)} -> ${AppConfigs.AppDateFormat.format(promotionVM.endDate)}",
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700)),
              const SizedBox(height: 3),
              Text(
                  "Áp dụng cho đơn hàng từ: ${AppConfigs.toPrice(promotionVM.minPrice!)}",
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700)),
              const SizedBox(height: 3),
              Text("Tối đa: ${AppConfigs.toPrice(promotionVM.max!)}",
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700)),
              const SizedBox(height: 3),
              Row(
                children: [
                  Text("Số lần sử dụng: ${promotionVM.useTimes}",
                      style:
                          TextStyle(fontSize: 14, color: Colors.grey.shade700)),
                  Text(" (Đã sử dụng ${promotionVM.timeUsedByCurrentUser} lần)",
                      style: const TextStyle(fontSize: 14, color: Colors.red)),
                ],
              ),
            ]),
          ),
        ],
      ));
}
