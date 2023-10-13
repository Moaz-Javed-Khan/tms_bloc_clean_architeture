import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Widget title;
  // final String name;
  final VoidCallback onClick;
  final Color color;

  const CustomButton({
    Key? key,
    required this.title,
    // required this.name,
    required this.onClick,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        onClick();
      },
      child: Ink(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Card(
            elevation: 2,
            color: color,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 12.0,
                  ),
                  child: title
                  // Text(
                  //   name,
                  //   textAlign: TextAlign.center,
                  //   style: const TextStyle(
                  //     fontSize: 16,
                  //     color: Colors.white,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
