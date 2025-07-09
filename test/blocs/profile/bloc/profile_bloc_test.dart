import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gift_grab/domain/services/session_service.dart';
import 'package:gift_grab/domain/services/social_auth_service.dart';
import 'package:gift_grab/presentation/blocs/account/account.dart';
import 'package:gift_grab/presentation/blocs/profile/profile.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nakama/nakama.dart';

class MockSessionService extends Mock implements SessionService {}

class MockSocialAuthService extends Mock implements SocialAuthService {}

class MockNakamaClient extends Mock implements NakamaBaseClient {}

class MockSession extends Mock implements Session {}

class MockAccountBloc extends MockBloc<AccountEvent, AccountState>
    implements AccountBloc {}

void main() {
  group(
    ProfileBloc,
    () {
      final mockClient = MockNakamaClient();
      final mockSession = MockSession();
      final mockSessionService = MockSessionService();
      final mockAccountBloc = MockAccountBloc();

      const id = '03d866b3-8898-4e92-879b-4af0aac49ffa';
      const username = 'John Doe';
      const email = 'doej@gmail.com';
      const user = User(id: id, username: username);
      const users = [user];
      const account = Account(user: user, email: email);

      group(
        ReadProfile,
        () {
          blocTest<ProfileBloc, ProfileState>(
            'should load user profile and determine if it is current user\'s profile when ReadProfile event is triggered',
            setUp: () {
              when(
                () => mockSessionService.getSession(),
              ).thenAnswer((_) async => mockSession);

              when(() => mockAccountBloc.state).thenReturn(
                AccountState(account: account),
              );

              when(
                () => mockClient.getUsers(
                  session: mockSession,
                  ids: [id],
                ),
              ).thenAnswer((_) async => users);
            },
            build: () => ProfileBloc(
              mockSessionService,
              id,
              mockAccountBloc,
              mockClient,
            ),
            act: (bloc) => bloc.add(ReadProfile()),
            seed: () => ProfileState(isLoading: true),
            expect: () => [
              ProfileState(
                user: user,
                isMyProfile: true,
                isLoading: false,
                error: null,
                success: null,
              ),
            ],
          );
        },
      );
    },
  );
}
