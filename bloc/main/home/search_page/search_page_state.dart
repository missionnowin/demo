part of 'search_page_bloc.dart';

@immutable
abstract class SearchPageState {
  final String? initialSearch;

  const SearchPageState(this.initialSearch);
}

class SearchPageInitial extends SearchPageState {
  const SearchPageInitial(super.initialSearch);
}
class SearchPageLoading extends SearchPageState {
  const SearchPageLoading(super.initialSearch);
}
class SearchPageLoaded extends SearchPageState {
  final Map<int, List<ApiArticleReduced>>? articles;
  final List<ApiArticleReduced>? articlesUnsorted;

  const SearchPageLoaded(this.articles, super.initialSearch, this.articlesUnsorted);
}
class SearchPageLoadedLastPage extends SearchPageLoaded{
  const SearchPageLoadedLastPage(super.articles, super.initialSearch, super.articlesUnsorted);
}
class SearchPageError extends SearchPageState {
  const SearchPageError(super.initialSearch);
}
class SearchPageLoadingNext extends SearchPageLoaded{
  const SearchPageLoadingNext(super.articles, super.initialSearch, super.articlesUnsorted);
}
