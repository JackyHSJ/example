import 'package:intl/intl.dart';

class DateFormatUtil {
  static String _buildDataFormat({required String strFormat, required DateTime time}) {
    return DateFormat(strFormat).format(time);
  }

  static String getMinAndSecFormat(DateTime time) {
    return _buildDataFormat(strFormat: 'mm:ss', time: time);
  }

  /// 1 天 1:07:45
  static String getDayAndTimeFormat(DateTime time) {
    return _buildDataFormat(strFormat: 'dd 天 hh:mm:ss', time: time);
  }

  ///MARK: 2022-09
  static String getDateWithMonthFormat(DateTime time) {
    return _buildDataFormat(strFormat: 'yyyy-MM', time: time);
  }

  ///MARK: 2022/09/06 11:46 AM
  static String getDateWith12HourFormat(DateTime time) {
    return _buildDataFormat(strFormat: 'yyyy/MM/dd hh:mm a', time: time);
  }

  ///MARK: 2022-09-06 11:46:01
  static String getDateWith24HourFormat(DateTime time, {bool needHHMMSS = false}) {
    if(needHHMMSS) {
      return _buildDataFormat(strFormat: 'yyyy-MM-dd hh:mm:ss', time: time);
    }
    return _buildDataFormat(strFormat: 'yyyy-MM-dd', time: time);
  }

  ///MARK: 06 Sep 2022
  static String getDateWithDayMouthYear(DateTime time) {
    return _buildDataFormat(strFormat: 'dd LLL yyyy', time: time);
  }

  // 2023-11-03 00:00:00
  static String getDateWithFirstSecondFormat(DateTime time){
    return _buildDataFormat(strFormat: 'yyyy-MM-dd 00:00:00', time: time);
  }

  // 2023-11-03 23:59:59
  static String getDateWithLastSecondFormat(DateTime time){
    return _buildDataFormat(strFormat: 'yyyy-MM-dd 23:59:59', time: time);
  }

  static String formatDateTime(DateTime dateTime) {
    final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(dateTime);
  }

  ///MARK: 11:46 AM
  static String getDateWith12HourTimeFormat(DateTime time) {
    return _buildDataFormat(strFormat: 'hh:mm a', time: time);
  }
}
