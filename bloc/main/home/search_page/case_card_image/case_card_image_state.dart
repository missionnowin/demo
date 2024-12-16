part of 'case_card_image_bloc.dart';

@immutable
abstract class CaseCardImageState {}

class CaseCardImageInitial extends CaseCardImageState {}
class CaseCardImageError extends CaseCardImageState {}
class CaseCardImageLoaded extends CaseCardImageState {
  final MediaContent mediaContent;

  CaseCardImageLoaded(this.mediaContent);
}
class CaseCardNoImage extends CaseCardImageState{}