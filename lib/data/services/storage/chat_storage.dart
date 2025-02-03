part of 'base_storage_service.dart';

// TODO: Create DirectChat Storage that will store all users B that user A has. Collection is the same, but key and value are different.

class ChatStorage extends BaseStorageService<List<String>> {
  @override
  String get collection => 'chat';

  @override
  String get key => 'rooms';

  @override
  String get valueKey => 'rooms';

  @override
  List<String> get defaultValue => [];

  @override
  List<String> parseValue(dynamic json) => List<String>.from(json[valueKey]);

  @override
  Map<String, dynamic> serializeValue(List<String> value) => {valueKey: value};
}
