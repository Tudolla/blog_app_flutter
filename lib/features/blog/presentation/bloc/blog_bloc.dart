import 'dart:io';

import 'package:blog/core/usecase/usecase.dart';
import 'package:blog/features/blog/domain/entities/blog.dart';
import 'package:blog/features/blog/domain/usecases/get__all_blogs.dart';
import 'package:blog/features/blog/domain/usecases/upload_blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;
  BlogBloc({
    required UploadBlog uploadBlog,
    required GetAllBlogs getAllBlog,
  })  : _uploadBlog = uploadBlog,
        _getAllBlogs = getAllBlog,
        super(BlogInitial()) {
    on<BlogEvent>((event, emit) => emit(BlogLoading()));
    on<BlogUpload>(_onBlogUpload);
    on<BlogsFetchAll>(_onFetchAllBlogs);
  }

  void _onBlogUpload(BlogUpload event, Emitter<BlogState> emit) async {
    final res = await _uploadBlog(UploadBlogParams(
      posterId: event.posterId,
      title: event.title,
      content: event.content,
      image: event.image,
      topics: event.topics,
    ));

    res.fold(
        (l) => emit(BlogFailure(l.message)), (r) => emit(BlogUploadSuccess()));
  }

  void _onFetchAllBlogs(BlogsFetchAll event, Emitter<BlogState> emit) async {
    final res = await _getAllBlogs(NoParams());
    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogsDisplaySuccess(r)),
    );
  }
}
