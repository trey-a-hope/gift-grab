part of 'base_storage_service.dart';

class DirectChatStorage extends BaseStorageService<List<String>> {
  final String uid;

  DirectChatStorage({required this.uid});

  @override
  String get collection => uid;

  @override
  String get key => 'direct-chats';

  @override
  String get valueKey => 'direct-chats';

  @override
  List<String> get defaultValue => [];

  @override
  List<String> parseValue(dynamic json) => List<String>.from(json[valueKey]);

  @override
  Map<String, dynamic> serializeValue(List<String> value) => {valueKey: value};
}
