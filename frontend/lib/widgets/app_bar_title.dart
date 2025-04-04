import 'package:flutter/material.dart';
import 'package:frontend/constants/constants.dart' as constants;

class AppBarTitle extends StatelessWidget {
  const AppBarTitle({
    super.key,
    required this.text,
    required this.primaryTextStartPosition,
    required this.primaryTextEndPosition,
  });

  final String text;
  final int primaryTextStartPosition;
  final int primaryTextEndPosition;

  @override
  Widget build(BuildContext context) {
    String spaceBeforePrimaryText = " ";

    if (primaryTextStartPosition < 0 ||
        primaryTextEndPosition > text.split(" ").length ||
        primaryTextStartPosition > primaryTextEndPosition) {
      return Text(text);
    }

    if (primaryTextStartPosition == 0) {
      spaceBeforePrimaryText = "";
    }

    return Text.rich(
      TextSpan(
        text:
            "${text.split(" ").sublist(0, primaryTextStartPosition).join(" ")}$spaceBeforePrimaryText",
        style: const TextStyle(color: Color(constants.Colors.black)),
        children: <TextSpan>[
          TextSpan(
            text: text
                .split(" ")
                .sublist(primaryTextStartPosition, primaryTextEndPosition)
                .join(" "),
            style: const TextStyle(color: Color(constants.Colors.orange)),
            children: <TextSpan>[
              TextSpan(
                text:
                    " ${text.split(" ").sublist(primaryTextEndPosition).join(" ")}",
                style: const TextStyle(color: Color(constants.Colors.black)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
