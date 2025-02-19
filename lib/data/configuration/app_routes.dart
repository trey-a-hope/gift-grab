import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/presentation/screens/game_screen.dart';
import 'package:go_router/go_router.dart';

class StreamToListenable extends ChangeNotifier {
  late final List<StreamSubscription> subscriptions;

  StreamToListenable(List<Stream> streams) {
    subscriptions = [];
    for (var e in streams) {
      var s = e.asBroadcastStream().listen(_tt);
      subscriptions.add(s);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    for (var e in subscriptions) {
      e.cancel();
    }
    super.dispose();
  }

  void _tt(event) => notifyListeners();
}

GoRouter appRouter() => GoRouter(
      initialLocation: '/${Globals.routes.main}',
      routes: [
        GoRoute(
          path: '/${Globals.routes.main}',
          name: Globals.routes.main,
          builder: (context, state) => const GameScreen(),
        ),
      ],
      redirect: (context, state) => '/main',
    );
