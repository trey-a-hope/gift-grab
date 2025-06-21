part of 'group_create_bloc.dart';

sealed class GroupCreateEvent {
  const GroupCreateEvent();
}

class NameChanged extends GroupCreateEvent {
  final String name;
  NameChanged(this.name);
}

class DescriptionChanged extends GroupCreateEvent {
  final String description;
  DescriptionChanged(this.description);
}

class MaxCountChanged extends GroupCreateEvent {
  final int maxCount;
  MaxCountChanged(this.maxCount);
}

class CreateGroup extends GroupCreateEvent {
  const CreateGroup();
}
