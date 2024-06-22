import 'package:applicationecommerce/pages/food_detail/rating/user_details_with_image.dart';
import 'package:applicationecommerce/view_models/ratings/RatingVM.dart';
import 'package:flutter/material.dart';

class CommentsList extends StatelessWidget {
  final List<RatingVM> _listRatingVM;
  const CommentsList(this._listRatingVM, {super.key});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _listRatingVM.length,
      itemBuilder: (BuildContext context, int index) {
        //foodVM.ratin
        return _SingleComment(_listRatingVM[index]);
      },
    );
  }
}

class _SingleComment extends StatelessWidget {
  final RatingVM _ratingVM;
  const _SingleComment(this._ratingVM);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      //margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          UserDetailsWithFollow(
              _ratingVM.userFullName, _ratingVM.timeCreate, _ratingVM.star),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 5, 5, 5),
            child: Text(
              _ratingVM.comment,
              textAlign: TextAlign.left,
            ),
          ),
          const Divider(
            color: Colors.black45,
          ),
        ],
      ),
    );
  }
}
