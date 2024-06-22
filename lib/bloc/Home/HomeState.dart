import 'package:applicationecommerce/view_models/Categories/CategoryVM.dart';
import 'package:applicationecommerce/view_models/Foods/FoodVM.dart';
import 'package:applicationecommerce/view_models/Promotions/PromotionVM.dart';
import 'package:applicationecommerce/view_models/SaleCampaigns/SaleCampaignVM.dart';

abstract class HomeState {}

class HomeLoadingState extends HomeState {}

class HomeLoadedState extends HomeState {
  final List<CategoryVM> listCategory;
  final List<PromotionVM> listPromotionsValidForUser;
  final List<PromotionVM> listPromotionsValid; //valid for all user
  final List<SaleCampaignVM> listSaleCampaign;
  final List<FoodVM> listBestSellingFood;
  HomeLoadedState(
      this.listCategory,
      this.listPromotionsValidForUser,
      this.listPromotionsValid,
      this.listSaleCampaign,
      this.listBestSellingFood);
}

class HomeErrorState extends HomeState {
  final String error;
  HomeErrorState(this.error);
}