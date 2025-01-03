part of 'game_bloc.dart';

class GameState extends Equatable {
  final int score;
  final int remainingTime;

  final int flameRemainingTime;
  final bool isFlameSpawned;
  final bool isSantaFlamed;

  final bool isGameOver;

  const GameState({
    required this.score,
    required this.remainingTime,
    required this.flameRemainingTime,
    this.isFlameSpawned = false,
    this.isSantaFlamed = false,
    this.isGameOver = false,
  });

  GameState copyWith({
    int? score,
    int? remainingTime,
    int? flameRemainingTime,
    bool? isFlameSpawned,
    bool? isSantaFlamed,
    bool? isGameOver,
  }) =>
      GameState(
        score: score ?? this.score,
        remainingTime: remainingTime ?? this.remainingTime,
        flameRemainingTime: flameRemainingTime ?? this.flameRemainingTime,
        isFlameSpawned: isFlameSpawned ?? this.isFlameSpawned,
        isSantaFlamed: isSantaFlamed ?? this.isSantaFlamed,
        isGameOver: isGameOver ?? this.isGameOver,
      );

  @override
  List<Object?> get props => [
        score,
        remainingTime,
        flameRemainingTime,
        isFlameSpawned,
        isSantaFlamed,
        isGameOver,
      ];
}
