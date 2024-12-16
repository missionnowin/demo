part of 'case_card_image_bloc.dart';

@immutable
abstract class CaseCardImageEvent {}
class LoadCaseCardImage extends CaseCardImageEvent{
  final String? id;

  LoadCaseCardImage(this.id);
}