part of 'single_article_bloc.dart';

@immutable
abstract class SingleArticleEvent {}
class LoadSingleArticle extends SingleArticleEvent{
  final String id;

  LoadSingleArticle(this.id);
}

class MarkAsCompleted extends SingleArticleEvent{
  final String id;

  MarkAsCompleted(this.id);
}
