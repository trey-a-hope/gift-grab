part of 'leaderboard_bloc.dart';

class LeaderboardState extends Equatable implements ErrorState {
  final List<LeaderboardEntry> entries;
  final bool isLoading;
  final String? error;

  const LeaderboardState({
    this.entries = const [],
    this.isLoading = false,
    this.error,
  });

  LeaderboardState copyWith({
    List<LeaderboardEntry>? entries,
    bool? isLoading,
    String? error,
  }) =>
      LeaderboardState(
        entries: entries ?? this.entries,
        isLoading: isLoading == true ? true : false,
        error: error,
      );

  @override
  List<Object?> get props => [
        entries,
        isLoading,
        error,
      ];
}
