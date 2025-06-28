part of 'group_create_bloc.dart';

class GroupCreateState extends Equatable with FormzMixin implements ErrorState {
  final bool isNew;
  final ShortText name;
  final LongText description;
  final Range maxCount;
  final Toggle isOpen;
  final FormzSubmissionStatus status;
  final bool isLoading;
  final String? success;
  final String? error;

  GroupCreateState({
    required this.isNew,
    this.name = const ShortText.pure(),
    this.description = const LongText.pure(),
    this.maxCount = const Range.pure(),
    this.isOpen = const Toggle.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isLoading = false,
    this.success,
    this.error,
  });

  GroupCreateState copyWith({
    ShortText? name,
    LongText? description,
    Range? maxCount,
    Toggle? isOpen,
    FormzSubmissionStatus? status,
    bool? isLoading,
    String? success,
    String? error,
  }) =>
      GroupCreateState(
        isNew: this.isNew,
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
        isOpen,
      ];

  @override
  List<Object?> get props => [
        name,
        description,
        maxCount,
        isOpen,
        status,
        isLoading,
        success,
        error,
      ];
}
