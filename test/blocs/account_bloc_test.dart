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
      late AccountBloc bloc;
      late MockNakamaClient mockClient;
      late MockSession mockSession;
      late MockSessionService mockSessionService;
      late MockSocialAuthService mockSocialAuthService;
      late MockAccount mockAccount;

      final mockUsername = 'John Doe';

      setUp(() async {
        mockClient = MockNakamaClient();
        mockSession = MockSession();
        mockSessionService = MockSessionService();
        mockAccount = MockAccount();
        mockSocialAuthService = MockSocialAuthService();

        when(
          () => mockSessionService.getSession(),
        ).thenAnswer((_) async => mockSession);
      });

      tearDown(() {
        bloc.close();
      });

      blocTest<AccountBloc, AccountState>(
        'ReadAccount: emits account data with initial status when ReadAccount event is successfully processed',
        setUp: () {
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

      blocTest<AccountBloc, AccountState>(
        'UpdateAccount: updates the username on a user\'s account',
        setUp: () {
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
        build: () {
          bloc = AccountBloc(
            mockSessionService,
            mockSocialAuthService,
            mockClient,
          );
          return bloc;
        },
        act: (bloc) => bloc.add(UpdateAccount(username: mockUsername)),
        expect: () => [
          AccountState(
            account: null,
            status: FormzSubmissionStatus.initial,
            isLoading: true,
            error: null,
            success: null,
          ),
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
        build: () {
          bloc = AccountBloc(
            mockSessionService,
            mockSocialAuthService,
            mockClient,
          );
          return bloc;
        },
        act: (bloc) => bloc.add(DeleteAccount()),
        expect: () => [
          AccountState(
            account: null,
            status: FormzSubmissionStatus.initial,
            isLoading: true,
            error: null,
            success: null,
          ),
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
