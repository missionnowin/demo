part of 'home_page_bloc.dart';

@immutable
abstract class HomePageEvent {}
class LoadHomePage extends HomePageEvent{
  final ApiChild? selectedChild;

  LoadHomePage(this.selectedChild);
}