part of 'group_create_bloc.dart';

class GroupCreateState extends BaseState with FormzMixin {
  final Name name;
  final Comment description;
  final Slider maxCount;
  final FormzSubmissionStatus status;
  final bool isLoading;
  final String? success;
  final String? error;

  GroupCreateState({
    this.name = const Name.pure(),
    this.description = const Comment.pure(),
    this.maxCount = const Slider.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isLoading = false,
    this.success,
    this.error,
  });

  GroupCreateState copyWith({
    Name? name,
    Comment? description,
    Slider? maxCount,
    FormzSubmissionStatus? status,
    bool? isLoading,
    String? success,
    String? error,
  }) =>
      GroupCreateState(
        name: name ?? this.name,
        description: description ?? this.description,
        maxCount: maxCount ?? this.maxCount,
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
