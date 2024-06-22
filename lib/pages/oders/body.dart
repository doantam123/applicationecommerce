import 'package:applicationecommerce/bloc/OrderHistory/OrderHistoryBloc.dart';
import 'package:applicationecommerce/bloc/OrderHistory/OrderHistoryEvent.dart';
import 'package:applicationecommerce/bloc/OrderHistory/OrderHistoryState.dart';
import 'package:applicationecommerce/pages/home/AppLoadingScreen.dart';
import 'package:applicationecommerce/view_models/Orders/OrderVM.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'OrderItem.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with SingleTickerProviderStateMixin {
  late TabController _tabController; // = TabController(length: 1, vsync: this);

  final List<Tab> myTabs = [
    const Tab(
      text: 'Đang xử lý',
    ),
    const Tab(
      text: 'Lịch sử',
    ),
  ];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildLoadedState(
      BuildContext context, OrderHistoryLoadedState state) {
    return Container(
      child: Container(
        child: Column(
          children: [
            TabBar(
              //indicatorColor: Theme.of(context).indicatorColor,
              tabs: myTabs,
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  IncomingOrder(state.incomingItems),
                  HistoryOrder(state.completedItems)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, OrderHistoryErrorState state) {
    return Container(
      child: Center(
        child: Text(state.error),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderHistoryBloc, OrderHistoryState>(
        builder: (context, state) {
      if (state is OrderHistoryLoadingState) {
        return const AppLoadingScreen();
      } else if (state is OrderHistoryLoadedState) {
        return _buildLoadedState(context, state);
      } else if (state is OrderHistoryErrorState) {
        return _buildErrorState(context, state);
      } else {
        throw "Unknow state!";
      }
    });
  }
}

class HistoryOrder extends StatelessWidget {
  final List<OrderVM> items;
  const HistoryOrder(this.items, {super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<OrderHistoryBloc>().add(OrderHistoryRefreshEvent());
        },
        child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return OrderItem(items[index]);
            }),
      ),
    );
  }
}

class IncomingOrder extends StatelessWidget {
  final List<OrderVM> items;
  const IncomingOrder(this.items, {super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<OrderHistoryBloc>().add(OrderHistoryRefreshEvent());
        },
        child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return OrderItem(items[index]);
            }),
      ),
    );
  }
}
