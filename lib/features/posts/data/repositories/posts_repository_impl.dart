import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ninjaz_application/features/posts/data/datasources/posts_local_datasource.dart';
import 'package:ninjaz_application/features/posts/data/models/post.dart';
import 'package:ninjaz_application/features/posts/data/models/posts_summary_response_page.dart';
import 'package:ninjaz_application/features/posts/data/models/realm.dart';
import 'package:ninjaz_application/features/posts/domain/entities/post.dart';
import '../../../../core/network/failure.dart';
import '../../domain/repositories/posts_repository.dart';
import '../datasources/posts_remote_datasource.dart';

class PostsRepositoryImpl extends IPostsRepository {
  final IPostsRemoteDataSource remoteDataSource;
  final IPostsLocalDataSource localDataSource;

  PostsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, PostsSummaryResponsePage>> getPosts(
      {int? limit, required int page}) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return getPostsLocally();
    } else {
      return getPostsRemotely(limit: limit, page: page);
    }
  }

  Either<Failure, PostsSummaryResponsePage> getPostsLocally() {
    final response = localDataSource.getPostsLocally();
    if (response.isEmpty) {
      return const Left(Failure(message: "empty_local_data"));
    } else {
      List<Post> postsList = [];
      for (var i = 0; i < response.length; i++) {
        postsList.add(Post.toPost(response[i]));
      }
      return Right(PostsSummaryResponsePage(
        data: postsList,
        total: postsList.length,
        page: 1,
        limit: postsList.length,
        error: null,
      ));
    }
  }

  Future<Either<Failure, PostsSummaryResponsePage>> getPostsRemotely(
      {int? limit, required int page}) async {
    try {
      var response = await remoteDataSource.getPosts(limit: limit, page: page);
      if (response.error == null) {
        final postsList =
            response.data?.map((e) => PostModel.fromJson(e)).toList();
        final postsResponsePage = PostsSummaryResponsePage(
          data: postsList,
          total: response.total,
          page: response.page,
          limit: response.limit,
          error: response.error,
        );
        localDataSource.storePostsLocally(postsList!);
        return Right(postsResponsePage);
      } else {
        return Left(Failure(message: response.error!));
      }
    } on DioException catch (_) {
      return const Left(Failure(message: "error_message"));
    }
  }
}
