part of 'single_article_bloc.dart';

@immutable
abstract class SingleArticleState {}

class SingleArticleInitial extends SingleArticleState {}
class SingleArticleLoaded extends SingleArticleState {
  final ApiArticle article;

  SingleArticleLoaded(this.article);
}
class SingleArticleError extends SingleArticleState {}
