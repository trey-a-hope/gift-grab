import 'package:flutter/material.dart';
import 'package:gift_grab/util/config/globals.dart';
import 'package:gift_grab/presentation/screens/game_screen.dart';
import 'package:gift_grab/presentation/screens/leaderboard_screen.dart';
import 'package:gift_grab/presentation/screens/login_screen.dart';
import 'package:gift_grab/presentation/screens/main_menu_screen.dart';
import 'package:go_router/go_router.dart';

GoRouter appRoutes(bool isAuthenticated) {
  return GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/${Globals.routeMain}',
    routes: [
      GoRoute(
        path: '/${Globals.routeLogin}',
        name: Globals.routeLogin,
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: '/${Globals.routeMain}',
        name: Globals.routeMain,
        builder: (context, state) => const MainMenuScreen(),
        routes: [
          GoRoute(
            path: Globals.routeLeaderboard,
            name: Globals.routeLeaderboard,
            builder: (context, state) => const LeaderboardScreen(),
          ),
          GoRoute(
            path: Globals.routeGame,
            name: Globals.routeGame,
            builder: (context, state) => const GameScreen(),
          ),
          // GoRoute(
          //   path: Globals.routeSearchBooks,
          //   name: Globals.routeSearchBooks,
          //   builder: (context, state) => const SearchBooksScreen(),
          //   routes: [
          //     GoRoute(
          //       path: '${Globals.routeCreateQuote}/:searchBooksResult',
          //       name: Globals.routeCreateQuote,
          //       builder: (context, state) {
          //         final searchBooksResultJson =
          //             jsonDecode(state.pathParameters['searchBooksResult']!);
          //         final searchBooksResult =
          //             SearchBooksResultModel.fromJson(searchBooksResultJson);
          //         return CreateQuoteScreen(
          //           searchBooksResult: searchBooksResult,
          //         );
          //       },
          //     ),
          //   ],
          // ),
          // GoRoute(
          //   path: '${Globals.routeEditQuote}/:book',
          //   name: Globals.routeEditQuote,
          //   builder: (context, state) {
          //     final bookJson = jsonDecode(state.pathParameters['book']!);

          //     // Note: Conversion between String and Timestamp since Timestamp can't be encodded.
          //     bookJson['created'] = Timestamp.fromDate(
          //       DateTime.parse(
          //         bookJson['created'],
          //       ),
          //     );
          //     bookJson['modified'] = Timestamp.fromDate(
          //       DateTime.parse(
          //         bookJson['modified'],
          //       ),
          //     );

          //     final book = BookModel.fromJson(bookJson);

          //     return EditQuoteScreen(book);
          //   },
          // ),
          // GoRoute(
          //   path: Globals.routeEditProfile,
          //   name: Globals.routeEditProfile,
          //   builder: (context, state) => EditProfileScreen(),
          // ),
          // GoRoute(
          //   path: Globals.routeAbout,
          //   name: Globals.routeAbout,
          //   builder: (context, state) => const AboutScreen(),
          // ),
        ],
      ),
    ],
    redirect: (context, state) =>
        isAuthenticated ? null : '/${Globals.routeLogin}',
    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: Scaffold(
        body: Center(
          child: Text(
            'Page not found',
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
      ),
    ),
  );
}
