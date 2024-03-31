import 'package:agrilease/pages/chats.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_clean_calendar/controllers/clean_calendar_controller.dart';
import 'package:scrollable_clean_calendar/scrollable_clean_calendar.dart';
import 'package:scrollable_clean_calendar/utils/enums.dart';

class CalenderPage extends StatelessWidget {
  final CleanCalendarController calendarController;
  final String reciverEmail;
  final String chatRoomID;
  final String productID;
  final String name;
  final String image;
  final String price;

  const CalenderPage({super.key, required this.calendarController, required this.productID, required this.name, required this.image, required this.price, required this.chatRoomID, required this.reciverEmail,});



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
        if(minDate==null || maxDate==null){return ;}
        if(await CalenderTools.instance.isColliding(productID, minDate, maxDate) == true){  
          someFunction(context);
          return ;}
        await Chats().sendScheduleRequest(reciverEmail, chatRoomID, productID, name, image, price, minDate, maxDate).then((value){ 
          // print("floting button  ${calendarController.minDate}, ${calendarController.maxDate}"); 
        Navigator.of(context).pop();} );
        
        },
        backgroundColor: Colors.black,  
        shape: Border.all(),
        child: const Text("Request Date",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), 
        textAlign: TextAlign.center,),),
      );
  }

  void someFunction(context)async{ showDialog(barrierDismissible: false, context: context, builder: (context){
    Future.delayed(const Duration(seconds: 3)).then((value){ Navigator.of(context).pop(); });
    return const DateUnavailableDialog();
  
  // Future.delayed(const Duration(seconds: 3)).then((value){ Navigator.of(context).pop(); });
  });  }
}

class CalenderTools {
  static CalenderTools instance  = CalenderTools();
  final bookCollectionInstance = FirebaseFirestore.instance.collection("bookings");


  
  Future setBookingDate(String productID, DateTime minDate,DateTime maxDate)async{
    if(productID.isEmpty){return ;}
    debugPrint("productID: $productID, minDate: $minDate, maxDate: $maxDate");
    await bookCollectionInstance.doc("bookingDocs").collection(productID).doc(Timestamp.now().toString()).set({minDate.toString():maxDate.toString()});
  }

  Future<Map<String, Map<DateTime, DateTime>>?>  
  getBookingDate(String productID) async{
     QuerySnapshot<Map<String, dynamic>> bookingDates = 
                await bookCollectionInstance.doc("bookingDocs").collection(productID).get();
                
    if(bookingDates.docs.isEmpty == true){ return null;  }
    Map<String, Map<DateTime, DateTime>> dateRangeMap = {};
    // bookingDates.docs.forEach((element) {dateRangeMap[element.id] = {DateTime.parse(element.data().keys.first): DateTime.parse(element.data().values.first)};});
    bookingDates.docs.forEach((element) {dateRangeMap[element.id] = {DateTime.parse(element.data().keys.first): DateTime.parse(element.data().values.first)};});
    //print("dateRangeMap: $dateRangeMap");
    
    return dateRangeMap;
    
  }
  
  Future<bool> isColliding(productID, DateTime newMinDate,DateTime  newMaxDate)async{
    Map<String, Map<DateTime, DateTime>>?  dateRangeMap = await getBookingDate(productID);
    if(dateRangeMap == null){return false;}
    for(String timeStamp in dateRangeMap.keys) {  
    DateTime minDate = 
    // dateRangeMap.values.first.keys.first;
    dateRangeMap[timeStamp]!.keys.first;    
    DateTime maxDate = 
    // dateRangeMap.values.first.values.first;
    dateRangeMap[timeStamp]!.values.last;    
    // print("newMinDate: ${newMinDate}, newMaxDate ${newMaxDate}");
    // print("newMinDate: ${newMinDate.day}, newMaxDate ${newMaxDate.day}");


    if(newMinDate == minDate || newMaxDate == maxDate                ){  return true;}
    if(newMinDate == maxDate || newMaxDate == minDate                ){  return true;}
    // print("${newMaxDate.isAfter(minDate)} , ${newMinDate.isBefore(minDate)}");
    if(newMinDate.isBefore(minDate) && newMaxDate.isAfter(minDate)   ){  return true;}
    // print("${newMinDate.isBefore(maxDate)} , ${ newMaxDate.isAfter(maxDate)  }");
    if(newMinDate.isBefore(maxDate) && newMaxDate.isAfter(maxDate)   ){  return true;}    
    // print("${newMinDate.isAfter(minDate)} , ${ newMaxDate.isBefore(maxDate)  }");
    if(newMinDate.isAfter(minDate) && newMaxDate.isBefore(maxDate)   ){  return true;}
    // print("${newMinDate.isBefore(minDate)} , ${ newMaxDate.isAfter(maxDate)  }");
    if(newMinDate.isBefore(minDate) && newMaxDate.isAfter(maxDate)   ){  return true;}

    
    }
    return false;
  }
}


class DateUnavailableDialog extends StatelessWidget {
  const DateUnavailableDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
    onWillPop: () async => false,
    child: Dialog( child: AspectRatio(aspectRatio: 4, child: Container(decoration: const BoxDecoration(color: Color.fromARGB(255,120,171,120), borderRadius: BorderRadius.all(Radius.circular(15))), child: const Center(child: Text("Already booked for this date", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 255, 255, 255)),)),),),));
  }
}