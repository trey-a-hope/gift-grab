part of 'game_bloc.dart';

class GameState extends Equatable {
  final int score;
  final int remainingTime;
  final int flameRemainingTime;
  final bool isGameOver;
  final bool isSantaFlamed;
  final bool isSantaFrozen;
  final double santaSpeed;
  final bool isFlameSpawned;

  const GameState({
    this.score = 0,
    this.remainingTime = 30,
    this.flameRemainingTime = 10,
    this.isGameOver = false,
    this.isSantaFlamed = false,
    this.isSantaFrozen = false,
    this.santaSpeed = 500,
    this.isFlameSpawned = false,
  });

  GameState copyWith({
    int? score,
    int? remainingTime,
    int? flameRemainingTime,
    bool? isGameOver,
    bool? isSantaFlamed,
    bool? isSantaFrozen,
    double? santaSpeed,
    bool? isFlameSpawned,
  }) {
    return GameState(
      score: score ?? this.score,
      remainingTime: remainingTime ?? this.remainingTime,
      flameRemainingTime: flameRemainingTime ?? this.flameRemainingTime,
      isGameOver: isGameOver ?? this.isGameOver,
      isSantaFlamed: isSantaFlamed ?? this.isSantaFlamed,
      isSantaFrozen: isSantaFrozen ?? this.isSantaFrozen,
      santaSpeed: santaSpeed ?? this.santaSpeed,
      isFlameSpawned: isFlameSpawned ?? this.isFlameSpawned,
    );
  }

  @override
  List<Object?> get props => [
        score,
        remainingTime,
        flameRemainingTime,
        isGameOver,
        isSantaFlamed,
        isSantaFrozen,
        santaSpeed,
        // santaPosition,
        // santaMovement,
        isFlameSpawned,
      ];
}
