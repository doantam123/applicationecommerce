import 'dart:io';
import 'package:applicationecommerce/bloc/Address/AddressBloc.dart';
import 'package:applicationecommerce/bloc/Address/AddressEvent.dart';
import 'package:applicationecommerce/bloc/Cart/CartBloc.dart';
import 'package:applicationecommerce/bloc/Cart/CartEvent.dart';
import 'package:applicationecommerce/bloc/Category/CategoryBloc.dart';
import 'package:applicationecommerce/bloc/FoodDetail/FoodDetailBloc.dart';
import 'package:applicationecommerce/bloc/Home/HomeBloc.dart';
import 'package:applicationecommerce/bloc/Login/LoginBloc.dart';
import 'package:applicationecommerce/bloc/Login/LoginEvent.dart';
import 'package:applicationecommerce/bloc/OrderDetails/OrderDetailsBloc.dart';
import 'package:applicationecommerce/bloc/OrderHistory/OrderHistoryBloc.dart';
import 'package:applicationecommerce/bloc/Profile/ProfileBloc.dart';
import 'package:applicationecommerce/bloc/Promotions/PromotionBloc.dart';
import 'package:applicationecommerce/bloc/Promotions/PromotionEvent.dart';
import 'package:applicationecommerce/bloc/Search/SearchBloc.dart';
import 'package:applicationecommerce/bloc/SignUp/SignUpBloc.dart';
import 'package:applicationecommerce/configs/DevHttpsOveride.dart';
import 'package:applicationecommerce/pages/login_signup/Login.dart';
import 'package:applicationecommerce/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  //acept bad certificate request
  HttpOverrides.global = DevHttpOverrides();
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AddressBloc>(
            create: (_) => AddressBloc()..add(AddressStarted())),
        BlocProvider<CartBloc>(
            create: (_) => CartBloc()..add(CartStartedEvent())),
        BlocProvider<CategoryBloc>(create: (_) => CategoryBloc()),
        BlocProvider<FoodDetailBloc>(
            create: (_) =>
                FoodDetailBloc()), // no need to and started event here??
        BlocProvider<HomeBloc>(create: (_) => HomeBloc()),
        BlocProvider<OrderHistoryBloc>(create: (_) => OrderHistoryBloc()),
        BlocProvider<LoginBloc>(
            create: (_) => LoginBloc()..add(LoginStartedEvent())),
        BlocProvider<SearchBloc>(create: (_) => SearchBloc()),
        BlocProvider<PromotionBloc>(
            create: (_) => PromotionBloc()..add(PromotionStartedEvent())),
        BlocProvider<OrderDetailsBloc>(create: (_) => OrderDetailsBloc()),
        BlocProvider<ProfileBloc>(create: (_) => ProfileBloc()),
        BlocProvider<SignUpBloc>(create: (_) => SignUpBloc()),
        //BlocProvider<ChatBloc>(create: (_) => ChatBloc()),
      ],
      child: MaterialApp(
        title: 'Food Delivery',
        debugShowCheckedModeBanner: false,
        // theme: ThemeData(
        //   primarySwatch: Colors.blue,
        //   visualDensity: VisualDensity.adaptivePlatformDensity,
        // ),
        theme: basicTheme(),
        home: const LoginPage(),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
