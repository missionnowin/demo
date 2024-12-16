import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:child_healthcare/models/api_models/api_article.dart';
import 'package:child_healthcare/models/api_models/api_child.dart';
import 'package:child_healthcare/network/network_service.dart';
import 'package:meta/meta.dart';

part 'home_page_event.dart';
part 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  HomePageBloc() : super(HomePageInitial()) {
    on<LoadHomePage>(_onLoad);
  }

  Future<void> _onLoad(LoadHomePage event, Emitter<HomePageState> emit) async{
    try{
      emit(HomePageInitial());
      if(event.selectedChild != null){
        if(event.selectedChild?.recommendation != null){
          emit(HomePageLoaded(event.selectedChild?.recommendation));
        }else{
          final newChild = await NetworkService().getChild(event.selectedChild?.id ?? '');
          emit(HomePageLoaded(newChild.recommendation));
        }
      }else{
        emit(HomePageLoaded(null));
      }
    }catch(e){
      emit(HomePageError());
    }
  }
}
