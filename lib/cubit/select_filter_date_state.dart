part of 'select_filter_date_cubit.dart';

@immutable
abstract class SelectFilterDateState {}
class SelectFilterDateInitial extends SelectFilterDateState{}

class FilterDateOnChanged extends SelectFilterDateState {
  final String startDate;
  final String endDate;

  FilterDateOnChanged({required this.startDate, required this.endDate});
}
