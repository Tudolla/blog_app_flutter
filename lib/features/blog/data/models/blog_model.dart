import 'package:blog/features/blog/domain/entities/blog.dart';

class BlogModel extends Blog {
  BlogModel(
    super.id,
    super.posterId,
    super.title,
    super.content,
    super.imageUrl,
    super.topics,
    super.updatedAt,
  );

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'poster_id': posterId,
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'topics': topics,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory BlogModel.fromJson(Map<String, dynamic> map) {
    return BlogModel(
      map['id'] as String,
      map['poster_id'] as String,
      map['title'] as String,
      map['content'] as String,
      map['image_url'] as String,
      List<String>.from(map['topics'] ?? []),
      map['updated_at'] == null
          ? DateTime.now()
          : DateTime.parse(map['updated_at']),
    );
  }
}
