import 'package:ninjaz_application/core/network/api_response_model.dart';
import 'package:ninjaz_application/features/posts/domain/entities/post.dart';

class PostsSummaryResponsePage extends ApiResponse {
  const PostsSummaryResponsePage({
    final List<Post>? data,
    super.total,
    super.page,
    super.limit,
    super.error,
  }) : super(
          data: data,
        );
}
