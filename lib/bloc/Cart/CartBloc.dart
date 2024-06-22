import 'package:applicationecommerce/bloc/Cart/CartEvent.dart';
import 'package:applicationecommerce/bloc/Cart/CartState.dart';
import 'package:applicationecommerce/services/AddressServices.dart';
import 'package:applicationecommerce/services/CartServices.dart';
import 'package:applicationecommerce/services/OrderServices.dart';
import 'package:applicationecommerce/services/PromotionServices.dart';
import 'package:applicationecommerce/services/UserServices.dart';
import 'package:applicationecommerce/view_models/Addresses/AddressVM.dart';
import 'package:applicationecommerce/view_models/Carts/CartVM.dart';
import 'package:applicationecommerce/view_models/Orders/OrderCreateVM.dart';
import 'package:applicationecommerce/view_models/Orders/OrderVM.dart';
import 'package:applicationecommerce/view_models/Promotions/PromotionVM.dart';
import 'package:applicationecommerce/view_models/commons/ApiResult.dart';
// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartLoadingState());

  final CartServices _cartServices = CartServices();
  final AddressServices _addressServices = AddressServices();
  final OrderServices _orderServices = OrderServices();
  final PromotionServices _promotionServices = PromotionServices();
  int? _promotionID;
  PromotionVM? promotionVM;

  @override
  Stream<CartState> mapEventToState(CartEvent event) async* {
    if (event is CartStartedEvent) {
      yield* _mapStartedEventToState(state);
    } else if (event is CartDeletedEvent) {
      yield* _mapDeletedEventToState(event, state);
      // } else if (event is CartCreatedEvent) {
      //   yield* _mapCreatedEventToState(event, state);
      // } else if (event is CartConfirmEvent) {
      //   yield* _mapConfirmEventToState(event, state);
    } else if (event is CartSetAddressEvent) {
      yield* _mapSetAddressEventToState(event, state);
    } else if (event is CartRefreshdEvent) {
      yield* _mapRefreshEventToState();
    } else if (event is CartAddPromotionEvent) {
      yield* _mapAddPromotionEventToState(event, state);
    } else if (event is CartRemovePromotionEvent) {
      _promotionID = null;
      promotionVM = null;
      yield await _fetchAll();
    }
  }

  Stream<CartState> _mapAddPromotionEventToState(
      CartAddPromotionEvent event, CartState state) async* {
    _promotionID = event.promotionID;
    promotionVM = null;
    if (state is CartLoadedState) {
      yield await _fetchAll();
    }
  }


  Stream<CartState> _mapDeletedEventToState(
      CartDeletedEvent event, CartState state) async* {
    if (state is CartLoadedState) {
      final String userID = UserServices.getUserID();
      var result = await _cartServices.delete(event.foodID, userID);

      if (result.isSuccessed) {
        yield await _fetchAll();
      } else {
        yield CartErrorState(result.errorMessage!);
      }
    }
  }

  Stream<CartState> _mapSetAddressEventToState(
      CartSetAddressEvent event, CartState state) async* {
    if (state is CartLoadedState) {
      var loadedState = await _fetchAll();
      yield CartLoadedState(
          event.addressVM, loadedState.listCartVM, loadedState.promotionVM);
    }
  }

  // Stream<CartState> _mapConfirmEventToState(
  //     CartConfirmEvent event, CartState state) async* {
  //   if (state is CartLoadedState) {
  //     var result = await confirm(event);
  //     if (result.isSuccessed == true) {
  //       yield await _fetchAll();
  //     } else {
  //       yield CartErrorState(result.errorMessage!);
  //     }
  //   }
  // }

  Stream<CartState> _mapStartedEventToState(CartState currentState) async* {
    if ((currentState is CartLoadedState) == false) {
      yield CartLoadingState();
    }

    yield await _fetchAll();
  }

  Stream<CartState> _mapRefreshEventToState() async* {
    yield await _fetchAll();
  }

  Future<CartLoadedState> _fetchAll() async {
    var listCartVM = await _fetchCartItems();
    var address = await _fetchAddress();
    promotionVM = await _fetchPromotion(_promotionID);


    // if (promotionVM != null && promotionVM.minPrice! > total) {
    //   print(
    //       "Disable promotion due to invalid condition: ${promotionVM.minPrice!} <= $total");
    //   promotionVM = null;
    //   _promotionID = null;
    // }

    return CartLoadedState(address, listCartVM, promotionVM);
  }

  Future<List<CartVM>> _fetchCartItems() async {
    //items.clear();
    final String userID = UserServices.getUserID();
    var result = await _cartServices.getAllByUserID(userID);
    if (result.isSuccessed == true) {
      return (result.payLoad!.items!);
    }

    throw result.errorMessage!;
  }

  Future<PromotionVM?> _fetchPromotion(int? promotionID) async {
    if (promotionID != null) {
      var promotion = await _promotionServices.getByID(promotionID);
      if (promotion.isSuccessed) {
        return promotion.payLoad;
      }
    }

    return null;
  }

  Future<AddressVM?> _fetchAddress() async {
    final String userID = UserServices.getUserID();
    var getAddressResult = await _addressServices.getAddressOfUser(userID);
    if (getAddressResult.isSuccessed) {
      if (getAddressResult.payLoad != null &&
          getAddressResult.payLoad!.items != null &&
          getAddressResult.payLoad!.items!.isNotEmpty) {
        return getAddressResult.payLoad!.items![0];
      }
    }
    return null;
  }

  Future<ApiResult<OrderVM>> confirm(
      String addressString, String addressName, int? promotionID) async {
    final String userID = UserServices.getUserID();

    var result = await _orderServices.create(OrderCreateVM.explicit(
        appUserID: userID,
        isPaid: false,
        orderStatusID: 2,
        addressString: addressString,
        addressName: addressName,
        promotionID: promotionID));
    if (result.isSuccessed) {
      _promotionID = null;
    }
    return result;
  }
}
