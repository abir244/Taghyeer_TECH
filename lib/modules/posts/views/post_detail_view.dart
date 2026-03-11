import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/post_model.dart';

class PostDetailView extends StatelessWidget {
  const PostDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final PostModel post = Get.arguments as PostModel;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Detail'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: Get.back,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tags
            if (post.tags.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: post.tags
                    .map((tag) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '#$tag',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            const SizedBox(height: 16),

            // Title
            Text(
              post.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, height: 1.3),
            ),
            const SizedBox(height: 16),

            // Stats row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E30) : const Color(0xFFF8F9FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatItem(
                    icon: Icons.thumb_up_rounded,
                    label: 'Likes',
                    value: '${post.reactions.likes}',
                    color: const Color(0xFF4CAF50),
                  ),
                  _divider(),
                  _StatItem(
                    icon: Icons.thumb_down_rounded,
                    label: 'Dislikes',
                    value: '${post.reactions.dislikes}',
                    color: const Color(0xFFE53935),
                  ),
                  _divider(),
                  _StatItem(
                    icon: Icons.visibility_rounded,
                    label: 'Views',
                    value: '${post.views}',
                    color: const Color(0xFF1A73E8),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Divider
            const Divider(height: 1),
            const SizedBox(height: 20),

            // Body
            Text(
              post.body,
              style: TextStyle(
                fontSize: 15.5,
                height: 1.8,
                color: isDark ? Colors.grey[300] : Colors.grey[800],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _divider() => Container(width: 1, height: 30, color: Colors.grey.withOpacity(0.3));
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}
