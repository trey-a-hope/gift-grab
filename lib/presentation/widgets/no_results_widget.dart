import 'package:flutter/material.dart';

enum NoResultsEnum {
  friends(name: 'No Friends'),
  groups(name: 'No Groups'),
  notifications(name: 'No Notifications'),
  users(name: 'No Users'),
  ;

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
