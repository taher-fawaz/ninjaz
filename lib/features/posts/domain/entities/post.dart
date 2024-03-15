import 'package:equatable/equatable.dart';
import 'package:ninjaz_application/features/posts/data/models/realm.dart';

import 'owner.dart';

class Post extends Equatable {
  final String id;
  final String image;
  final int likes;
  final List<String> tags;
  final String text;
  final DateTime publishDate;
  final Owner owner;

  const Post({
    required this.id,
    required this.image,
    required this.likes,
    required this.tags,
    required this.text,
    required this.publishDate,
    required this.owner,
  });

  factory Post.toPost(PostRealm postRealm) => Post(
      id: postRealm.id,
      image: postRealm.image,
      likes: postRealm.likes,
      text: postRealm.text,
      publishDate: postRealm.publishDate,
      tags: postRealm.tags.toString().split(",").toList(),
      owner: Owner(
          id: postRealm.owner!.id,
          title: postRealm.owner!.title,
          firstName: postRealm.owner!.firstName,
          lastName: postRealm.owner!.lastName,
          picture: postRealm.owner!.picture));

  @override
  List<Object> get props => [id, image, likes, tags, text, publishDate, owner];
}
