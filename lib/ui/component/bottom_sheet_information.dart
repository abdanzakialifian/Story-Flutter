import 'package:flutter/material.dart';
import 'package:story_app/ui/component/button_state.dart';
import 'package:story_app/utils/constants.dart';
import 'package:story_app/utils/extensions.dart';

class BottomSheetInformation extends StatelessWidget {
  final String iconName;
  final double iconHeight;
  final double iconWidth;
  final String title;
  final String subTitle;
  final String textButton;
  final Function() onButtonPressed;

  const BottomSheetInformation({
    Key? key,
    required this.iconName,
    this.iconHeight = 50,
    this.iconWidth = 50,
    required this.title,
    required this.subTitle,
    required this.textButton,
    required this.onButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 20,
            ),
            Image.asset(
              iconName.getImageAssets(),
              height: iconHeight,
              width: iconWidth,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              title,
              style: const TextStyle(
                fontFamily: Constants.manjariBold,
                fontSize: 30,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              subTitle,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 80,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ButtonState(
                textButton: textButton,
                onButtonPressed: onButtonPressed,
              ),
            )
          ],
        ),
      ),
    );
  }
}
