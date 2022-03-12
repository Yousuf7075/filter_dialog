import 'package:filter_dialog/cubit/select_filter_date_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.greenAccent, // background
            onPrimary: Colors.white, // foreground
          ),
          onPressed: () {
            showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
                      title: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Filter by Date',
                              style: TextStyle(
                                  color: Color(0xff2B344A),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.clear,
                              color: Color(0xff2B344A),
                              size: 20,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ),
                      content: SizedBox(
                          height: 450,
                          width: 300,
                          child: BlocProvider(
                            create: (context) => SelectFilterDateCubit(),
                            child: const FilterDialogContent(),
                          )),
                    ));
          },
          child: const Text('click here to see filter dialog'),
        ),
      ),
    );
  }
}

class FilterDialogContent extends StatefulWidget {
  const FilterDialogContent({Key? key}) : super(key: key);

  @override
  _FilterDialogContentState createState() => _FilterDialogContentState();
}

class _FilterDialogContentState extends State<FilterDialogContent> {
  late SelectFilterDateCubit _selectFilterDateCubit;
  DateTime startDate = DateTime.utc(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0);
  DateTime endDate = DateTime.utc(
      DateTime.now().year, DateTime.now().month, DateTime.now().day + 7, 0, 0);

  @override
  void initState() {
    super.initState();
    _selectFilterDateCubit = context.read<SelectFilterDateCubit>();
    _selectFilterDateCubit.selectFilterDate(
        "${startDate.day}/${startDate.month}/${startDate.year}",
        "${endDate.day}/${endDate.month}/${endDate.year}");
  }

  @override
  Widget build(BuildContext context) {
    const textColor = Color(0xff2B344A);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        BlocBuilder<SelectFilterDateCubit, SelectFilterDateState>(
          builder: (context, state) {
            if (state is FilterDateOnChanged) {
              return Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Start Date",
                        style: TextStyle(
                            color: Color(0xff2B344A),
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TopDateTextView(
                        date: state.startDate,
                      )
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "End Date",
                        style: TextStyle(
                            color: Color(0xff2B344A),
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TopDateTextView(
                        date: state.endDate,
                      )
                    ],
                  )
                ],
              );
            }
            return const SizedBox();
          },
        ),
        const SizedBox(
          height: 25,
        ),
        SfDateRangePicker(
          onSelectionChanged: _onSelectionChanged,
          selectionMode: DateRangePickerSelectionMode.range,
          initialSelectedRange: PickerDateRange(
              DateTime.now(), DateTime.now().add(const Duration(days: 7))),
        ),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: (){
                 //
                },
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          color: const Color(0xffE5E5E5),
                          width: 2.0,
                          style: BorderStyle.solid)),
                  child: const Center(
                    child: Text(
                      "Reset",
                      style: TextStyle(
                        color: textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: InkWell(
                onTap: (){
                  final currentSate = (_selectFilterDateCubit.state as FilterDateOnChanged);
                  //now you can access current state and get start date and end date
                  //currentSate.startDate
                  //currentSate.endDate
                },
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Center(
                    child: Text(
                      "Set Filter",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is PickerDateRange) {
      _selectFilterDateCubit.selectFilterDate(
          DateFormat('dd/MM/yyyy').format(args.value.startDate),
          DateFormat('dd/MM/yyyy')
              .format(args.value.endDate ?? args.value.startDate));
    }
  }
}

class TopDateTextView extends StatelessWidget {
  const TopDateTextView({Key? key, required this.date}) : super(key: key);
  final String date;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 41,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
              color: const Color(0xffE5E5E5),
              width: 2.0,
              style: BorderStyle.solid)),
      child: Center(
        child: Text(
          date,
          style: const TextStyle(
              color: Color(0xff2B344A),
              fontWeight: FontWeight.w400,
              fontSize: 16),
        ),
      ),
    );
  }
}
