import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/post_controller.dart';
import '../../../data/models/post_model.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/app_error_widget.dart';
import '../../../widgets/app_empty_widget.dart';
import '../../../widgets/app_loading_widget.dart';

class PostsView extends GetView<PostController> {
  const PostsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => controller.retry(),
          ),
        ],
      ),
      body: Obx(() {
        switch (controller.state.value) {
          case PostState.loading:
            return const AppLoadingWidget(message: 'Loading posts...');
          case PostState.error:
            return AppErrorWidget(
              message: controller.errorMessage.value,
              onRetry: controller.retry,
            );
          case PostState.empty:
            return const AppEmptyWidget(message: 'No posts found.');
          case PostState.success:
          case PostState.idle:
            return _buildPostList();
        }
      }),
    );
  }

  Widget _buildPostList() {
    return RefreshIndicator(
      onRefresh: () => controller.fetchPosts(isRefresh: true),
      child: Obx(() => ListView.builder(
            controller: controller.scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: controller.posts.length + (controller.isPaginationLoading.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == controller.posts.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              return _PostCard(post: controller.posts[index]);
            },
          )),
    );
  }
}

class _PostCard extends StatelessWidget {
  final PostModel post;
  const _PostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.postDetail, arguments: post),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E30) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              post.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, height: 1.3),
            ),
            const SizedBox(height: 8),

            // Body preview
            Text(
              post.preview,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13.5,
                height: 1.5,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),

            // Tags + Stats row
            Row(
              children: [
                // Tags
                Expanded(
                  child: Wrap(
                    spacing: 6,
                    children: post.tags
                        .take(3)
                        .map((tag) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '#$tag',
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(width: 8),

                // Reactions
                Row(
                  children: [
                    const Icon(Icons.thumb_up_outlined, size: 13, color: Colors.grey),
                    const SizedBox(width: 3),
                    Text(
                      '${post.reactions.likes}',
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.visibility_outlined, size: 13, color: Colors.grey),
                    const SizedBox(width: 3),
                    Text(
                      '${post.views}',
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
