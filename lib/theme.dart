import 'package:flutter/material.dart';

ThemeData basicTheme() {
  TextTheme basicTextTheme(TextTheme base) {
    return base.copyWith(
        displayLarge: base.displayLarge!.copyWith(
            // font for header
            fontSize: 22.0,
            color: Colors.white,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600),
        bodyLarge: base.bodyLarge!.copyWith(
            // font for bodytext
            fontSize: 12,
            color: Colors.grey,
            fontFamily: 'Montserrat'),
        displayMedium: base.displayMedium!.copyWith(
            // font for text link
            fontSize: 12,
            color: Colors.blueAccent,
            fontFamily: 'Montserrat'),
        labelLarge: base.labelLarge!.copyWith(
            // font for text of button
            fontSize: 15,
            color: Colors.white,
            fontFamily: 'Montserrat'),
        displaySmall: base.displaySmall!.copyWith(
            // font for text of bodytext
            fontSize: 15,
            color: Colors.black,
            fontFamily: 'Montserrat'));
    // headline4: base.headline4!.copyWith(
    //     // font for text of button
    //     fontSize: 12,
    //     color: Colors.green,
    //     fontFamily: 'Montserrat'));
  }

  final ThemeData base = ThemeData.light();
  return base.copyWith(
    textTheme: basicTextTheme(base.textTheme),
    primaryColor: const Color(0xFF00B14F), // Header Colors
    highlightColor: const Color(0xFF00B14F), // primary colors button
    indicatorColor: const Color(0xFF00B14F), // line color when hover input
    bottomNavigationBarTheme: base.bottomNavigationBarTheme.copyWith(
        selectedItemColor: const Color(0xFF00B14F), unselectedItemColor: Colors.grey),
    tabBarTheme: base.tabBarTheme.copyWith(
      labelColor: const Color(0xFF00B14F),
      labelStyle: const TextStyle(fontFamily: 'Montserrat'), //label color
      unselectedLabelStyle: const TextStyle(fontFamily: 'Montserrat'),
      unselectedLabelColor: Colors.black, // unselected label of Tabbar color
      indicator: const ShapeDecoration(
        shape: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFF00B14F),
          ), // underline color of TabBaritem
        ),
      ),
    ),
    iconTheme: const IconThemeData(
      // icon colors
      color: Colors.black,
    ),
    inputDecorationTheme: base.inputDecorationTheme.copyWith(
      // focusedBorder: UnderlineInputBorder(
      //   borderSide: BorderSide(color: Colors.redAccent),
      // ),
      labelStyle:
          const TextStyle(color: Colors.grey, fontFamily: 'Montserrat', fontSize: 12),
    ),
    textSelectionTheme: base.textSelectionTheme.copyWith(
      cursorColor: const Color(0xFF00B14F),
    ),
  );
}
