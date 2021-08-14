import 'package:flutter/material.dart';

class VimeoQueryButton extends StatelessWidget {
  final VoidCallback ontap;
  VimeoQueryButton({required this.ontap});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Material(
        color: Colors.white,
        child: InkWell(
          highlightColor: Colors.grey[850]?.withOpacity(0.3),
          onTap: ontap,
          child: Container(
            width: 40.0,
            height: 40.0,
            // color: Colors.white.withOpacity(0.3),
            child: Icon(
              Icons.remove_red_eye,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
