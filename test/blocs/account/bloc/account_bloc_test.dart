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

void main() {
  group(
    AccountBloc,
    () {
      final mockClient = MockNakamaClient();
      final mockSession = MockSession();
      final mockSessionService = MockSessionService();
      final mockSocialAuthService = MockSocialAuthService();

      const username = 'John Doe';
      const email = 'doej@gmail.com';
      const password = 'abc123';
      const googleToken = 'google_token';
      const appleToken = 'apple_token';

      final account = Account(
        user: User(
          id: '',
          username: username,
        ),
        email: email,
      );

      group(ReadAccount, () {
        blocTest<AccountBloc, AccountState>(
          'should load account data successfully when ReadAccount event is triggered',
          setUp: () {
            when(
              () => mockSessionService.getSession(),
            ).thenAnswer((_) async => mockSession);

            when(
              () => mockClient.getAccount(mockSession),
            ).thenAnswer((_) async => account);
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
              account: account,
              status: FormzSubmissionStatus.initial,
              isLoading: false,
              error: null,
              success: null,
            ),
          ],
        );
      });

      group(UpdateAccount, () {
        blocTest<AccountBloc, AccountState>(
          'should update username and show success message when UpdateAccount event is successful',
          setUp: () {
            when(
              () => mockSessionService.getSession(),
            ).thenAnswer((_) async => mockSession);

            when(
              () => mockClient.updateAccount(
                session: mockSession,
                username: username,
              ),
            ).thenAnswer((_) async => account);

            when(
              () => mockClient.getAccount(mockSession),
            ).thenAnswer((_) async => account);
          },
          build: () => AccountBloc(
            mockSessionService,
            mockSocialAuthService,
            mockClient,
          ),
          act: (bloc) => bloc.add(
            UpdateAccount(
              username: username,
            ),
          ),
          seed: () => AccountState(isLoading: true),
          expect: () => [
            AccountState(
              account: account,
              status: FormzSubmissionStatus.initial,
              isLoading: false,
              error: null,
              success: Globals.feedbackMessages.accountUpdateSuccess,
            ),
          ],
        );
      });

      group(DeleteAccount, () {
        blocTest<AccountBloc, AccountState>(
          'should delete account and logout user when DeleteAccount event is triggered',
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

            when(() => mockSessionService.logout())
                .thenAnswer((_) async => true);
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
      });

      group(LinkEmailAccount, () {
        blocTest<AccountBloc, AccountState>(
          'should link email account and show success message when LinkEmailAccount event is successful',
          setUp: () {
            when(
              () => mockSessionService.getSession(),
            ).thenAnswer((_) async => mockSession);

            when(
              () => mockClient.linkEmail(
                session: mockSession,
                email: email,
                password: password,
              ),
            ).thenAnswer((_) async => account);
          },
          build: () => AccountBloc(
            mockSessionService,
            mockSocialAuthService,
            mockClient,
          ),
          act: (bloc) => bloc.add(
            LinkEmailAccount(
              email: email,
              password: password,
            ),
          ),
          seed: () => AccountState(isLoading: true),
          expect: () => [
            AccountState(
              status: FormzSubmissionStatus.initial,
              isLoading: false,
              error: null,
              success: Globals.feedbackMessages.accountLinkEmailSuccess,
            ),
          ],
        );
      });

      group(UnlinkEmailAccount, () {
        blocTest<AccountBloc, AccountState>(
          'should show error message when trying to unlink email but email is null',
          setUp: () {
            when(
              () => mockSessionService.getSession(),
            ).thenAnswer((_) async => mockSession);

            when(() => mockClient.unlinkEmail(
                  session: mockSession,
                  email: email,
                  password: '',
                )).thenThrow(
              Exception(Globals.feedbackMessages.accountEmailNull),
            );
          },
          build: () => AccountBloc(
            mockSessionService,
            mockSocialAuthService,
            mockClient,
          ),
          act: (bloc) => bloc.add(
            UnlinkEmailAccount(),
          ),
          seed: () => AccountState(
            account: account.copyWith(email: null),
            isLoading: true,
          ),
          expect: () => [
            AccountState(
              account: account.copyWith(email: null),
              status: FormzSubmissionStatus.initial,
              isLoading: false,
              error:
                  'Unexpected error: Exception: ${Globals.feedbackMessages.accountEmailNull}',
            ),
          ],
        );

        blocTest<AccountBloc, AccountState>(
          'should unlink email account and show success message when UnlinkEmailAccount event is successful',
          setUp: () {
            when(() => mockSessionService.getSession())
                .thenAnswer((_) async => mockSession);

            when(() => mockClient.unlinkEmail(
                  session: mockSession,
                  email: email,
                  password: '',
                )).thenAnswer((_) async => {});
          },
          build: () => AccountBloc(
            mockSessionService,
            mockSocialAuthService,
            mockClient,
          ),
          act: (bloc) => bloc.add(UnlinkEmailAccount()),
          seed: () => AccountState(
            account: account,
            isLoading: true,
          ),
          expect: () => [
            AccountState(
              account: account,
              status: FormzSubmissionStatus.initial,
              isLoading: false,
              success: Globals.feedbackMessages.accountUnlinkEmailSuccess,
            ),
          ],
        );
      });

      group(LinkGoogleAccount, () {
        blocTest<AccountBloc, AccountState>(
          'should do nothing when trying to link Google account but token is null',
          setUp: () {
            when(
              () => mockSessionService.getSession(),
            ).thenAnswer((_) async => mockSession);

            when(
              () => mockSocialAuthService.getGoogleToken(),
            ).thenAnswer((_) async => null);

            when(() => mockClient.linkGoogle(
                  session: mockSession,
                  token: googleToken,
                )).thenAnswer((_) async => {});
          },
          build: () => AccountBloc(
            mockSessionService,
            mockSocialAuthService,
            mockClient,
          ),
          act: (bloc) => bloc.add(LinkGoogleAccount()),
          seed: () => AccountState(
            account: account,
            isLoading: true,
          ),
          expect: () => [
            AccountState(
              account: account,
              status: FormzSubmissionStatus.initial,
              isLoading: false,
            ),
          ],
        );
        blocTest<AccountBloc, AccountState>(
          'should link Google account and show success message when LinkGoogleAccount event is successful',
          setUp: () {
            when(
              () => mockSessionService.getSession(),
            ).thenAnswer((_) async => mockSession);

            when(
              () => mockSocialAuthService.getGoogleToken(),
            ).thenAnswer((_) async => googleToken);

            when(() => mockClient.linkGoogle(
                  session: mockSession,
                  token: googleToken,
                )).thenAnswer((_) async => {});
          },
          build: () => AccountBloc(
            mockSessionService,
            mockSocialAuthService,
            mockClient,
          ),
          act: (bloc) => bloc.add(LinkGoogleAccount()),
          seed: () => AccountState(
            account: account,
            isLoading: true,
          ),
          expect: () => [
            AccountState(
              account: account,
              status: FormzSubmissionStatus.initial,
              isLoading: false,
              success: Globals.feedbackMessages.accountLinkGoogle,
            ),
          ],
        );
      });

      group(UnlinkGoogleAccount, () {
        blocTest<AccountBloc, AccountState>(
          'should do nothing when trying to unlink Google account but token is null',
          setUp: () {
            when(
              () => mockSessionService.getSession(),
            ).thenAnswer((_) async => mockSession);

            when(
              () => mockSocialAuthService.getGoogleToken(),
            ).thenAnswer((_) async => null);

            when(() => mockClient.unlinkGoogle(
                  session: mockSession,
                  token: googleToken,
                )).thenAnswer((_) async => {});
          },
          build: () => AccountBloc(
            mockSessionService,
            mockSocialAuthService,
            mockClient,
          ),
          act: (bloc) => bloc.add(UnlinkGoogleAccount()),
          seed: () => AccountState(
            account: account,
            isLoading: true,
          ),
          expect: () => [
            AccountState(
              account: account,
              status: FormzSubmissionStatus.initial,
              isLoading: false,
            ),
          ],
        );
        blocTest<AccountBloc, AccountState>(
          'should unlink Google account and show success message when UnlinkGoogleAccount event is successful',
          setUp: () {
            when(
              () => mockSessionService.getSession(),
            ).thenAnswer((_) async => mockSession);

            when(
              () => mockSocialAuthService.getGoogleToken(),
            ).thenAnswer((_) async => googleToken);

            when(() => mockClient.unlinkGoogle(
                  session: mockSession,
                  token: googleToken,
                )).thenAnswer((_) async => {});
          },
          build: () => AccountBloc(
            mockSessionService,
            mockSocialAuthService,
            mockClient,
          ),
          act: (bloc) => bloc.add(UnlinkGoogleAccount()),
          seed: () => AccountState(
            account: account,
            isLoading: true,
          ),
          expect: () => [
            AccountState(
              account: account,
              status: FormzSubmissionStatus.initial,
              isLoading: false,
              success: Globals.feedbackMessages.accountUnlinkGoogle,
            ),
          ],
        );
      });

      group(LinkAppleAccount(), () {
        blocTest<AccountBloc, AccountState>(
          'should do nothing when trying to link Apple account but token is null',
          setUp: () {
            when(
              () => mockSessionService.getSession(),
            ).thenAnswer((_) async => mockSession);

            when(
              () => mockSocialAuthService.getAppleToken(),
            ).thenAnswer((_) async => null);

            when(() => mockClient.linkApple(
                  session: mockSession,
                  token: appleToken,
                )).thenAnswer((_) async => {});
          },
          build: () => AccountBloc(
            mockSessionService,
            mockSocialAuthService,
            mockClient,
          ),
          act: (bloc) => bloc.add(LinkAppleAccount()),
          seed: () => AccountState(
            account: account,
            isLoading: true,
          ),
          expect: () => [AccountState(account: account)],
        );
        blocTest<AccountBloc, AccountState>(
          'should link Apple account and show success message when LinkAppleAccount event is successful',
          setUp: () {
            when(
              () => mockSessionService.getSession(),
            ).thenAnswer((_) async => mockSession);

            when(
              () => mockSocialAuthService.getAppleToken(),
            ).thenAnswer((_) async => appleToken);

            when(() => mockClient.linkApple(
                  session: mockSession,
                  token: appleToken,
                )).thenAnswer((_) async => {});
          },
          build: () => AccountBloc(
            mockSessionService,
            mockSocialAuthService,
            mockClient,
          ),
          act: (bloc) => bloc.add(LinkAppleAccount()),
          seed: () => AccountState(
            account: account,
            isLoading: true,
          ),
          expect: () => [
            AccountState(
              account: account,
              status: FormzSubmissionStatus.initial,
              isLoading: false,
              success: Globals.feedbackMessages.accountLinkApple,
            ),
          ],
        );
      });

      group(UnlinkAppleAccount(), () {
        blocTest<AccountBloc, AccountState>(
          'should do nothing when trying to unlink Apple account but token is null',
          setUp: () {
            when(
              () => mockSessionService.getSession(),
            ).thenAnswer((_) async => mockSession);

            when(
              () => mockSocialAuthService.getAppleToken(),
            ).thenAnswer((_) async => null);

            when(() => mockClient.unlinkApple(
                  session: mockSession,
                  token: appleToken,
                )).thenAnswer((_) async => {});
          },
          build: () => AccountBloc(
            mockSessionService,
            mockSocialAuthService,
            mockClient,
          ),
          act: (bloc) => bloc.add(UnlinkAppleAccount()),
          seed: () => AccountState(
            account: account,
            isLoading: true,
          ),
          expect: () => [AccountState(account: account)],
        );
        blocTest<AccountBloc, AccountState>(
          'should unlink Apple account and show success message when UnlinkAppleAccount event is successful',
          setUp: () {
            when(
              () => mockSessionService.getSession(),
            ).thenAnswer((_) async => mockSession);

            when(
              () => mockSocialAuthService.getAppleToken(),
            ).thenAnswer((_) async => appleToken);

            when(() => mockClient.unlinkApple(
                  session: mockSession,
                  token: appleToken,
                )).thenAnswer((_) async => {});
          },
          build: () => AccountBloc(
            mockSessionService,
            mockSocialAuthService,
            mockClient,
          ),
          act: (bloc) => bloc.add(UnlinkAppleAccount()),
          seed: () => AccountState(
            account: account,
            isLoading: true,
          ),
          expect: () => [
            AccountState(
              account: account,
              status: FormzSubmissionStatus.initial,
              isLoading: false,
              success: Globals.feedbackMessages.accountUnlinkApple,
            ),
          ],
        );
      });
    },
  );
}
