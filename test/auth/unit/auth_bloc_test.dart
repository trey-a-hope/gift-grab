import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gift_grab/presentation/blocs/auth/bloc/auth_bloc.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
  });

  group(
    'AuthBloc',
    () {
      blocTest<AuthBloc, AuthState>(
        'emits [] when nothing is added',
        build: () => mockAuthBloc,
        expect: () => [],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoadingState, AuthSuccessState] when LoginEmail is added',
        build: () {
          whenListen(
            mockAuthBloc,
            Stream.fromIterable([
              AuthState(isLoading: true),
              AuthState(authenticated: true),
            ]),
            initialState: AuthState(),
          );

          return mockAuthBloc;
        },
        act: (bloc) => bloc.add(
          LoginEmail(email: 'trey.a.hope@gmail.com', password: 'Peachy4040'),
        ),
        expect: () => [
          predicate<AuthState>((state) =>
              state.isLoading == true && state.authenticated == false),
          predicate<AuthState>((state) =>
              state.isLoading == false && state.authenticated == true),
        ],
      );
    },
  );
}
