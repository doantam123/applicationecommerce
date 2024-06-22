import 'package:applicationecommerce/view_models/Addresses/AddressCreateVM.dart';
import 'package:applicationecommerce/view_models/Addresses/AddressEditVM.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class AddressEvent {
  const AddressEvent();
}

class AddressStarted extends AddressEvent {}

class AddressDeleted extends AddressEvent {
  final int addressID;
  const AddressDeleted(this.addressID);
}

class AddressCreated extends AddressEvent {
  final AddressCreateVM addressCreateVM;
  const AddressCreated(this.addressCreateVM);
}

class AddressEdited extends AddressEvent {
  final AddressEditVM addressEditVM;
  const AddressEdited(this.addressEditVM);
}
