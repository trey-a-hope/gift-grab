import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/data/constants/screens.dart';
import 'package:gift_grab/domain/providers/nakama_provider.dart';
import 'package:gift_grab/domain/providers/providers.dart';
import 'package:gift_grab/presentation/games/gift_grab_game.dart';
import 'package:gift_grab/presentation/widgets/screen_background_widget.dart';
import 'package:gift_grab/util/text_formatters/upper_case_text_formatter.dart';

class LoginScreen extends ConsumerWidget {
  final GiftGrabGame gameRef;

  final TextEditingController _controller = TextEditingController();

  LoginScreen({
    Key? key,
    required this.gameRef,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    NakamaProvider nakamaProvider = ref.watch(Providers.nakamaProvider);
    return ScreenBackgroundWidget(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Text(
                'Login',
                style: TextStyle(
                  fontSize: Globals.isTablet ? 100 : 50,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                controller: _controller,
                textAlign: TextAlign.center,
                maxLength: 4,
                inputFormatters: [
                  UpperCaseTextFormatter(),
                ],
                style: const TextStyle(fontSize: 128),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.1),
                ),
              ),
            ),
            SizedBox(
              width: Globals.isTablet ? 400 : 200,
              height: Globals.isTablet ? 100 : 50,
              child: ElevatedButton(
                onPressed: () async {
                  String username = _controller.text;

                  await nakamaProvider.createEmail(
                    email: '$username@gmail.com',
                    password: 'password',
                    username: username,
                  );

                  gameRef.addMenu(menu: Screens.main);
                  gameRef.removeMenu(menu: Screens.login);
                },
                child: Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: Globals.isTablet ? 50 : 25,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}