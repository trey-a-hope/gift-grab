import 'package:dio/dio.dart';

double ensureDouble(dynamic value) {
  if (value is int) return value.toDouble();
  return value as double;
}

class Profanity {
  final bool isProfanity;
  final double score;
  final String? flaggedFor;

  Profanity({
    required this.isProfanity,
    required this.score,
    this.flaggedFor,
  });
}

class ProfanityService {
  static final ProfanityService _instance = ProfanityService._internal();
  static const _url = 'https://vector.profanity.dev';

  final _dio = Dio();

  ProfanityService._internal();

  factory ProfanityService() {
    return _instance;
  }

  Future<void> check(String message) async {
    final res = await _dio.post(
      _url,
      data: {'message': message},
      options: Options(contentType: 'application/json'),
    );

    final data = res.data;

    final profanity = Profanity(
      isProfanity: data['isProfanity'],
      score: ensureDouble(data['score']),
      flaggedFor: data['flaggedFor'],
    );

    if (profanity.isProfanity) {
      throw Exception('"${profanity.flaggedFor}" is a bad word. :(');
    }
  }
}
