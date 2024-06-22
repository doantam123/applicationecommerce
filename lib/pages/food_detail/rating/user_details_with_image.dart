import 'package:applicationecommerce/pages/commons/StarRating.dart';
import 'package:applicationecommerce/pages/food_detail/rating/user_details.dart';
import 'package:flutter/material.dart';

class UserDetailsWithFollowKeys {
  static const ValueKey userDetails = ValueKey("UserDetails");
  static const ValueKey follow = ValueKey("follow");
}

class UserDetailsWithFollow extends StatelessWidget {
  final String _userFullName;
  final DateTime _dateCreated;
  final int _star;
  const UserDetailsWithFollow(this._userFullName, this._dateCreated, this._star,
      {super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: UserDetails(_userFullName, _dateCreated),
        ),
        Expanded(
          flex: 1,
          child: Container(
            key: UserDetailsWithFollowKeys.follow,
            alignment: Alignment.centerRight,
            child: StarRating(
              rating: _star.toDouble(),
            ),
          ),
        ),
      ],
    );
  }
}
