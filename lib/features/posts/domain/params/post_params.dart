import 'package:equatable/equatable.dart';

class PostParams extends Equatable {
  final int page;
  final int? limit;
  const PostParams({
    required this.page,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [
        page,
        limit,
      ];
}
