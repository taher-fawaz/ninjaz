import 'package:dartz/dartz.dart';
import 'package:ninjaz_application/features/posts/data/models/posts_summary_response_page.dart';
import 'package:ninjaz_application/features/posts/domain/params/post_params.dart';

import '../../../../core/network/failure.dart';
import '../../../../core/uscecase/usecase.dart';
import '../repositories/posts_repository.dart';

class GetPostsUseCase
    extends UseCase<Either<Failure, PostsSummaryResponsePage>, PostParams?> {
  final IPostsRepository repository;
  GetPostsUseCase(this.repository);
  @override
  Future<Either<Failure, PostsSummaryResponsePage>> call(
      {PostParams? p}) async {
    final res = await repository.getPosts(limit: p?.limit, page: p!.page);
    return res;
  }
}
