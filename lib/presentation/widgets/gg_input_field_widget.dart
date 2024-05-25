import 'package:flutter/material.dart';
import 'package:gift_grab/data/constants/globals.dart';

class GGInputFieldWidget extends StatefulWidget {
  final Function(String)? onChanged;
  final String? hintText;
  final int? maxLength;
  final int? maxLines;

  const GGInputFieldWidget({
    super.key,
    required this.onChanged,
    this.hintText,
    this.maxLength,
    this.maxLines,
  });

  @override
  State<GGInputFieldWidget> createState() => _GGInputFieldWidgetState();
}

class _GGInputFieldWidgetState extends State<GGInputFieldWidget> {
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: _controller,
      textAlign: TextAlign.center,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      onChanged: widget.onChanged,
      style: theme.textTheme.displayLarge!.copyWith(
        fontSize: Globals.isTablet
            ? theme.textTheme.displayLarge!.fontSize! * 2
            : theme.textTheme.displayLarge!.fontSize,
      ),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        hintText: widget.hintText,
        filled: true,
        fillColor: Colors.black.withOpacity(0.1),
      ),
    );
  }
}
