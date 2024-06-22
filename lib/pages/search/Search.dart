import 'package:flutter/material.dart';

import 'Body.dart';

class Search extends StatelessWidget {
  final int? categoryID;
  const Search(this.categoryID, {super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: buildAppBar(context),
      body: SearchBody(categoryID),
    );
  }
}

AppBar buildAppBar(BuildContext context) {
  return AppBar(
    centerTitle: true,
    backgroundColor: Theme.of(context).primaryColor,
    title: Column(
      children: [
        Text(
          'Tìm kiếm',
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ],
    ),
  );
}
