import 'package:flutter_test/flutter_test.dart';
import 'package:gift_grab/data/constants/globals.dart';
import 'package:gift_grab/presentation/blocs/profile/bloc/profile_bloc.dart';

void main() {
  group(
    ProfileState,
    () {
      test(
        Globals.testDescriptions.state.initialValues,
        () {
          final state = ProfileState();

          expect(state.user, isNull);
          expect(state.isMyProfile, false);
          expect(state.success, isNull);
          expect(state.isLoading, false);
          expect(state.error, isNull);
        },
      );

      test(
        Globals.testDescriptions.state.valueEquality,
        () {
          final state1 = ProfileState();
          final state2 = ProfileState();

          expect(state1, equals(state2));
        },
      );

      test(
        Globals.testDescriptions.state.copyWithNoParams,
        () {
          expect(ProfileState().copyWith(), ProfileState());
        },
      );

      test(
        Globals.testDescriptions.state.copyWithPreserveState,
        () {
          final originalState = ProfileState(
            user: null,
            isMyProfile: false,
            isLoading: false,
            error: null,
            success: null,
          );

          final newState = originalState.copyWith();

          expect(newState.user, equals(null));
          expect(newState.isMyProfile, equals(false));
          expect(newState.isLoading, equals(false));
          expect(newState.error, equals(null));
          expect(newState.success, equals(null));
        },
      );

      test(
        Globals.testDescriptions.state.copyWithNewInstance,
        () {
          final originalState = ProfileState();

          final newState = originalState.copyWith(
            user: null,
            isMyProfile: false,
            isLoading: false,
            error: null,
            success: null,
          );

          expect(newState.user, equals(null));
          expect(newState.isMyProfile, equals(false));
          expect(newState.isLoading, equals(false));
          expect(newState.error, equals(null));
          expect(newState.success, equals(null));
        },
      );

      test(
        Globals.testDescriptions.state.propsContains,
        () {
          final state = ProfileState();

          expect(state.props, hasLength(5));
          expect(state.props, contains(state.user));
          expect(state.props, contains(state.isMyProfile));
          expect(state.props, contains(state.isLoading));
          expect(state.props, contains(state.error));
          expect(state.props, contains(state.success));
        },
      );
    },
  );
}
