import 'package:firebase_core/firebase_core.dart';


import 'package:firebase_database/firebase_database.dart';



class DatabaseInitiation  {

// Future<FirebaseDatabase> ()async {
// final firebaseApp = Firebase.app();
// final rtdb = FirebaseDatabase.instanceFor(app: firebaseApp, databaseURL: 'https://agrilease-ecd0b-default-rtdb.asia-southeast1.firebasedatabase.app/');
// return rtdb;


//  }

Future<DataSnapshot> recentSectionData() async{
final firebaseApp = Firebase.app(); 
final rtdb = FirebaseDatabase.instanceFor(app: firebaseApp, databaseURL: 'https://agrilease-ecd0b-default-rtdb.asia-southeast1.firebasedatabase.app/'); 
final snapshot = await rtdb.ref('101').get(); // return Future<DataSnapshot> datatype
print(snapshot); 


return snapshot;
}

}

// class RecentSection extends DatabaseInitiation{
  
// }




