class PostModel {
  final int id;
  final String title;
  final String body;
  final int userId;
  final List<String> tags;
  final PostReactions reactions;
  final int views;

  PostModel({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
    required this.tags,
    required this.reactions,
    required this.views,
  });

  String get preview {
    if (body.length <= 120) return body;
    return '${body.substring(0, 120)}...';
  }

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      userId: json['userId'] ?? 0,
      tags: List<String>.from(json['tags'] ?? []),
      reactions: PostReactions.fromJson(json['reactions'] ?? {}),
      views: json['views'] ?? 0,
    );
  }
}

class PostReactions {
  final int likes;
  final int dislikes;

  PostReactions({required this.likes, required this.dislikes});

  factory PostReactions.fromJson(Map<String, dynamic> json) {
    return PostReactions(
      likes: json['likes'] ?? 0,
      dislikes: json['dislikes'] ?? 0,
    );
  }
}
