import 'dart:convert';

import '../../domain/entities/owner.dart';

class OwnerModel extends Owner {
  const OwnerModel({
    required super.id,
    required super.title,
    required super.firstName,
    required super.lastName,
    required super.picture,
  });

  factory OwnerModel.fromRawJson(String str) =>
      OwnerModel.fromJson(json.decode(str));

  factory OwnerModel.fromJson(Map<String, dynamic> json) => OwnerModel(
        id: json["id"],
        title: json["title"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        picture: json["picture"],
      );
}
