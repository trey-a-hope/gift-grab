import 'package:flutter_test/flutter_test.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/presentation/blocs/profile/profile.dart';

void main() {
  group(
    ReadProfile,
    () {
      test(
        Globals.testDescriptions.event.valueEqual,
        () {
          expect(ReadProfile(), equals(ReadProfile()));
        },
      );

      test(
        Globals.testDescriptions.event.propsEqual,
        () {
          expect(ReadProfile().props, isEmpty);
        },
      );
    },
  );

  group(
    UsernameChange,
    () {
      final username1 = 'trey.codes';
      final username2 = 'johndoe';
      test(
        Globals.testDescriptions.event.valueEqual,
        () {
          expect(UsernameChange(username1), equals(UsernameChange(username1)));
        },
      );

      test(
        Globals.testDescriptions.event.propsEqual,
        () {
          expect(UsernameChange(username1).props, [username1]);
        },
      );

      test(
        'different alert types are not equal',
        () {
          expect(
            UsernameChange(username1),
            isNot(UsernameChange(username2)),
          );
        },
      );
    },
  );

  group(
    UpdateProfile,
    () {
      test(
        Globals.testDescriptions.event.valueEqual,
        () {
          expect(UpdateProfile(), equals(UpdateProfile()));
        },
      );

      test(
        Globals.testDescriptions.event.propsEqual,
        () {
          expect(UpdateProfile().props, isEmpty);
        },
      );
    },
  );
}
