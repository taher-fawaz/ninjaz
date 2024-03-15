import 'dart:convert';

import 'package:ninjaz_application/features/posts/data/models/owner.dart';
import 'package:ninjaz_application/features/posts/domain/entities/post.dart';

class PostModel extends Post {
  const PostModel({
    required super.id,
    required super.image,
    required super.likes,
    required super.tags,
    required super.text,
    required super.publishDate,
    required super.owner,
  });

  factory PostModel.fromRawJson(String str) =>
      PostModel.fromJson(json.decode(str));

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        id: json["id"],
        image: json["image"],
        likes: json["likes"],
        tags: List<String>.from(json["tags"].map((x) => x)),
        text: json["text"],
        publishDate: DateTime.parse(json["publishDate"]),
        owner: OwnerModel.fromJson(json["owner"]),
      );
}
