import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyDateUtil {


  static String getFormattedTime({required BuildContext context, required String time, required}) {

    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  } 
  static String getLastMessageTime({required BuildContext context, required String time}) {
    final sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final now = DateTime.now();
    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      return TimeOfDay.fromDateTime(sent).format(context);
    }else{
      return '${sent.day} ${_getMonth(sent)}';
    }
    
  }
  


    static String getMessageTimeWithYear({required BuildContext context, required String time}) {
    final sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final now = DateTime.now();
    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      return TimeOfDay.fromDateTime(sent).format(context);
    }else{
      return '${sent.day} ${_getMonth(sent)}, ${sent.year}';
    }
    
  }
  


  static String _getMonth(DateTime sent) {
    switch (sent.month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sept';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';  
      case 12:
        return 'Dec';
    }
    return 'NA';
  } 




// get formatted last active time from epoch string to time
 static String  getLastActiveTime({required BuildContext context, required String lasActiveTime, required String time}){

  final i = int.tryParse(lasActiveTime) ?? -1;

  // if time is not available then return below statement
  if( i == -1) return 'Last seen not available';

  final time = DateTime.fromMillisecondsSinceEpoch(i);
  final now = DateTime.now();

  String formatted_Time = TimeOfDay.fromDateTime(time).format(context);
  if (now.day == time.day &&
        now.month == time.month &&
        now.year == time.year) {
    return 'Last seen today at $formatted_Time';
  }
  if ( (now.difference(time).inHours/24).round() == 1 ) {
    return 'Last seen yesterday at $formatted_Time';
  }

  String month = _getMonth(time);
  return 'Last seen on ${time.day} $month on $formatted_Time';
}

}