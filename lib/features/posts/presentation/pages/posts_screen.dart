import 'dart:async';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ninjaz_application/features/posts/domain/entities/post.dart';
import 'package:ninjaz_application/features/posts/presentation/bloc/posts_bloc.dart';
import 'package:ninjaz_application/features/posts/presentation/widgets/post_item_widget.dart';

import '../../../../core/common/widgets/pagination_list_widget.dart';
import '../../../../core/common/widgets/pagination_status_widget.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  late ScrollController scrollController;
  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    context
        .read<PostsBloc>()
        .add(const GetPostsEvent(isRefresh: true)); //* for fetching first page

    // scrollController.addListener(_onScroll);
  }

  // @override
  // void dispose() {
  //   scrollController
  //     ..removeListener(_onScroll)
  //     ..dispose();

  //   super.dispose();
  // }

  // void _onScroll() {
  //   final maxScroll = scrollController.position.maxScrollExtent;
  //   final currentScroll = scrollController.offset;

  //   if (currentScroll >= (maxScroll * 0.9)) {
  //     context.read<PostsBloc>().add(const GetPostsEvent(isRefresh: false));
  //   }
  // }

  EasyRefreshController _controller = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );
  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      controller: _controller,
      onRefresh: () {
        final completer = Completer<void>();
        context.read<PostsBloc>().add(const GetPostsEvent(isRefresh: true));
        _controller.finishRefresh();
        completer.complete();
      },
      onLoad: () async {
        final completer = Completer<void>();
        context.read<PostsBloc>().add(const GetPostsEvent(isRefresh: false));
        _controller.finishLoad();
        completer.complete();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: BlocBuilder<PostsBloc, PostsState>(
                builder: (context, state) {
                  return LoadingStatusWidget(
                    errorMessage: state.errorMessage,
                    requestStatus: state.status,
                    widget: PaginationListWidget(
                      scrollController: scrollController,
                      items: state.posts,
                      child: (post) => PostWidget(
                        post: post,
                      ),
                      hasReachedMax: state.hasReachedMax,
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
