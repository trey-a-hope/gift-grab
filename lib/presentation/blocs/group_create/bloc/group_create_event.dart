part of 'group_create_bloc.dart';

sealed class GroupCreateEvent {
  const GroupCreateEvent();
}

class Init extends GroupCreateEvent {
  const Init();
}

class NameChanged extends GroupCreateEvent {
  final String name;
  const NameChanged(this.name);
}

class DescriptionChanged extends GroupCreateEvent {
  final String description;
  const DescriptionChanged(this.description);
}

class MaxCountChanged extends GroupCreateEvent {
  final int maxCount;
  const MaxCountChanged(this.maxCount);
}

class IsOpenChanged extends GroupCreateEvent {
  final bool isOpen;
  const IsOpenChanged(this.isOpen);
}

class SubmitForm extends GroupCreateEvent {
  const SubmitForm();
}

class CreateGroup extends GroupCreateEvent {
  const CreateGroup();
}

class UpdateGroup extends GroupCreateEvent {
  const UpdateGroup();
}
