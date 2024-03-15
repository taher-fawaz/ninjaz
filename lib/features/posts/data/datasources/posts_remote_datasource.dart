import 'package:ninjaz_application/core/network/ninjaz_rest.dart';

import '../../../../../core/network/api_response_model.dart';
import '../../../../../core/network/api_url.dart';

abstract class IPostsRemoteDataSource {
  Future<ApiResponse> getPosts({int? limit, required int page});
}

class PostsRemoteDataSourceImpl implements IPostsRemoteDataSource {
  final INinjazRest rest;

  PostsRemoteDataSourceImpl(this.rest);

  @override
  Future<ApiResponse> getPosts({int? limit = 20, required int page}) async {
    final response = await rest.get(
      '${ApiURLs.baseUrl}${ApiURLs.postsPath}?limit=$limit&page=$page',
    );
    return response;
  }
}
