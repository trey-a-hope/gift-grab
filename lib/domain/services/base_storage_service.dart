// domain/services/base_storage_service.dart
import 'package:gift_grab/domain/repositories/i_storage_repository.dart';
import 'package:nakama/nakama.dart';

abstract class BaseStorageService<T> {
  final IStorageRepository storageRepository;

  BaseStorageService(this.storageRepository);

  String get collection;
  String get key;
  String get valueKey;
  T get defaultValue;
  T parseValue(dynamic json);
  Map<String, dynamic> serializeValue(T value);

  Future<T> getValue(Session session, String? uid) async {
    try {
      final data = await storageRepository.getStorageObject(
        session: session,
        collection: collection,
        key: key,
        userId: uid,
      );

      if (data.isEmpty) {
        return defaultValue;
      }

      return parseValue(data);
    } catch (e) {
      throw Exception('Failed to get value: $e');
    }
  }

  Future<void> updateValue(Session session, T newValue) async {
    try {
      await storageRepository.writeStorageObject(
        session: session,
        collection: collection,
        key: key,
        value: serializeValue(newValue),
      );
    } catch (e) {
      throw Exception('Failed to update value: $e');
    }
  }
}
