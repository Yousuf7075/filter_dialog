import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'select_filter_date_state.dart';

class SelectFilterDateCubit extends Cubit<SelectFilterDateState> {
  SelectFilterDateCubit() : super(SelectFilterDateInitial());

  void selectFilterDate(String startDate, String endDate) =>
      emit(FilterDateOnChanged(startDate: startDate, endDate: endDate));
}
