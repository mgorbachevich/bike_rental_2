import 'package:bike_rental_2/components/page_scaffold.dart';
import 'package:bike_rental_2/components/ui_service.dart';
import 'package:bike_rental_2/constants.dart';
import 'package:bike_rental_2/repository/repository.dart';
import 'package:bike_rental_2/screens/authorisation_page.dart';
import 'package:flutter/material.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  bool _enableClick = false;
  bool _showImage = false;

  @override
  void initState() {
    super.initState();
    initAll();
  }

  // Создание и. инициализация БД:
  Future<void> initAll() async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Искусственная пауза для красоты
    setState(() {
      _showImage = true;
    });
    await Future.delayed(
      const Duration(milliseconds: 1000),
    ); // Искусственная пауза для красоты
    await repository.create();
    setState(() {
      _enableClick = true;
    });
  }

  // Нажатие на экран:
  void onClicked() {
    if (_enableClick) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthorisationPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onClicked,
      child: PageScaffold(
        context: context,
        title: '',
        backColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              // Заголовок с анимацией:
              uiService.opacityAnimation(
                _showImage,
                Text(
                  'ВелоАренда',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: onSurfaceColor,
                  ),
                ),
              ),

              Spacer(),

              // Картинка с анимацией:
              uiService.opacityAnimation(
                _showImage,
                Image.asset('assets/images/0.png', fit: BoxFit.contain),
              ),

              Spacer(),

              // Надпись с анимацией:
              uiService.opacityAnimation(
                _enableClick,
                Text(
                  'Нажмите на экран чтобы продолжить',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: onSurfaceColor,
                  ),
                ),
              ),

              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
