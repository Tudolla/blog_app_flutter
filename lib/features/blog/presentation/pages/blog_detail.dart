import 'package:blog/core/theme/app_pallete.dart';
import 'package:blog/core/utils/calculate_time.dart';
import 'package:blog/core/utils/format_date.dart';
import 'package:blog/features/blog/domain/entities/blog.dart';
import 'package:flutter/material.dart';

class BlogDetail extends StatelessWidget {
  final Blog blog;
  static route(Blog blog) => MaterialPageRoute(
      builder: (context) => BlogDetail(
            blog: blog,
          ));
  BlogDetail({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  blog.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Posted by:  ${blog.posterName}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  '${formatDateBydMMMYYYY(blog.updatedAt)} . ${calculateTime(blog.content)} min',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 97, 95, 95),
                    fontSize: 15,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(blog.imageUrl),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Content :',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  blog.content,
                  style: TextStyle(
                    height: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
