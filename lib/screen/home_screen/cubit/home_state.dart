part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeLoaded extends HomeState {
  final List<ChatModel> recentChats;
  final List<ChatModel> favoriteChats;
  final UserModel currentUser;
  final Map<String, UserModel> allUsersMap;

  HomeLoaded({
    required this.recentChats,
    required this.favoriteChats,
    required this.currentUser,
    required this.allUsersMap,
  });
}

final class HomeError extends HomeState {
  final String message;

  HomeError({required this.message});
}
