import 'package:blog/core/common/widgets/loader.dart';
import 'package:blog/core/theme/app_pallete.dart';
import 'package:blog/core/theme/theme.dart';
import 'package:blog/core/utils/show_snackbar.dart';
import 'package:blog/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog/features/auth/presentation/pages/signup_page.dart';
import 'package:blog/features/auth/presentation/widgets/auth_button.dart';
import 'package:blog/features/auth/presentation/widgets/auth_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => LoginPage());
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    emailController.dispose();
    passController.dispose();
  }

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color.fromARGB(255, 175, 175, 192),
      backgroundColor: AppPallete.backgroundColor,
      body: Padding(
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
                  Text(
                    'Login to LOL!',
                    style: TextStyle(
                      color: AppPallete.greyColor,
                      fontSize: 46,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  AuthField(
                    hintText: "Email",
                    controller: emailController,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  AuthField(
                      hintText: "Pass",
                      controller: passController,
                      isPassword: true),
                  SizedBox(
                    height: 18,
                  ),
                  AuthButton(
                    text: "Login",
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(AuthLogin(
                            email: emailController.text.trim(),
                            password: passController.text.trim()));
                      }
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(SignUpPage.route());
                    },
                    child: RichText(
                      text: TextSpan(
                          text: "Dont't have an account! ",
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.normal,
                                  ),
                          children: [
                            TextSpan(
                              text: "SignUp",
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
    );
  }
}
