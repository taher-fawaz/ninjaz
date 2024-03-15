import 'package:dartz/dartz.dart';
import 'package:ninjaz_application/features/posts/data/models/posts_summary_response_page.dart';
import '../../../../../core/network/failure.dart';

abstract class IPostsRepository {
  Future<Either<Failure, PostsSummaryResponsePage>> getPosts(
      {int? limit, required int page});
}
