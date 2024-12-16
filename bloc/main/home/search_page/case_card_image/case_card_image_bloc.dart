import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:child_healthcare/models/api_models/api_article.dart';
import 'package:child_healthcare/network/network_service.dart';
import 'package:meta/meta.dart';

part 'case_card_image_event.dart';
part 'case_card_image_state.dart';

class CaseCardImageBloc extends Bloc<CaseCardImageEvent, CaseCardImageState> {
  CaseCardImageBloc() : super(CaseCardImageInitial()) {
    on<LoadCaseCardImage>(_onLoad);
  }

  Future<void> _onLoad(LoadCaseCardImage event, Emitter<CaseCardImageState> emit) async{
    try{
      if(event.id != null) {
        final mediaContent = await NetworkService().getMedia(event.id!);
        emit(CaseCardImageLoaded(mediaContent));
      }else{
        emit(CaseCardNoImage());
      }
    }catch(e){
      emit(CaseCardImageError());
    }
  }
}
