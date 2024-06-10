import 'package:blog/core/theme/app_pallete.dart';
import 'package:blog/core/utils/calculate_time.dart';
import 'package:blog/features/blog/domain/entities/blog.dart';
import 'package:blog/features/blog/presentation/pages/blog_detail.dart';
import 'package:flutter/material.dart';

class BlogCard extends StatelessWidget {
  final Blog blog;
  final Color color;
  const BlogCard({super.key, required this.blog, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, BlogDetail.route(blog));
      },
      child: Container(
        height: 200,
        margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: blog.topics
                        .map((e) => Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Chip(
                                label: Text(e),
                              ),
                            ))
                        .toList(),
                  ),
                ),
                Text(
                  blog.title,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Text('${calculateTime(blog.content)} min'),
          ],
        ),
      ),
    );
  }
}
