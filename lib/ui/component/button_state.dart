import 'package:flutter/material.dart';
import 'package:story_app/utils/constants.dart';
import 'package:story_app/utils/hexa_color.dart';

class ButtonState extends StatelessWidget {
  final String? textButton;
  final bool? isLoading;
  final double? widthButton;
  final Function()? onButtonPressed;

  const ButtonState({
    Key? key,
    this.textButton,
    this.onButtonPressed,
    this.isLoading = false,
    this.widthButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (widthButton != null) ? widthButton : double.infinity,
      height: 45,
      child: ElevatedButton(
        onPressed: onButtonPressed,
        style: ElevatedButton.styleFrom(
          splashFactory: (isLoading == true) ? NoSplash.splashFactory : null,
          backgroundColor: HexColor(Constants.colorDarkBlue),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Align(
          alignment: Alignment.center,
          child: (isLoading == true)
              ? const Center(
                  child: SizedBox(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                )
              : Text(
                  textButton ?? "Button",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
