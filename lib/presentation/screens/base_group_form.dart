import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/presentation/widgets/gg_button_widget.dart';
import 'package:gift_grab/presentation/widgets/gg_input_field_widget.dart';
import 'package:gift_grab/presentation/widgets/gg_scaffold_widget.dart';
import 'package:gift_grab/data/constants/globals.dart';

// TODO: Clean this up more, variable names are nasty.
class BaseGroupForm extends StatefulWidget {
  final String? initialName;
  final String? initialDescription;
  final int initialGroupCount;
  final bool initialIsOpen;
  final String submitButtonText;
  final String title;
  final Function(
    String name,
    String description,
    int groupCount,
    bool isOpen,
  ) onSubmit;
  final void Function()? goBack;

  const BaseGroupForm({
    super.key,
    required this.submitButtonText,
    required this.onSubmit,
    this.goBack,
    required this.title,
    this.initialName,
    this.initialDescription,
    this.initialGroupCount = 2,
    this.initialIsOpen = true,
  });

  @override
  State<BaseGroupForm> createState() => _BaseGroupFormState();
}

class _BaseGroupFormState extends State<BaseGroupForm> {
  static const int _minCount = 2;
  static const int _maxCount = 10;

  late String? _name;
  late String? _description;
  late int _groupCount;
  late bool _isOpen;

  @override
  void initState() {
    super.initState();
    _name = widget.initialName;
    _description = widget.initialDescription;
    _groupCount = widget.initialGroupCount;
    _isOpen = widget.initialIsOpen;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GGScaffoldWidget(
      title: widget.title,
      goBack: widget.goBack,
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: GGInputFieldWidget(
                hintText: 'Enter Group Name',
                maxLength: 20,
                initialValue: _name,
                onChanged: (val) => setState(
                  () => _name = val,
                ),
              ),
            ),
            const Gap(20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: GGInputFieldWidget(
                hintText: 'Description',
                maxLength: 100,
                maxLines: 5,
                initialValue: _description,
                onChanged: (val) => setState(
                  () => _description = val,
                ),
              ),
            ),
            const Gap(20),
            Text(
              'Max Group Count',
              style: theme.textTheme.displaySmall!.copyWith(
                fontSize: Globals.isTablet
                    ? theme.textTheme.displaySmall!.fontSize! * 2
                    : theme.textTheme.displaySmall!.fontSize,
              ),
            ),
            const Gap(20),
            Slider(
              value: _groupCount.toDouble(),
              min: _minCount.toDouble(),
              max: _maxCount.toDouble(),
              divisions: _maxCount - _minCount,
              label: '$_groupCount',
              onChanged: (groupCount) {
                setState(
                  () => _groupCount = groupCount.toInt(),
                );
              },
            ),
            const Gap(20),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Public Group',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  Switch(
                    value: _isOpen,
                    onChanged: (val) => setState(
                      () => _isOpen = val,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(16),
            GGButtonWidget(
              title: widget.submitButtonText,
              onPressed: () => widget.onSubmit(
                _name ?? 'NO NAME GROUP',
                _description ?? 'NO DESCRIPTION GROUP',
                _groupCount,
                _isOpen,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
