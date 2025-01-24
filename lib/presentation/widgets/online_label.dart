import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class OnlineLabel extends StatelessWidget {
  final bool online;

  const OnlineLabel(
    this.online, {
    super.key,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              online ? MdiIcons.wifi : MdiIcons.wifiOff,
              color: online ? Colors.green : Colors.orange,
              size: 18,
            ),
            SizedBox(width: 8),
            Text(
              online ? 'Online' : 'Offline',
              style: TextStyle(color: Colors.black87),
            ),
          ],
        ),
      );
}
