import 'package:flutter/material.dart';

enum NoResultsEnum {
  groups(name: 'No Groups');

  final String name;

  const NoResultsEnum({
    required this.name,
  });
}

class NoResultsWidget extends StatelessWidget {
  final NoResultsEnum type;
  const NoResultsWidget(this.type, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        type.name,
        style: Theme.of(context).textTheme.displayLarge,
      ),
    );
  }
}
