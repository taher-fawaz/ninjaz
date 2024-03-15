import 'package:equatable/equatable.dart';
import 'package:realm/realm.dart'; // import realm package

part 'realm.g.dart'; // declare a part file.

@RealmModel()
class _OwnerRealm {
  late String id;
  late String title;
  late String firstName;
  late String lastName;
  late String picture;
}

@RealmModel()
class _PostRealm {
  late String id;
  late String image;
  late int likes;
  late String tags;
  late String text;
  late DateTime publishDate;
  _OwnerRealm? owner;
}
