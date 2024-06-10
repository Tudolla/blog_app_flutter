import 'package:blog/core/common/widgets/loader.dart';
import 'package:blog/core/error/failures.dart';
import 'package:blog/core/theme/app_pallete.dart';
import 'package:blog/core/utils/show_snackbar.dart';
import 'package:blog/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog/features/auth/presentation/pages/login_page.dart';
import 'package:blog/features/auth/presentation/widgets/auth_button.dart';
import 'package:blog/features/auth/presentation/widgets/auth_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => SignUpPage());
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passController.dispose();
  }

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      // backgroundColor: const Color.fromARGB(255, 175, 175, 192),
      backgroundColor: AppPallete.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthFailure) {
                showSnackBar(context, state.message);
              }
            },
            builder: (context, state) {
              if (state is AuthLoading) {
                return const Loader();
              }
              return Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Be a new user!',
                      style: TextStyle(
                        color: AppPallete.greyColor,
                        fontSize: 46,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    AuthField(
                      hintText: "Name",
                      controller: nameController,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AuthField(
                      hintText: "Email",
                      controller: emailController,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AuthField(
                        hintText: "Pass",
                        controller: passController,
                        isPassword: true),
                    const SizedBox(
                      height: 18,
                    ),
                    AuthButton(
                      text: "Sign Up",
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          context.read<AuthBloc>().add(AuthSignUp(
                              name: nameController.text.trim(),
                              email: emailController.text.trim(),
                              password: passController.text.trim()));
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, LoginPage.route());
                      },
                      child: RichText(
                        text: TextSpan(
                            text: "Already have an account! ",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.normal,
                                ),
                            children: [
                              TextSpan(
                                text: "Login",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: AppPallete.errorColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                              )
                            ]),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
