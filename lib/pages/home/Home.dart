//import 'package:carousel_pro/carousel_pro.dart';
import 'package:applicationecommerce/pages/chat/chatScreen.dart';
import 'package:flutter/material.dart';
import 'body.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/home";

  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyWebView()),
          );

          print('Floating Action Button pressed!');
        }, // Biểu tượng hiển thị bên trong nút
        backgroundColor: const Color(0xFF00B14F),
        child: const Icon(
          Icons.chat,
          color: Colors.white,
        ), // Màu nền của nút
      ),
    );
  }
}
