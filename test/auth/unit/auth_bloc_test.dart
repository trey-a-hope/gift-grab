// import 'package:bloc_test/bloc_test.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:gift_grab/data/services/nakama_session_service.dart';
// import 'package:gift_grab/presentation/blocs/auth/bloc/auth_bloc.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:nakama/nakama.dart';

// class MockNakamaClient extends Mock implements NakamaBaseClient {}

// class MockSession extends Mock implements Session {}

// class MockNakamaSessionService extends Mock implements NakamaSessionService {}

// void main() {
//   const email = 'trey.a.hope@gmail.com';
//   const password = 'Peachy4040';

//   group(
//     'AuthBloc',
//     () {
//       late AuthBloc bloc;
//       late MockNakamaClient mockClient;
//       late MockSession mockSession;
//       late MockNakamaSessionService mockSessionService;

//       setUp(() {
//         mockClient = MockNakamaClient();
//         mockSession = MockSession();
//         mockSessionService = MockNakamaSessionService();
//       });

//       tearDown(() {
//         bloc.close();
//       });

//       blocTest<AuthBloc, AuthState>(
//         'LoginEmail',
//         setUp: () {
//           when(
//             () => mockClient.authenticateEmail(
//               email: email,
//               password: password,
//             ),
//           ).thenAnswer((_) async => mockSession);

//           when(
//             () => mockSessionService.saveSessionTokens(mockSession),
//           ).thenAnswer((_) async => {});
//         },
//         build: () {
//           bloc = AuthBloc(
//             nakamaClient: mockClient,
//             nakamaSessionService: mockSessionService,
//           );
//           return bloc;
//         },
//         act: (bloc) => bloc.add(
//           LoginEmail(
//             email: email,
//             password: password,
//           ),
//         ),
//         expect: () => [
//           AuthState(authenticated: false, isLoading: true),
//           AuthState(authenticated: true, isLoading: false),
//         ],
//       );
//     },
//   );
// }

// TODO: Create another bloc test, since AuthBloc no longer exists.
