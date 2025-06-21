import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gift_grab/presentation/formz_inputs/slider.dart' as formz;

class SliderInput extends StatelessWidget {
  final formz.Slider slider;
  final void Function(double)? onChanged;

  const SliderInput(
    this.slider, {
    this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.people,
              size: 20,
              color: Colors.white,
            ),
            const Gap(8),
            Text(
              'Member Limit',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: Colors.white,
                  ),
            ),
            const Spacer(),
            Text(
              '${slider.value}',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: Colors.white,
                  ),
            ),
          ],
        ),
        const Gap(8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            showValueIndicator: ShowValueIndicator.always,
          ),
          child: Slider(
            value: slider.value.toDouble(),
            min: slider.min.toDouble(),
            max: slider.max.toDouble(),
            label: '${slider.value}',
            onChanged: onChanged,
          ),
        ),
        if (slider.errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              slider.errorMessage!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ),
      ],
    );
  }
}
