import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/post_model.dart';
import '../../../data/repositories/post_repository.dart';
import '../../../core/constants/app_constants.dart';

enum PostState { idle, loading, success, error, empty }

class PostController extends GetxController {
  final PostRepository _repository = PostRepository();

  final posts = <PostModel>[].obs;
  final state = PostState.idle.obs;
  final isPaginationLoading = false.obs;
  final errorMessage = ''.obs;
  final scrollController = ScrollController();

  int _skip = 0;
  int _total = 0;
  bool _isFetching = false;

  bool get hasMore => posts.length < _total;

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;
    if (currentScroll >= maxScroll - 200 && hasMore && !_isFetching) {
      loadMore();
    }
  }

  Future<void> fetchPosts({bool isRefresh = false}) async {
    if (_isFetching) return;
    _isFetching = true;

    if (isRefresh) {
      _skip = 0;
      posts.clear();
    }

    state.value = PostState.loading;
    errorMessage.value = '';

    try {
      final result = await _repository.getPosts(skip: 0);
      final list = result['posts'] as List<PostModel>;
      _total = result['total'] as int;
      _skip = AppConstants.pageLimit;

      posts.assignAll(list);
      state.value = list.isEmpty ? PostState.empty : PostState.success;
    } catch (e) {
      errorMessage.value = e.toString();
      state.value = PostState.error;
    } finally {
      _isFetching = false;
    }
  }

  Future<void> loadMore() async {
    if (_isFetching || !hasMore) return;
    _isFetching = true;
    isPaginationLoading.value = true;

    try {
      final result = await _repository.getPosts(skip: _skip);
      final list = result['posts'] as List<PostModel>;
      _skip += AppConstants.pageLimit;
      posts.addAll(list);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load more posts. Tap to retry.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        mainButton: TextButton(
          onPressed: loadMore,
          child: const Text('Retry', style: TextStyle(color: Colors.white)),
        ),
      );
    } finally {
      _isFetching = false;
      isPaginationLoading.value = false;
    }
  }

  Future<void> retry() => fetchPosts(isRefresh: true);

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
