import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final Function onClick;
  final Color color;
  const CustomButton({
    required this.color,
    required this.onClick,
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        onClick();
      },
      child: Container(
        width: size.width * .3,
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(
              10.0,
            )),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
