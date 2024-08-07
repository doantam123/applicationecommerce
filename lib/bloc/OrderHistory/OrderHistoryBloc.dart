import 'package:applicationecommerce/bloc/OrderHistory/OrderHistoryEvent.dart';
import 'package:applicationecommerce/bloc/OrderHistory/OrderHistoryState.dart';
import 'package:applicationecommerce/services/OrderServices.dart';
import 'package:applicationecommerce/services/UserServices.dart';
import 'package:applicationecommerce/view_models/Orders/OrderVM.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderHistoryBloc extends Bloc<OrderHistoryEvent, OrderHistoryState> {
  OrderHistoryBloc() : super(OrderHistoryLoadingState());
  final OrderServices _orderServices = OrderServices();
  @override
  Stream<OrderHistoryState> mapEventToState(OrderHistoryEvent event) async* {
    if (event is OrderHistoryStartedEvent) {
      yield* _mapStartedEventToState(event, state);
    }
    if (event is OrderHistoryRefreshEvent) {
      yield* _mapRefeshEventToState(event);
    }
  }

  Stream<OrderHistoryState> _mapStartedEventToState(
      OrderHistoryEvent event, OrderHistoryState currentState) async* {
    if ((currentState is OrderHistoryLoadedState) == false) {
      yield OrderHistoryLoadingState();
    }
    yield await _fetchAll();
  }

  Stream<OrderHistoryState> _mapRefeshEventToState(
      OrderHistoryEvent event) async* {
    yield await _fetchAll();
  }

  Future<OrderHistoryState> _fetchAll() async {
    List<OrderVM> allItems = [];
    List<OrderVM> incomming = [];
    List<OrderVM> completed = [];
    final String userID = UserServices.getUserID();
    var result = await _orderServices.getAllByUserID(userID);
    if (result.isSuccessed == true) {
      if (result.payLoad != null) allItems = (result.payLoad!);
      for (var item in allItems) {
        if (item.orderStatusID != 4 && item.orderStatusID != 5) {
          incomming.add(item);
        } else {
          completed.add(item);
        }
      }
      return OrderHistoryLoadedState(incomming, completed);
    }
    return OrderHistoryErrorState(result.errorMessage!);
  }
}
