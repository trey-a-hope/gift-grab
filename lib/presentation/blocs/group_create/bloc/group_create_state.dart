part of 'group_create_bloc.dart';

class GroupCreateState extends BaseState with FormzMixin {
  final ShortText name;
  final LongText description;
  final Slider maxCount;
  final Toggle isOpen;
  final FormzSubmissionStatus status;
  final bool isLoading;
  final String? success;
  final String? error;

  GroupCreateState({
    this.name = const ShortText.pure(),
    this.description = const LongText.pure(),
    this.maxCount = const Slider.pure(),
    this.isOpen = const Toggle.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isLoading = false,
    this.success,
    this.error,
  });

  GroupCreateState copyWith({
    ShortText? name,
    LongText? description,
    Slider? maxCount,
    Toggle? isOpen,
    FormzSubmissionStatus? status,
    bool? isLoading,
    String? success,
    String? error,
  }) =>
      GroupCreateState(
        name: name ?? this.name,
        description: description ?? this.description,
        maxCount: maxCount ?? this.maxCount,
        isOpen: isOpen ?? this.isOpen,
        status: status ?? this.status,
        isLoading: isLoading == true ? true : false,
        success: success,
        error: error,
      );

  @override
  List<FormzInput<dynamic, dynamic>> get inputs => [
        name,
        description,
        maxCount,
      ];
}
