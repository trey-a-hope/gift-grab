import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/domain/mixins/smart_bloc_mixin.dart';

abstract class StatelessBloc<B extends Bloc, S> extends StatelessWidget
    with SmartBlocMixin<B, S> {
  const StatelessBloc({super.key});
}
