import 'package:gift_grab/domain/blocs/account/account_bloc.dart';

extension AccountBlocX on AccountBloc {
  String get uid => switch (state) {
        AccountLoaded(account: final account) => account!.user.id,
        _ => throw Exception('Account not loaded'),
      };
}
