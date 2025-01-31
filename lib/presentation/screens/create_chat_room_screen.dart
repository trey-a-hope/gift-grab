import 'package:flutter/material.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';

class CreateChatRoomScreen extends StatelessWidget {
  const CreateChatRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GGScaffoldWidget(
      title: 'Create Chat Room',
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Create'),
          ],
        ),
      ),
    );
  }
}
