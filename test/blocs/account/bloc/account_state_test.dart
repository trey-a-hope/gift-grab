import 'package:formz/formz.dart';
import 'package:gift_grab/presentation/blocs/account/bloc/account_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nakama/nakama.dart';

void main() {
  group(AccountState, () {
    final status = FormzSubmissionStatus.initial;
    final account = Account(user: User(id: ''));

    test('should have correct initial values', () {
      const state = AccountState();

      expect(state.account, isNull);
      expect(state.status, status);
      expect(state.success, isNull);
      expect(state.isLoading, false);
      expect(state.error, isNull);
    });

    test('should support value equality', () {
      const state1 = AccountState();
      const state2 = AccountState();

      expect(state1, equals(state2));
    });

    test('returns same object when no properties are passed', () {
      expect(AccountState().copyWith(), AccountState());
    });

    test('copyWith should preserve existing values when no parameters provided',
        () {
      final originalState = AccountState(
        account: account,
        status: status,
        isLoading: false,
        error: null,
        success: null,
      );

      final newState = originalState.copyWith();

      expect(newState.account, equals(account));
      expect(newState.status, equals(status));
      expect(newState.isLoading, equals(false));
      expect(newState.error, equals(null));
      expect(newState.success, equals(null));
    });

    test('copyWith should return new instance with updated values', () {
      final originalState = AccountState();

      final newState = originalState.copyWith(
        account: account,
        status: status,
        isLoading: false,
        error: null,
        success: null,
      );

      expect(newState.account, equals(account));
      expect(newState.status, equals(status));
      expect(newState.isLoading, equals(false));
      expect(newState.error, equals(null));
      expect(newState.success, equals(null));
    });

    test('props should contain all properties', () {
      const state = AccountState();

      expect(state.props, hasLength(5));
      expect(state.props, contains(state.account));
      expect(state.props, contains(state.status));
      expect(state.props, contains(state.error));
      expect(state.props, contains(state.success));
    });
  });
}
