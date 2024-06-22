import 'package:applicationecommerce/view_models/Carts/CartVM.dart';
import 'package:applicationecommerce/view_models/Foods/FoodVM.dart';
import 'package:applicationecommerce/view_models/Promotions/PromotionVM.dart';
import 'package:applicationecommerce/view_models/ratings/RatingVM.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class FoodDetailState {}

class FoodDetailLoadingState extends FoodDetailState {}

class FoodDetailLoadedState extends FoodDetailState {
  final List<RatingVM> userRatingList;
  final FoodVM foodVM;
  final CartVM? cartVM;
  final PromotionVM? promotionVM;

  FoodDetailLoadedState(
      this.foodVM, this.userRatingList, this.cartVM, this.promotionVM);
}

class FoodDetailErrorState extends FoodDetailState {
  final String error;
  FoodDetailErrorState(this.error);
}
