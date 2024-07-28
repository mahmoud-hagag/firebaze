// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  CustomTextField({
    this.keyType = TextInputType.text,
    required this.controller,
    required this.label,
    this.obscureText = false,
    required this.icon,
    super.key,
    required this.validator,
  });
  final String label;
  final TextInputType keyType;
  final TextEditingController controller;
  bool obscureText = false;
  IconData icon;
  final String? Function(String?)? validator;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65,
      child: TextFormField(
        autocorrect: true,
        enableSuggestions: true,
        validator: widget.validator,
        controller: widget.controller,
        obscureText: widget.obscureText,
        keyboardType: widget.keyType,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.blue),
          ),
          filled: true,
          fillColor: Colors.grey[100],
          labelText: widget.label,
          labelStyle: const TextStyle(
            color: Colors.grey,
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(
              right: 10,
            ),
            child: IconButton(
              icon: Icon(widget.icon),
              onPressed: () {
              setState(() {
                if (widget.icon == CupertinoIcons.eye_slash_fill) {
                  widget.obscureText = !widget.obscureText;
                  widget.icon = CupertinoIcons.eye_fill;
                } else if (widget.icon == CupertinoIcons.eye_fill) {
                  widget.obscureText = !widget.obscureText;
                  widget.icon = CupertinoIcons.eye_slash_fill;
                }
              });
            },
            ),
          ),
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }
}
