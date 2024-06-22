import 'package:applicationecommerce/helper/commons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserDetails extends StatelessWidget {
  final String _userFullName;
  final DateTime _dateCreated;
  const UserDetails(this._userFullName, this._dateCreated, {super.key});
  @override
  Widget build(BuildContext context) {
    return InheritedUserModel(
      child: Container(
        child: Row(children: <Widget>[
          _UserImage(),
          _UserNameAndEmail(_userFullName, _dateCreated)
        ]),
      ),
    );
  }
}

class _UserNameAndEmail extends StatelessWidget {
  final String _userFullName;
  final DateTime _dateCreated;
  const _UserNameAndEmail(this._userFullName, this._dateCreated);
  @override
  Widget build(BuildContext context) {
    final TextStyle nameTheme = Theme.of(context).textTheme.titleSmall!;
    const TextStyle emailTheme =
        TextStyle(fontSize: 10, fontWeight: FontWeight.w300);
    final int flex = isLandscape(context) ? 10 : 5;

    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(6, 0, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(_userFullName, style: nameTheme),
            const SizedBox(height: 2.0),
            Text(DateFormat.yMMMd().format(_dateCreated), style: emailTheme),
          ],
        ),
      ),
    );
  }
}

class _UserImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Expanded(
      flex: 1,
      child: CircleAvatar(backgroundImage: AssetImage("images/cat.jpg")),
    );
  }
}

class InheritedUserModel extends InheritedWidget {
  @override
  final Widget child;

  const InheritedUserModel({super.key, required this.child})
      : super(child: child);

  static InheritedUserModel of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<InheritedUserModel>()
        as InheritedUserModel);
  }

  @override
  bool updateShouldNotify(InheritedUserModel oldWidget) {
    return true;
  }
}
