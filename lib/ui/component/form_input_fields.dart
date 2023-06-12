import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/ui/component/form_input_fields_view_model.dart';
import 'package:story_app/utils/constants.dart';
import 'package:story_app/utils/hexa_color.dart';
import 'package:story_app/utils/extensions.dart';

class FormInputFields extends StatelessWidget {
  final String? titleFormInputFields;
  final String? hintFormInputFields;
  final String? inputType;
  final String? errorMessage;
  final Function(String)? onTextChange;

  const FormInputFields({
    Key? key,
    this.titleFormInputFields,
    this.hintFormInputFields,
    this.inputType,
    this.errorMessage,
    this.onTextChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleFormInputFields ?? "Your email address",
          style: const TextStyle(
            fontFamily: Constants.manjariBold,
            color: Colors.black,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          obscureText: inputType == Constants.password
              ? !context.watch<FormInputFieldsViewModel>().isVisiblePassword
              : false,
          onChanged: (value) {
            validateFormInputFields(context, value);
            onTextChange?.call(value);
          },
          maxLines: 1,
          autocorrect: false,
          enableSuggestions: false,
          style: const TextStyle(
            color: Colors.black,
            decorationThickness: 0,
          ),
          decoration: InputDecoration(
            isDense: true,
            isCollapsed: true,
            contentPadding: const EdgeInsets.all(20),
            suffixIcon: _visibilityIcon(context),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: HexColor(Constants.colorLightGrey),
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: HexColor(Constants.colorDarkBlue),
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.red,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.red,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            errorText: _errorMessage(context),
            hintText: hintFormInputFields ?? "storyapp@gmail.com",
            hintStyle: TextStyle(
              color: HexColor(Constants.colorLightGrey),
            ),
          ),
        )
      ],
    );
  }

  void validateFormInputFields(BuildContext context, String value) {
    final provider = context.read<FormInputFieldsViewModel>();
    switch (inputType) {
      case Constants.email:
        if (value.isNotEmpty) {
          provider.setValidateEmail = value.validateEmail();
        } else {
          provider.setValidateEmail = true;
        }
        break;
      case Constants.password:
        if (value.isNotEmpty) {
          provider.setValidatePassword = value.validatePassword();
        } else {
          provider.setValidatePassword = true;
        }
        break;
    }
  }

  String? _errorMessage(BuildContext context) {
    final provider = context.watch<FormInputFieldsViewModel>();
    switch (inputType) {
      case Constants.email:
        return provider.isValidateEmail == false ? errorMessage : null;
      case Constants.password:
        return provider.isValidatePassword == false ? errorMessage : null;
      default:
        return null;
    }
  }

  Widget? _visibilityIcon(BuildContext context) {
    final provider = context.watch<FormInputFieldsViewModel>();
    return inputType == Constants.password
        ? IconButton(
            icon: Icon(
              provider.isVisiblePassword
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: (provider.isValidatePassword)
                  ? HexColor(Constants.colorDarkBlue)
                  : Colors.red,
            ),
            onPressed: () {
              provider.setVisiblePassword = !provider.isVisiblePassword;
            },
          )
        : null;
  }
}
