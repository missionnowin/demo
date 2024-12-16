import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:child_healthcare/models/api_models/api_article_reduced.dart';
import 'package:child_healthcare/network/network_service.dart';
import 'package:meta/meta.dart';

part 'search_page_event.dart';
part 'search_page_state.dart';

class SearchPageBloc extends Bloc<SearchPageEvent, SearchPageState> {
  int page = 1;

  SearchPageBloc(String? initialSearch) : super(SearchPageInitial(initialSearch)) {
    on<SearchArticles>(_onSearch);
    on<NextPage>(_onNext);
  }

  Future<void> _onSearch(SearchArticles event, Emitter<SearchPageState> emit) async{
    try{
      emit(SearchPageLoading(state.initialSearch));
      String? name = event.name?.trim();
      page = 1;
      List<ApiArticleReduced> articles = await NetworkService().searchArticles(name: name, page: page++);
      emit(SearchPageLoaded(null, event.name, articles));
    }catch(e){
      emit(SearchPageError(event.name));
    }
  }

  Future<void> _onNext(NextPage event, Emitter<SearchPageState> emit) async{
    if(state is SearchPageLoaded && state is! SearchPageLoadedLastPage){
      final searchState = (state as SearchPageLoaded);
      int pageOld = page;
      try{
        emit(SearchPageLoadingNext(searchState.articles, searchState.initialSearch, searchState.articlesUnsorted));
        String? name = searchState.initialSearch?.trim();
        final newArticles = await NetworkService().searchArticles(name: name, page: page++);
        if(newArticles.isNotEmpty){
          List<ApiArticleReduced>? oldArticlesUnsorted;
          oldArticlesUnsorted = searchState.articlesUnsorted ?? [];
          for(int i = 0; i < newArticles.length; i++){
            oldArticlesUnsorted.add(newArticles[i]);
          }
          emit(SearchPageLoaded(null, searchState.initialSearch, oldArticlesUnsorted));
        }else{
          emit(SearchPageLoadedLastPage(searchState.articles, searchState.initialSearch, searchState.articlesUnsorted));
        }
      }catch(e){
        emit(SearchPageLoaded(searchState.articles, searchState.initialSearch, searchState.articlesUnsorted));
        page = pageOld;
      }
    }
  }


}
