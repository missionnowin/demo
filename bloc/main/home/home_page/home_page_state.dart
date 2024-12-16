part of 'home_page_bloc.dart';

@immutable
abstract class HomePageState {}

class HomePageInitial extends HomePageState {}
class HomePageError extends HomePageState {}
class HomePageLoaded extends HomePageState{
  final ApiArticle? article;

  HomePageLoaded(this.article);
}
