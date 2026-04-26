import 'package:bike_rental_2/components/bottom_button.dart';
import 'package:bike_rental_2/components/dialog_service.dart';
import 'package:bike_rental_2/components/editor.dart';
import 'package:bike_rental_2/components/ui_service.dart';
import 'package:bike_rental_2/constants.dart';
import 'package:bike_rental_2/repository/repository.dart';
import 'package:bike_rental_2/screens/help_page.dart';
import 'package:bike_rental_2/screens/profile_page.dart';
import 'package:flutter/material.dart';

const double _imageSize = bottomButtonHeight;

class AuthorisationPage extends StatefulWidget {
  const AuthorisationPage({super.key});

  @override
  State<AuthorisationPage> createState() => _AuthorisationPageState();
}

class _AuthorisationPageState extends State<AuthorisationPage> {
  late final TextEditingController _loginController;
  late final TextEditingController _passwordController;
  @override
  void initState() {
    super.initState();
    _loginController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Кнопки навигации:
  Widget navigation() {
    return Row(
      children: [
        Expanded(
          child: BottomButton(
            text: 'Вход\n',
            onClicked: onEnterClicked,
            color: primaryColor,
            icon: Icons.login,
          ),
        ),

        const SizedBox(width: 2),

        Expanded(
          child: BottomButton(
            text: 'Новый\nклиент',
            onClicked: onRegistrationClicked,
            color: primaryColor,
            icon: Icons.person_add_alt_1,
            enabled: false,
          ),
        ),

        const SizedBox(width: 2),

        Expanded(
          child: BottomButton(
            text: 'Помощь\n',
            onClicked: onHelpClicked,
            color: secondaryColor,
            icon: Icons.info_outline,
          ),
        ),
      ],
    );
  }

  // Нажали Вход:
  void onEnterClicked() {
    if (repository.authorisation(
      _loginController.text,
      _passwordController.text,
    )) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      );
    } else {
      dialogService.showMessage(
        context,
        'Неверный логин/пароль!',
        DialogType.error,
        () {},
      );
    }
  }

  // Нажали Регистрация:
  void onRegistrationClicked() {
    dialogService.showMessage(
      context,
      'Не поддерживается',
      DialogType.warning,
      () {},
    );
  }

  // Нажали помощь:
  void onHelpClicked() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HelpPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return constrainedScaffold(
      context,
      'Авторизация',
      surfaceColor,
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                // Картинка сверху для красоты:
                Center(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(24)),
                    child: Image.asset(
                      defaultImage,
                      width: _imageSize,
                      height: _imageSize,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                SizedBox(height: 16),

                Editor(
                  controller: _loginController,
                  label: 'Логин',
                  hint: 'Ваш логин',
                  icon: Icons.person,
                  autofocus: true,
                ),

                SizedBox(height: 16),

                Editor(
                  controller: _passwordController,
                  label: 'Пароль',
                  hint: 'Ваш пароль',
                  icon: Icons.vpn_key,
                ),
              ],
            ),
          ),
          Spacer(),
          Padding(padding: const EdgeInsets.all(4), child: navigation()),
        ],
      ),
    );
  }
}
