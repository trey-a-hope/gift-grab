import 'package:flutter_test/flutter_test.dart';
import 'package:gift_grab/presentation/blocs/account/account.dart';

void main() {
  group(ReadAccount, () {
    test('supports value equality', () {
      expect(ReadAccount(), equals(ReadAccount()));
    });

    test('props are correct', () {
      expect(ReadAccount().props, isEmpty);
    });
  });

  group(UpdateAccount, () {
    final mockUsername1 = 'trey.codes';
    final mockUsername2 = 'johndoe';
    test('supports value equality', () {
      expect(
        UpdateAccount(username: mockUsername1),
        equals(UpdateAccount(username: mockUsername1)),
      );
    });

    test('props are correct', () {
      expect(
        UpdateAccount(username: mockUsername1).props,
        equals([mockUsername1]),
      );
    });

    test('different alert types are not equal', () {
      expect(
        UpdateAccount(username: mockUsername1),
        isNot(UpdateAccount(username: mockUsername2)),
      );
    });
  });

  group(LinkEmailAccount, () {
    final mockEmail1 = 'abc123@gmail.com';
    final mockEmail2 = 'xyz789@gmail.com';

    final password1 = 'abc123';
    final password2 = 'xyz789';

    test('supports value equality', () {
      expect(
        LinkEmailAccount(email: mockEmail1, password: password1),
        equals(LinkEmailAccount(email: mockEmail1, password: password1)),
      );
    });

    test('props are correct', () {
      expect(
        LinkEmailAccount(email: mockEmail1, password: password1).props,
        equals([mockEmail1, password1]),
      );
    });

    test('different alert types are not equal', () {
      expect(
        LinkEmailAccount(email: mockEmail1, password: password1),
        isNot(
          LinkEmailAccount(email: mockEmail2, password: password2),
        ),
      );
    });
  });

  group(UnlinkEmailAccount, () {
    test('supports value equality', () {
      expect(UnlinkEmailAccount(), equals(UnlinkEmailAccount()));
    });

    test('props are correct', () {
      expect(UnlinkEmailAccount().props, isEmpty);
    });
  });

  group(LinkGoogleAccount, () {
    test('supports value equality', () {
      expect(LinkGoogleAccount(), equals(LinkGoogleAccount()));
    });

    test('props are correct', () {
      expect(LinkGoogleAccount().props, isEmpty);
    });
  });

  group(UnlinkGoogleAccount, () {
    test('supports value equality', () {
      expect(UnlinkGoogleAccount(), equals(UnlinkGoogleAccount()));
    });

    test('props are correct', () {
      expect(UnlinkGoogleAccount().props, isEmpty);
    });
  });

  group(LinkAppleAccount, () {
    test('supports value equality', () {
      expect(LinkAppleAccount(), equals(LinkAppleAccount()));
    });

    test('props are correct', () {
      expect(LinkAppleAccount().props, isEmpty);
    });
  });

  group(UnlinkAppleAccount, () {
    test('supports value equality', () {
      expect(UnlinkAppleAccount(), equals(UnlinkAppleAccount()));
    });

    test('props are correct', () {
      expect(UnlinkAppleAccount().props, isEmpty);
    });
  });
}
