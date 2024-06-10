import 'dart:io';

import 'package:blog/core/error/exceptions.dart';
import 'package:blog/core/error/failures.dart';
import 'package:blog/core/network/connection_check.dart';
import 'package:blog/features/blog/data/datasources/blog_local_datasource.dart';
import 'package:blog/features/blog/data/datasources/blog_remote_datasource.dart';
import 'package:blog/features/blog/data/models/blog_model.dart';
import 'package:blog/features/blog/domain/entities/blog.dart';
import 'package:blog/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource blogRemoteDataSource;
  final BlogLocalDataSource blogLocalDataSource;
  final ConnectionCheck connectionCheck;
  BlogRepositoryImpl(
    this.blogRemoteDataSource,
    this.blogLocalDataSource,
    this.connectionCheck,
  );
  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  }) async {
    try {
      if (!await (connectionCheck.isConnected)) {
        return left(Failure('No internet connected'));
      }
      BlogModel blogModel = BlogModel(
        id: const Uuid().v1(),
        posterId: posterId,
        title: title,
        content: content,
        imageUrl: '',
        topics: topics,
        updatedAt: DateTime.now(),
      );
      final imageUrl = await blogRemoteDataSource.uploadBlogImage(
          image: image, blog: blogModel);

      blogModel = blogModel.copyWith(
        imageUrl: imageUrl,
      );

      final uploadedBlog = await blogRemoteDataSource.uploadBlog(blogModel);

      return right(uploadedBlog);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> getAllBlogs() async {
    try {
      // if no internet, load all blog from local data
      if (!await (connectionCheck.isConnected)) {
        final blogs = blogLocalDataSource.loadBlog();
        return right(blogs);
      }
      final blogs = await blogRemoteDataSource.getAllBlogs();

      blogLocalDataSource.uploadLocalBlog(blogs: blogs);
      return right(blogs);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
