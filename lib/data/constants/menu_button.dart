import 'package:gift_grab/data/constants/globals.dart';

enum MenuButton {
  play(
    'Play',
    Globals.lottiePlay,
  );

  final String name;
  final String lottieUrl;

  const MenuButton(
    this.name,
    this.lottieUrl,
  );
}
