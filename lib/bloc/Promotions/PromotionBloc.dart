import 'package:applicationecommerce/bloc/Promotions/PromotionEvent.dart';
import 'package:applicationecommerce/bloc/Promotions/PromotionState.dart';
import 'package:applicationecommerce/services/PromotionServices.dart';
import 'package:applicationecommerce/services/UserServices.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PromotionBloc extends Bloc<PromotionEvent, PromotionState> {
  final PromotionServices _promotionServices = PromotionServices();

  PromotionBloc() : super(PromotionLoadingState());

  @override
  Stream<PromotionState> mapEventToState(PromotionEvent event) async* {
    if (event is PromotionStartedEvent) {
      yield* _mapStartedEventToState(state, event);
    }
  }

  Stream<PromotionState> _mapStartedEventToState(
      PromotionState currentState, PromotionStartedEvent event) async* {
    //stard Promotion
    yield PromotionLoadingState();

    yield await _fetchAll();
  }

  Future<PromotionState> _fetchAll() async {
    var userID = UserServices.getUserID();
    var promotions = await _promotionServices.getAllValidForUser(userID);

    if (promotions.isSuccessed == false) {
      print(promotions.errorMessage);
      return PromotionErrorState(promotions.errorMessage!);
    }
    var listPromotions = promotions.payLoad!.items!;

    return PromotionLoadedState(listPromotions);
  }
}
