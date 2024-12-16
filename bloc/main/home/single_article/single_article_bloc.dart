import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:child_healthcare/models/api_models/api_article.dart';
import 'package:child_healthcare/network/network_service.dart';
import 'package:meta/meta.dart';

part 'single_article_event.dart';
part 'single_article_state.dart';

class SingleArticleBloc extends Bloc<SingleArticleEvent, SingleArticleState> {
  SingleArticleBloc() : super(SingleArticleInitial()) {
    on<LoadSingleArticle>(_onLoad);
    on<MarkAsCompleted>(_onMark);
  }

  Future<void> _onLoad(LoadSingleArticle event, Emitter<SingleArticleState> emit) async{
    try{
      final article = await NetworkService().getArticle(event.id);
      emit(SingleArticleLoaded(article));
    }catch (e){
      emit(SingleArticleError());
    }
  }

  Future<void> _onMark(MarkAsCompleted event, Emitter<SingleArticleState> emit) async{
    try{
      await NetworkService().markAsComplete(event.id);
    }catch(e){
      print(e);
    }
  }
}
