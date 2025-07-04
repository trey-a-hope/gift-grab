import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:gift_grab/data/constants/globals.dart';
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
      final mockClient = MockNakamaClient();
      final mockSession = MockSession();
      final mockSessionService = MockSessionService();
      final mockSocialAuthService = MockSocialAuthService();
      final mockAccount = MockAccount();

      final mockUsername = 'John Doe';

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
        build: () => AccountBloc(
          mockSessionService,
          mockSocialAuthService,
          mockClient,
        ),
        act: (bloc) => bloc.add(ReadAccount()),
        seed: () => AccountState(isLoading: true),
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

      blocTest<AccountBloc, AccountState>(
        'UpdateAccount: updates the username on a user\'s account',
        setUp: () {
          when(
            () => mockSessionService.getSession(),
          ).thenAnswer((_) async => mockSession);

          when(
            () => mockClient.updateAccount(
              session: mockSession,
              username: mockUsername,
            ),
          ).thenAnswer((_) async => mockAccount);

          when(
            () => mockClient.getAccount(mockSession),
          ).thenAnswer((_) async => mockAccount);
        },
        build: () => AccountBloc(
          mockSessionService,
          mockSocialAuthService,
          mockClient,
        ),
        act: (bloc) => bloc.add(UpdateAccount(username: mockUsername)),
        seed: () => AccountState(isLoading: true),
        expect: () => [
          AccountState(
            account: mockAccount,
            status: FormzSubmissionStatus.initial,
            isLoading: false,
            error: null,
            success: Globals.feedbackMessages.accountUpdateSuccess,
          ),
        ],
      );

      blocTest<AccountBloc, AccountState>(
        'DeleteAccount: deletes the account',
        setUp: () {
          when(
            () => mockSessionService.getSession(),
          ).thenAnswer((_) async => mockSession);

          when(
            () => mockClient.rpc(
              session: mockSession,
              id: Globals.rpcIds.accountDeleteId,
            ),
          ).thenAnswer((_) async {
            return;
          });

          when(
            () => mockClient.getAccount(mockSession),
          ).thenAnswer((_) async => mockAccount);

          when(() => mockSessionService.logout()).thenAnswer((_) async => true);
        },
        build: () => AccountBloc(
          mockSessionService,
          mockSocialAuthService,
          mockClient,
        ),
        act: (bloc) => bloc.add(DeleteAccount()),
        seed: () => AccountState(isLoading: true),
        expect: () => [
          AccountState(
            account: null,
            status: FormzSubmissionStatus.initial,
            isLoading: false,
            error: null,
            success: Globals.feedbackMessages.accountDeleteSuccess,
          ),
        ],
      );
    },
  );
}
