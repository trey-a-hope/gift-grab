import 'package:flutter/material.dart';
import 'package:gift_grab/constants/globals.dart';
import 'package:gift_grab/games/gift_grab_game.dart';
import 'package:gift_grab/screens/game_play.dart';
import 'package:gift_grab/screens/menus/menu_background_widget.dart';
import 'package:gift_grab/services/hive_service.dart';
import 'package:toggle_switch/toggle_switch.dart';

class SettingsMenu extends StatelessWidget {
  final GiftGrabGame gameRef;
  const SettingsMenu({Key? key, required this.gameRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MenuBackgroundWidget(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Text(
                'Settings',
                style: TextStyle(
                  fontSize: Globals.isTablet ? 100 : 50,
                ),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Difficulty',
                    style: TextStyle(
                      fontSize: Globals.isTablet ? 50 : 25,
                    ),
                  ),
                  FutureBuilder(
                    future: HiveService.get(
                      boxName: 'settings',
                      key: 'difficulty',
                    ),
                    builder: (context, snapshot) => snapshot.connectionState ==
                            ConnectionState.waiting
                        ? const CircularProgressIndicator()
                        : ToggleSwitch(
                            minWidth: 90.0,
                            minHeight: 70.0,
                            initialLabelIndex: snapshot.data as int,
                            cornerRadius: 20.0,
                            activeFgColor: Colors.white,
                            inactiveBgColor: Colors.grey,
                            inactiveFgColor: Colors.white,
                            totalSwitches: 3,
                            icons: const [
                              Icons.face,
                              Icons.face,
                              Icons.face,
                            ],
                            iconSize: 30.0,
                            activeBgColors: [
                              [Colors.green.shade300, Colors.green.shade500],
                              [Colors.orange.shade300, Colors.orange.shade500],
                              [Colors.red.shade300, Colors.red.shade500],
                            ],
                            animate:
                                true, // with just animate set to true, default curve = Curves.easeIn
                            curve: Curves
                                .bounceInOut, // animate must be set to true when using custom curve
                            onToggle: (index) {
                              HiveService.put(
                                boxName: 'settings',
                                key: 'difficulty',
                                value: index,
                              );
                            },
                          ),
                  )
                ],
              ),
            ),
            const Divider(),
            SizedBox(
              width: Globals.isTablet ? 400 : 200,
              height: Globals.isTablet ? 100 : 50,
              child: ElevatedButton(
                onPressed: () {
                  gameRef.removeMenu(menu: Menu.settings);
                },
                child: Text(
                  'Cancel',
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
