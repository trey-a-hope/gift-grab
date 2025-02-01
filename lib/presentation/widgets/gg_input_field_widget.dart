import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GGInputFieldWidget extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSend;
  final String? initialValue;
  final String? hintText;
  final int? maxLength;
  final int? maxLines;
  final TextInputAction textInputAction;
  final TextAlign textAlign;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final bool autofocus;
  final FocusNode? focusNode;
  final TextStyle? textStyle;
  final InputDecoration? decoration;
  final bool enabled;
  final String? errorText;
  final bool obscureText;
  final TextEditingController? controller;

  const GGInputFieldWidget({
    super.key,
    this.onChanged,
    this.onSend,
    this.initialValue,
    this.hintText,
    this.maxLength,
    this.maxLines = 1,
    this.textInputAction = TextInputAction.done,
    this.textAlign = TextAlign.start,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.keyboardType,
    this.autofocus = false,
    this.focusNode,
    this.textStyle,
    this.decoration,
    this.enabled = true,
    this.errorText,
    this.obscureText = false,
    this.controller,
  }) : assert(
          initialValue == null || controller == null,
          'Cannot provide both initialValue and controller',
        );

  @override
  State<GGInputFieldWidget> createState() => _GGInputFieldWidgetState();
}

class _GGInputFieldWidgetState extends State<GGInputFieldWidget> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const defaultTextStyle = TextStyle(color: Colors.white);

    return TextFormField(
      controller: _controller,
      focusNode: _focusNode,
      textAlign: widget.textAlign,
      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      onChanged: widget.onChanged,
      keyboardType: widget.keyboardType,
      autofocus: widget.autofocus,
      enabled: widget.enabled,
      obscureText: widget.obscureText,
      inputFormatters: widget.inputFormatters,
      style: widget.textStyle ?? defaultTextStyle,
      decoration: (widget.decoration ??
          InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.white),
            ),
            hintText: widget.hintText,
            hintStyle: const TextStyle(color: Colors.white70),
            errorText: widget.errorText,
            filled: true,
            fillColor: Colors.black.withValues(alpha: 0.3),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            suffixIcon: widget.onSend == null
                ? null
                : IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                    onPressed: widget.onSend,
                  ),
          )),
      onFieldSubmitted: (_) => widget.onSend?.call(),
    );
  }
}
