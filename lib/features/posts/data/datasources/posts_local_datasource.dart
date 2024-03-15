import 'package:ninjaz_application/features/posts/data/models/realm.dart';
import 'package:ninjaz_application/features/posts/domain/entities/post.dart';
import 'package:realm/realm.dart';

abstract class IPostsLocalDataSource {
  RealmResults<PostRealm> getPostsLocally();
  void storePostsLocally(List<Post> posts);
}

class PostsLocalDataSourceImpl implements IPostsLocalDataSource {
  final Realm local;

  PostsLocalDataSourceImpl(this.local);

  @override
  RealmResults<PostRealm> getPostsLocally() {
    final response = local.all<PostRealm>();
    return response;
  }

  @override
  void storePostsLocally(List<Post> posts) {
    local.refresh();
    local.write(
      () {
        for (var post in posts) {
          local.add<PostRealm>(
            PostRealm(post.id, post.image, post.likes, post.tags.toString(),
                post.text, post.publishDate,
                owner: OwnerRealm(
                  post.owner.id,
                  post.owner.title,
                  post.owner.firstName,
                  post.owner.lastName,
                  post.owner.picture,
                )),
          );
        }
      },
    );
  }
}
