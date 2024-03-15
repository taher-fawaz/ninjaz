part of 'posts_bloc.dart';

abstract class PostsEvent extends Equatable {
  const PostsEvent();

  @override
  List<Object> get props => [];
}

class GetPostsEvent extends PostsEvent {
  final bool isRefresh;
  const GetPostsEvent({
    this.isRefresh = false,
  });
}
