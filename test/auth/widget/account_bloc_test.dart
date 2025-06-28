import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:gift_grab/domain/services/session_service.dart';
import 'package:gift_grab/domain/services/social_auth_service.dart';
import 'package:gift_grab/presentation/blocs/account/account.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nakama/nakama.dart';

class MockSessionService extends Mock implements SessionService {}

class MockSocialAuthService extends Mock implements SocialAuthService {}

class MockNakamaClient extends Mock implements NakamaBaseClient {}

class MockSession extends Mock implements Session {}

class MockAccount extends Mock implements Account {}

void main() {
  group(
    AccountBloc,
    () {
      late AccountBloc bloc;
      late MockNakamaClient mockClient;
      late MockSession mockSession;
      late MockSessionService mockSessionService;
      late MockSocialAuthService mockSocialAuthService;
      late MockAccount mockAccount;

      setUp(() async {
        mockClient = MockNakamaClient();
        mockSession = MockSession();

        mockSessionService = MockSessionService();
        mockAccount = MockAccount();
        mockSocialAuthService = MockSocialAuthService();
      });

      tearDown(() {
        bloc.close();
      });

      blocTest<AccountBloc, AccountState>(
        'ReadAccount: emits account data with initial status when ReadAccount event is successfully processed',
        setUp: () {
          when(
            () => mockSessionService.getSession(),
          ).thenAnswer((_) async => mockSession);

          when(
            () => mockClient.getAccount(mockSession),
          ).thenAnswer((_) async => mockAccount);
        },
        build: () {
          bloc = AccountBloc(
            mockSessionService,
            mockSocialAuthService,
            mockClient,
          );
          return bloc;
        },
        act: (bloc) => bloc.add(ReadAccount()),
        expect: () => [
          AccountState(
            account: mockAccount,
            status: FormzSubmissionStatus.initial,
            isLoading: false,
            error: null,
            success: null,
          ),
        ],
      );
    },
  );
}
