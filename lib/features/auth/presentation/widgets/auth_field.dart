import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller ; 
  final bool isPassword;
  const AuthField({super.key, required this.hintText,
  required this.controller,
  this.isPassword = false,});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller ,
      validator: (value) {
        if(value == null){
          return "$hintText is missing!";

        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hintText,
      ),
      obscureText: isPassword,
      
    );
  }
}