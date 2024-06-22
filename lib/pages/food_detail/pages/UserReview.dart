import 'package:applicationecommerce/pages/food_detail/rating/rating_list.dart';
import 'package:applicationecommerce/view_models/ratings/RatingVM.dart';
import 'package:flutter/material.dart';

class UserReview extends StatelessWidget {
  final List<RatingVM> _listRatingVM;
  const UserReview(this._listRatingVM, {super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Center(child: CommentsList(_listRatingVM)),
      ),
    );
  }
}
