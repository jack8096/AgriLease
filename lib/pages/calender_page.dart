import 'package:agrilease/pages/chats.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_clean_calendar/controllers/clean_calendar_controller.dart';
import 'package:scrollable_clean_calendar/scrollable_clean_calendar.dart';
import 'package:scrollable_clean_calendar/utils/enums.dart';

class CalenderPage extends StatelessWidget {
  final CleanCalendarController calendarController;
  final String reciverEmail;
  final String chatRoomID;

  const CalenderPage({super.key, required this.calendarController, required this.chatRoomID, required this.reciverEmail,});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(appBar: AppBar(backgroundColor: Colors.white, surfaceTintColor: Colors.transparent,),
      body: Container( color: Colors.white, 
        child: ScrollableCleanCalendar(
          daySelectedBackgroundColor: Colors.green[400],
          daySelectedBackgroundColorBetween: Colors.green[100],
          calendarController: calendarController, layout:Layout.BEAUTY, ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: ()async{ final DateTime? minDate = calendarController.rangeMinDate;  final DateTime? maxDate = calendarController.rangeMaxDate;
        if(minDate!=null && maxDate!=null){
        await Chats().sendScheduleRequest(reciverEmail, chatRoomID, minDate, maxDate).then((value){ print("floting button  ${calendarController.minDate}, ${calendarController.maxDate}"); Navigator.of(context).pop();} );}},
        backgroundColor: Colors.black,  
        shape: Border.all(),
        child: const Text("Request Date",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), 
        textAlign: TextAlign.center,),),
      );
  }
}
