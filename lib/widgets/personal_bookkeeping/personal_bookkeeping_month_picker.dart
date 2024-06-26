import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frechat/widgets/theme/original/app_colors.dart';
import 'package:intl/intl.dart';

class PersonalBookkeepingMonthPicker extends StatefulWidget {
  const PersonalBookkeepingMonthPicker(
      {required this.displayDateTime, required this.onStartEndTimeSelected, super.key});

  final DateTime displayDateTime;
  final Function(DateTime, DateTime) onStartEndTimeSelected;

  @override
  State<PersonalBookkeepingMonthPicker> createState() =>
      _PersonalBookkeepingMonthPickerState();
}

class _PersonalBookkeepingMonthPickerState
    extends State<PersonalBookkeepingMonthPicker> {
  DateTime _dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant PersonalBookkeepingMonthPicker oldWidget) {
    _dateTime = widget.displayDateTime;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          _buildDatePicker();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('日期筛选',
                style: TextStyle(
                    color: AppColors.textFormBlack,
                    fontSize: 14,
                    fontWeight: FontWeight.w900)),
            Row(
              children: [
                Text(DateFormat('yyyy-MM').format(widget.displayDateTime),
                    style: const TextStyle(
                        color: AppColors.textFormBlack, fontSize: 14)),
                SizedBox(
                    width: 20,
                    height: 20,
                    child:
                        Image.asset('assets/strike_up_list/date_picker.png')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ///日期選單
  _buildDatePicker() async {
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => SizedBox(
        height: 250,
        child: CupertinoDatePicker(
          backgroundColor: Colors.white,
          initialDateTime: _dateTime,
          onDateTimeChanged: (DateTime newTime) {
            setState(() {
              _dateTime = newTime;
            });
          },
          mode: CupertinoDatePickerMode.date,
          maximumDate: DateTime.now(),
        ),
      ),
    );

    //Date set
    // print('[onStartEndTimeSelected]');
    widget.onStartEndTimeSelected( 
        getStartTime(_dateTime), getEndTime(_dateTime));
  }

  static DateTime getStartTime(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month);
  }

  static DateTime getEndTime(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month + 1);
  }
}
