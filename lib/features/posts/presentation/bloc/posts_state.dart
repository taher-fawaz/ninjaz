part of 'posts_bloc.dart';

class PostsState extends Equatable {
  final RequestStatus status;
  final List<Post> posts;
  final bool hasReachedMax;
  final String errorMessage;

  const PostsState({
    this.posts = const [],
    this.status = RequestStatus.loading,
    this.hasReachedMax = false,
    this.errorMessage = '',
  });
  PostsState copyWith({
    RequestStatus? status,
    List<Post>? posts,
    bool? hasReachedMax,
    String? errorMessage,
    int? currentPageNumber,
  }) {
    return PostsState(
      posts: posts ?? this.posts,
      status: status ?? this.status,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
        status,
        posts,
        hasReachedMax,
        errorMessage,
      ];
}
