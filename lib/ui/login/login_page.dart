import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app/base/main_view_model.dart';
import 'package:story_app/ui/component/button_state.dart';
import 'package:story_app/ui/component/form_input_fields.dart';
import 'package:story_app/ui/component/safe_on_tap.dart';
import 'package:story_app/ui/login/login_view_model.dart';
import 'package:story_app/utils/common.dart';
import 'package:story_app/utils/constants.dart';
import 'package:story_app/utils/extensions.dart';
import 'package:story_app/utils/function.dart';
import 'package:story_app/utils/hexa_color.dart';
import 'package:story_app/utils/result_state.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final baseProvider = context.watch<MainViewModel>();
    final provider = context.watch<LoginViewModel>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SafeOnTap(
                      onSafeTap: () => baseProvider.setLanguage = Constants.en,
                      child: Text(
                        "EN",
                        style: TextStyle(
                          fontWeight: getFontWeight(baseProvider, Constants.en),
                          color: getColors(baseProvider, Constants.en),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    const Text("|"),
                    const SizedBox(
                      width: 4,
                    ),
                    SafeOnTap(
                      onSafeTap: () => baseProvider.setLanguage = Constants.id,
                      child: Text(
                        "ID",
                        style: TextStyle(
                          fontWeight: getFontWeight(baseProvider, Constants.id),
                          color: getColors(baseProvider, Constants.id),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Hero(
                      tag: Constants.storyLogo,
                      child: Image.asset(
                        "story_logo.png".getImageAssets(),
                        width: 35,
                        height: 35,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: Hero(
                        tag: Constants.appName,
                        child: Text(
                          AppLocalizations.of(context)?.story_app ?? "",
                          style: const TextStyle(
                            fontSize: 24,
                            fontFamily: Constants.manjariBold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  AppLocalizations.of(context)?.sub_title_login_page ?? "",
                  style: const TextStyle(
                    fontFamily: Constants.manjariBold,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 80,
                ),
                FormInputFields(
                  titleFormInputFields: AppLocalizations.of(context)?.email,
                  hintFormInputFields: "storyapp@gmail.com",
                  inputType: Constants.email,
                  errorMessage:
                      AppLocalizations.of(context)?.message_error_email,
                  onTextChange: (value) {
                    provider.setInputEmail = value;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                FormInputFields(
                  titleFormInputFields: AppLocalizations.of(context)?.password,
                  hintFormInputFields:
                      AppLocalizations.of(context)?.hint_passowrd,
                  inputType: Constants.password,
                  errorMessage:
                      AppLocalizations.of(context)?.message_error_password,
                  onTextChange: (value) {
                    provider.setInputPassword = value;
                  },
                ),
                const SizedBox(
                  height: 50,
                ),
                Consumer<LoginViewModel>(
                  builder: (context, value, child) {
                    if (value.isButtonClicked) {
                      return ButtonState(
                        isLoading: true,
                        onButtonPressed: () {},
                      );
                    } else {
                      return ButtonState(
                        textButton: AppLocalizations.of(context)?.text_login,
                        onButtonPressed: (provider.inputEmail.isNotEmpty &&
                                provider.inputEmail.validateEmail() &&
                                provider.inputPassword.isNotEmpty &&
                                provider.inputPassword.validatePassword())
                            ? () {
                                provider.setIsButtonClicked = true;
                                provider.postLogin(provider.inputEmail,
                                    provider.inputPassword);
                              }
                            : null,
                      );
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)?.question_login ?? "",
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    SafeOnTap(
                      onSafeTap: () {
                        context.push(Constants.registerPage);
                      },
                      child: Text(
                        AppLocalizations.of(context)?.text_sign_up ?? "",
                        style: TextStyle(
                          color: HexColor(Constants.colorDarkBlue),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                _stateLogin(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _stateLogin() {
    return Consumer<LoginViewModel>(
      builder: (context, value, child) {
        switch (value.resultState) {
          case ResultState.hasData:
            if (value.isButtonClicked) {
              Future.delayed(Duration.zero, () {
                context.go(Constants.homePage);
              });
              resetButtonClicked(value);
            }
            return const SizedBox.shrink();
          case ResultState.hasError:
            if (value.isButtonClicked) {
              value.failedMessage.showSnackbar(context);
              resetButtonClicked(value);
            }
            return const SizedBox.shrink();
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }

  void resetButtonClicked(LoginViewModel value) {
    Future.delayed(Duration.zero, () {
      value.setIsButtonClicked = false;
    });
  }
}
