import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomButton extends StatefulWidget {
  CustomButton({
    super.key,
    required this.text,
    required this.onTab,
    required this.color1,
    required this.color2,
  });
  String text;
  Function onTab;
  Color color1;
  Color color2;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(35),
          gradient: LinearGradient(
            colors: [widget.color1, widget.color2],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
                blurRadius: 5,
                spreadRadius: 3,
                offset: const Offset(0, 3),
                color: widget.color1.withOpacity(.3),
                blurStyle: BlurStyle.inner)
          ]),
      child: ElevatedButton(
        style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(Colors.transparent),
        ),
        onPressed: () {
          setState(() {
            widget.onTab();
          });
        },
        child: Text(
          widget.text,
          style: const TextStyle(
            fontSize: 18,
            letterSpacing: 1.5,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
