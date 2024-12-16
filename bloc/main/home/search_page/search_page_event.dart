part of 'search_page_bloc.dart';

@immutable
abstract class SearchPageEvent {}
class SearchArticles extends SearchPageEvent{
  final String? name;

  SearchArticles(this.name);
}
class NextPage extends SearchPageEvent{

}

