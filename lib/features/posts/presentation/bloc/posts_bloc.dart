import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ninjaz_application/features/posts/data/models/posts_summary_response_page.dart';
import 'package:ninjaz_application/features/posts/domain/entities/post.dart';
import 'package:ninjaz_application/features/posts/domain/params/post_params.dart';

import '../../../../core/enums/request_state.dart';
import '../../../../core/network/failure.dart';
import '../../domain/usecases/posts_usecase.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final GetPostsUseCase getUseCase;
  int currentPageNumber = 0;
  bool hasReachedMax = false;
  bool isRefresh = false;
  RequestStatus requestStatus = RequestStatus.loading;
  PostsBloc(this.getUseCase)
      : super(const PostsState(
          posts: [],
          status: RequestStatus.loading,
          hasReachedMax: false,
          errorMessage: '',
        )) {
    on<PostsEvent>((event, emit) async {
      if (event is GetPostsEvent) {
        isRefresh = event.isRefresh;
        if (event.isRefresh) {
          currentPageNumber = 1;
        } else {
          currentPageNumber = currentPageNumber + 1;
        }
      }
      if (hasReachedMax && !isRefresh) return;
      if (state.status == RequestStatus.loading) {
        final Either<Failure, PostsSummaryResponsePage> response =
            await getUseCase(p: PostParams(page: currentPageNumber));
        response.fold(
            (l) => emit(state.copyWith(
                posts: null,
                status: RequestStatus.error,
                hasReachedMax: false,
                errorMessage: l.message)),
            (r) => emit(state.copyWith(
                posts: r.data as List<Post>,
                status: RequestStatus.success,
                hasReachedMax: state.posts.length == r.total,
                errorMessage: '',
                currentPageNumber: r.page)));
      } else {
        final Either<Failure, PostsSummaryResponsePage> posts =
            await getUseCase(p: PostParams(page: currentPageNumber));
        posts.fold(
            (l) => emit(state.copyWith(
                posts: null,
                status: RequestStatus.error,
                hasReachedMax: false,
                errorMessage: l.message)), (r) {
          if (isRefresh) {
            return emit(state.copyWith(
                posts: r.data as List<Post>,
                status: RequestStatus.success,
                hasReachedMax: state.posts.length == r.total,
                errorMessage: ''));
          } else {
            final postsList = r.data as List<Post>;

            return emit(state.copyWith(
                posts: List.of(state.posts)..addAll(postsList),
                status: RequestStatus.success,
                hasReachedMax: state.posts.length == r.total,
                errorMessage: ''));
          }
        });
      }
    });
  }
}
