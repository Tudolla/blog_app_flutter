import 'dart:io';

import 'package:blog/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog/core/common/widgets/loader.dart';
import 'package:blog/core/theme/app_pallete.dart';
import 'package:blog/core/utils/image_picker.dart';
import 'package:blog/core/utils/show_snackbar.dart';
import 'package:blog/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog/features/blog/presentation/pages/blog_page.dart';
import 'package:blog/features/blog/presentation/widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewBlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => AddNewBlogPage());
  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<String> selectTopic = [];
  File? image;

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  void upLoadBlog() {
    {
      if (formKey.currentState!.validate() &&
          selectTopic.isNotEmpty &&
          image != null) {
        final posterId =
            (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
        context.read<BlogBloc>().add(BlogUpload(
              posterId: posterId,
              title: titleController.text.trim(),
              content: contentController.text.trim(),
              image: image!,
              topics: selectTopic,
            ));
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titleController.dispose();
    contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(onPressed: upLoadBlog, icon: Icon(Icons.done_rounded)),
          ],
        ),
        body: BlocConsumer<BlogBloc, BlogState>(
          listener: (context, state) {
            if (state is BlogFailure) {
              showSnackBar(context, state.error);
            } else if (state is BlogSuccess) {
              Navigator.pushAndRemoveUntil(
                  context, BlogPage.route(), (route) => false);
            }
          },
          builder: (context, state) {
            if (state is BlogLoading) {
              return const Loader();
            }
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                  key: formKey,
                  child: Column(children: [
                    image != null
                        ? SizedBox(
                            height: 200,
                            width: double.infinity,
                            child: GestureDetector(
                              onTap: selectImage,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  image!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ))
                        : GestureDetector(
                            onTap: selectImage,
                            child: DottedBorder(
                              radius: const Radius.circular(20),
                              borderType: BorderType.RRect,
                              strokeCap: StrokeCap.round,
                              dashPattern: const [10, 2],
                              child: Container(
                                height: 180,
                                width: double.infinity,
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.folder_open,
                                      size: 50,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Select image from libary",
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          'Technology',
                          'Healthy',
                          'Environment',
                          'Sport',
                          'Game',
                          'Political'
                        ]
                            .map((e) => Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (selectTopic.contains(e)) {
                                        selectTopic.remove(e);
                                      } else {
                                        selectTopic.add(e);
                                      }
                                      setState(() {});
                                      print(selectTopic);
                                    },
                                    child: Chip(
                                      label: Text(e),
                                      color: selectTopic.contains(e)
                                          ? const WidgetStatePropertyAll(
                                              AppPallete.gradient2)
                                          : null,
                                      side: selectTopic.contains(e)
                                          ? null
                                          : BorderSide(
                                              color: AppPallete.borderColor),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    BlogEditor(
                        textController: titleController,
                        hintText: 'Blog title'),
                    const SizedBox(
                      height: 15,
                    ),
                    BlogEditor(
                        textController: contentController,
                        hintText: 'Blog content'),
                  ]),
                ),
              ),
            );
          },
        ));
  }
}
