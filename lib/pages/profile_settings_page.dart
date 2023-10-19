import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:agrilease/pages/my_adds.dart';
import 'package:agrilease/login_api.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';


class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key});

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}



class _ProfileSettingsState extends State<ProfileSettings> {
String contact = "Save your Contact";
String address = "Save your address";


void someFunction() async{
  
  final Map<String, dynamic>? profileData = await SaveSetting().fetchProfieData();
  contact = profileData!["contact"]??"Save your Contact";
  contact = "+91 $contact";
  address = profileData["address"]??"Save your address";
  print("contact: $contact, address: $address");
  setState(() {
    contact;
    address;
  });
return;
}


  @override
  void initState() {
    someFunction();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( backgroundColor: Colors.white,),
      body: //const Center(child: TempWidget())
      Container( padding: const EdgeInsets.all(20), color: Colors.white,
        child: ListView(children: [
          Badge(largeSize: 40, alignment: Alignment.topRight, backgroundColor: Colors.transparent, label: IconButton(onPressed: () => contactTextField(), icon: const Icon(Ionicons.pencil, size: 20,),), child: AspectRatio(aspectRatio: 3, child: Card(surfaceTintColor: Colors.transparent, color: Colors.white, child: Column( mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,  children: [  const Text("Contact\n", style: TextStyle(fontWeight: FontWeight.bold),),Text(contact)  ])))), //IconButton(onPressed: () => contactTextField(), icon: const Icon(Ionicons.pencil)) Text("Contact"), 
          Badge(largeSize: 40, alignment: Alignment.topRight, backgroundColor: Colors.transparent, label: IconButton(onPressed: () => addressTextField(), icon: const Icon(Ionicons.pencil, size: 20,),), child: AspectRatio(aspectRatio: 2, child: Card(surfaceTintColor: Colors.transparent, color: Colors.white, child: Padding(padding: const EdgeInsets.all(8), child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [ const Text("Address\n", style: TextStyle(fontWeight: FontWeight.bold),), Text(address) ],)),   ))), //Card(child: Center(child: Text("Save your address")))
        ],),
      )
      );
  }


void contactTextField(){
  final TextEditingController contactController = TextEditingController();
  showDialog(context: context, builder: (context){return Dialog(surfaceTintColor: Colors.transparent, backgroundColor: Colors.white, child: Padding(padding: const EdgeInsets.only(left: 5, right: 5), 
  child: TextField(controller: contactController, inputFormatters: [FilteringTextInputFormatter.digitsOnly,LengthLimitingTextInputFormatter(10) ], decoration: InputDecoration(border: InputBorder.none,prefixText: "+91 ", prefixStyle: const TextStyle(color: Colors.black),  suffixIcon: IconButton(onPressed: ()async{    print(contactController.text); 
  await SaveSetting().setContact(contactController.text).then( (value){someFunction();  Navigator.of(context).pop(); } ); }, //Navigator.of(context).pop();
   icon: const Icon(Ionicons.arrow_forward_outline))))),    );});
}

void addressTextField(){
  final TextEditingController addressController = TextEditingController();
  showDialog(context: context, builder: (context){return Dialog(surfaceTintColor: Colors.transparent, backgroundColor: Colors.white, child: Padding(padding: const EdgeInsets.only(left: 5, right: 5), 
  child: TextField(maxLines: 6, controller: addressController, decoration: InputDecoration(border: InputBorder.none, suffixIcon: IconButton(onPressed: ()async{   print(addressController.text); 
  await SaveSetting().setAddress(addressController.text).then( (value){someFunction();  Navigator.of(context).pop(); } ); }, //Navigator.of(context).pop();
   icon: const Icon(Ionicons.arrow_forward))))),    );});
}

}





class SaveSetting{
final firestore = FirebaseFirestore.instance;
final email = FireBaseAuthentication.emailID;

Future<Map<String, dynamic>?> fetchProfieData()async{  
  final email = await FireBaseAuthentication.emailID;
  final data = firestore.collection("userData").doc(email);
  late Map<String, dynamic>? result;

  await data.get().then((value){return  result = value.data() as Map<String, dynamic>;}); //if no emial return null
  //print("data: $data, result: ${result??'none'}");
  return result;
}

setContact(String contact) async{
  
  //final result 
  await firestore.collection("userData").doc(email).set({"contact":contact}, SetOptions(merge: true));  //update({"contact":contact});
  //print("result: $result");
  return 0;
}

setAddress(String address) async{
  return
  await firestore.collection("userData").doc(email).set({"address":address}, SetOptions(merge: true));
}
}



class TempWidget extends StatelessWidget {
  const TempWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column( mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
      children: [  
        const Text('Page Under Construction'),
        OutlinedButton(onPressed: (){print('loged in Status: ${FireBaseAuthentication.isSignedIn}');}, child: const Text('Google SignIn status')),
        OutlinedButton(onPressed: (){FireBaseAuthentication.userSignOut();}, child: const Text('Google SignOut')),
        OutlinedButton(onPressed: ()async{ FireBaseAuthentication.main(); await FireBaseAuthentication.signInWithGooggle(); }, child: const Text('sign in')),
        OutlinedButton(onPressed: ()async{ await MyAds.fetchProductDetal();           //await FireStore.fetchProductDetalID();
        }, child: const Text('FireStore')),
      ],
    );
  }
}