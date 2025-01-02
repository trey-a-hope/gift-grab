import 'package:equatable/equatable.dart';

class GameState extends Equatable {
  final int score;
  final int remainingTime;
  final int flameRemainingTime;
  final bool isFlameActive;
  final bool isGameOver;

  const GameState({
    required this.score,
    required this.remainingTime,
    required this.flameRemainingTime,
    this.isFlameActive = false,
    this.isGameOver = false,
  });

  GameState copyWith({
    int? score,
    int? remainingTime,
    int? flameRemainingTime,
    bool? isFlameActive,
    bool? isGameOver,
  }) =>
      GameState(
        score: score ?? this.score,
        remainingTime: remainingTime ?? this.remainingTime,
        flameRemainingTime: flameRemainingTime ?? this.flameRemainingTime,
        isFlameActive: isFlameActive ?? this.isFlameActive,
        isGameOver: isGameOver ?? this.isGameOver,
      );

  @override
  List<Object?> get props => [
        score,
        remainingTime,
        flameRemainingTime,
        isFlameActive,
        isGameOver,
      ];
}
