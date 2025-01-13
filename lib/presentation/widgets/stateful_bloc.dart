import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_grab/domain/mixins/smart_bloc_mixin.dart';

abstract class StatefulBloc<B extends Bloc, S> extends StatefulWidget {
  const StatefulBloc({super.key});
}

abstract class StatefulBlocState<T extends StatefulBloc<B, S>, B extends Bloc,
    S> extends State<T> with SmartBlocMixin<B, S> {}
