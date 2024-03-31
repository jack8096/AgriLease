import 'package:agrilease/main.dart';
import 'package:agrilease/pages/admin_page.dart';
import 'package:agrilease/pages/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:agrilease/pages/my_adds.dart';
import 'package:agrilease/login_api.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';



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
  contact = profileData?["contact"]??"Save your Contact";
  contact = "+91 $contact";
  address = profileData?["address"]??"Save your address";
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

bool switchValue =false;
String currentLanguage = Localizations.localeOf(context).toString();
if(currentLanguage=="en"){switchValue = false;}else{switchValue=true;}


print("currentLanguage: $currentLanguage");
changeSwitchValue(bool value) {
LanguageModel.changeLanguage(context);
return  setState((){ switchValue = !value;  });
}


    
    return Scaffold(
      appBar: AppBar( backgroundColor: Colors.white,),
      body: //const Center(child: TempWidget())
      Container( padding: const EdgeInsets.all(20), color: Colors.white,
        child: ListView(children: [
          Padding(padding: const EdgeInsets.all(8), child: Text(AppLocalizations.of(context)!.tagProfile, style: const TextStyle(color: Colors.black54, fontSize: 16, ),)),
          Badge(largeSize: 40, alignment: Alignment.topRight, backgroundColor: Colors.transparent, label: IconButton(onPressed: () => contactTextField(), icon: const Icon(Ionicons.pencil, size: 20,),), child: AspectRatio(aspectRatio: 3, child: Card(surfaceTintColor: Colors.transparent, color: Colors.white, child: Column( mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,  children: [  Text("${AppLocalizations.of(context)!.tagContact}\n", style: const TextStyle(fontWeight: FontWeight.bold),),Text(contact)  ])))), //IconButton(onPressed: () => contactTextField(), icon: const Icon(Ionicons.pencil)) Text("Contact"), 
          Badge(largeSize: 40, alignment: Alignment.topRight, backgroundColor: Colors.transparent, label: IconButton(onPressed: () => addressTextField(), icon: const Icon(Ionicons.pencil, size: 20,),), child: AspectRatio(aspectRatio: 2, child: Card(surfaceTintColor: Colors.transparent, color: Colors.white, child: Padding(padding: const EdgeInsets.all(8), child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [ Text("${AppLocalizations.of(context)!.tagAddress}\n", style: const TextStyle(fontWeight: FontWeight.bold),), Text(address) ],)),   ))), //Card(child: Center(child: Text("Save your address")))
          Padding(padding: const EdgeInsets.all(8), child: Text(AppLocalizations.of(context)!.tagLoginProfile, style: const TextStyle(color: Colors.black54, fontSize: 16, ),)),
          AspectRatio(aspectRatio: 8, child: FilledButton(onPressed: (){FireBaseAuthentication().userSignOut().then((value)async{await Navigator.of(context).push(MaterialPageRoute(builder: (context){return const LoginPage();})).then((value){ someFunction();  });});   }, style: ButtonStyle(shape: MaterialStateProperty.all(const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4)))), backgroundColor: MaterialStateProperty.all(Colors.black)), child: Text(AppLocalizations.of(context)!.tagLogOut, style: const TextStyle(fontSize: 16),)),),
          
          // Padding(padding: const EdgeInsets.all(8), child: Text(AppLocalizations.of(context)!.tagLanguage, style: const TextStyle(color: Colors.black54, fontSize: 16, ),)),

          // AspectRatio(aspectRatio: 4, child: Card( color: Colors.white, surfaceTintColor: Colors.transparent,
          //   child: Row(children: [Padding(padding: const EdgeInsets.all(10), child: Text(AppLocalizations.of(context)!.tagMarathi)), const Spacer(), Padding(padding: const EdgeInsets.all(10), child: Switch(value: switchValue, onChanged: (newValue){ changeSwitchValue(switchValue);   }))],),),),

          // Padding(padding: const EdgeInsets.all(8), child: Text(AppLocalizations.of(context)!.tagadministrative, style: const TextStyle(color: Colors.black54, fontSize: 16, ),)),
          // AspectRatio(aspectRatio: 8, child: FilledButton(onPressed: ()async{  
          //   await isAdminUser().then((isAdmin){
          //   if(isAdmin){  Navigator.of(context).push(MaterialPageRoute(builder: (context){return const AdminPage();   }));  }else{
          //     showDialog(context: context, builder: (context){return AlertDialog(backgroundColor: Colors.white, surfaceTintColor: Colors.transparent, title: Text(AppLocalizations.of(context)!.tagNotLoggedInMSG),);   });}              });
          // }, style: ButtonStyle(shape: MaterialStateProperty.all(const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4)))), backgroundColor: MaterialStateProperty.all(Colors.black)), child: Text( AppLocalizations.of(context)!.tagAdminLogin  , style: const TextStyle(fontSize: 16),)),),
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

  await data.get().then((value){if(value.data() !=null){ return  result = value.data() as Map<String, dynamic>; }else{return result = null;} }); //if no emial return null
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
        OutlinedButton(onPressed: (){FireBaseAuthentication().userSignOut();}, child: const Text('Google SignOut')),
        OutlinedButton(onPressed: ()async{ FireBaseAuthentication.main(); await FireBaseAuthentication().signInWithGooggle(); }, child: const Text('sign in')),
        OutlinedButton(onPressed: ()async{ await MyAds.fetchProductDetal();           //await FireStore.fetchProductDetalID();
        }, child: const Text('FireStore')),
      ],
    );
  }
}


class LanguageModel with ChangeNotifier{
static String _language = "en";
static String get language => _language;

static void changeLanguage(BuildContext context){
  if(_language=="en"){_language="mr"; MyApp.setLocal(context, const Locale("mr")); }else{_language="en"; MyApp.setLocal(context, const Locale("en"));}
}

}



Future<bool> isAdminUser()async{
  final FirebaseFirestore fireStoreInstance = FirebaseFirestore.instance;
  final DocumentSnapshot result = await fireStoreInstance.collection("admins_profile").doc("admin_users").get();
  final Map<String, dynamic> admins = result.data() as Map<String, dynamic>;
  final String email = FireBaseAuthentication.emailID;
  
  if(admins[email]==true){print("$email isAdmin true}"); return true;
    }else{print("$email isAdmin false}");   return false;}
  

}