import 'package:blog/features/blog/data/models/blog_model.dart';
import 'package:hive/hive.dart';

abstract interface class BlogLocalDataSource {
  void uploadLocalBlog({required List<BlogModel> blogs});
  List<BlogModel> loadBlog();
}

class BlogLocalDatasourceImpl implements BlogLocalDataSource {
  final Box box;
  BlogLocalDatasourceImpl(this.box);
  @override
  List<BlogModel> loadBlog() {
    List<BlogModel> blogs = [];
    box.read(() {
      for (int i = 0; i < box.length; i++) {
        blogs.add(BlogModel.fromJson(box.get(i.toString())));
      }
    });
    return blogs;
  }

  @override
  void uploadLocalBlog({required List<BlogModel> blogs}) {
    box.clear();
    box.write(() {
      for (int i = 0; i < blogs.length; i++) {
        box.put(i.toString(), blogs[i].toJson());
      }
    });
  }
}
