import 'package:agrilease/login_api.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:agrilease/pages/profile_settings_page.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class ProfileInfo{

bool isProfileSet = false;

static String name = "____";
static String email = "-----@---.com";
static String address = "-----\n---\n---";
static String contact = "-----------";
static String? profilePhotoUrl;

// static late String name;
// static late String email;
// static late String address;
// static late String contact;
// static late String? profilePhotoUrl;

 static  setProfileInfo()async{
  
  profilePhotoUrl = await FireBaseAuthentication.photoURL;
  name = await FireBaseAuthentication.accountInfo?.displayName??"None";
  email = await FireBaseAuthentication.emailID;
  await SaveSetting().fetchProfieData().then((value){address= value!["address"]??address; contact = value["contact"]??contact;} );
  return "setProfileInfo run $name $email $profilePhotoUrl ";

}}

class _ProfileState extends State<Profile> {

String name = ProfileInfo.name;
String email = ProfileInfo.email;
String address = ProfileInfo.address;
String contact = ProfileInfo.contact;
String? profilePhotoUrl = ProfileInfo.profilePhotoUrl; 


void setProfileInfo(){
setState(() {

name = ProfileInfo.name;
email = ProfileInfo.email;
address = ProfileInfo.address;
contact = ProfileInfo.contact;
profilePhotoUrl = ProfileInfo.profilePhotoUrl;  

});}





// void setProfileInfo(){
  
//   profilePhotoUrl = FireBaseAuthentication.photoURL;
//   name = FireBaseAuthentication.accountInfo?.displayName??"None";
//   email = FireBaseAuthentication.emailID;
//   address = "You haven't saved your address yet";
//   contact = "You haven't saved your contact yet";

//   setState(() {name; email; address;

// });}

void changeState(){setState(() { name; address; email; profilePhotoUrl; }); print("name $name");  } 

void googleSignInDialog()async{ if(FireBaseAuthentication.isSignedIn){return ;}
                             print("googleSignInDialog run"); 
                            await showDialog(context: context, builder: (context){return const AlertGoogleSignInDialog();});
                            setProfileInfo();
                              }
@override
  void initState() {
    super.initState();
    
// if (!FireBaseAuthentication.isSignedIn) {
//       WidgetsBinding.instance.addPostFrameCallback((_)async{await Navigator.of(context).push(MaterialPageRoute(builder: (context){return const LoginPage(); }));
//     await ProfileInfo.setProfileInfo();
//     setProfileInfo();
//     } );
// }
    

    ProfileInfo.setProfileInfo();
    setProfileInfo();
  }    
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar( surfaceTintColor: Colors.white70, elevation: 0, backgroundColor: const Color.fromARGB(0, 255, 255, 255),  actions: [Padding(padding: const EdgeInsets.fromLTRB(20, 0, 20, 0), child: InkWell(onTap: (){ Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ProfileSettings())).then((value)async{ await ProfileInfo.setProfileInfo(); setProfileInfo(); }   ) ; }, child: const Icon(Ionicons.settings_outline),),)],), // Color.fromARGB(255, 40, 42, 88),
      body: Container(decoration: const BoxDecoration(color :Colors.white, image: DecorationImage(fit: BoxFit.cover, image: AssetImage("assets/ProfileBackgroudImage.jpg"))),  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),  child: ListView(
          children: [
            Container(margin: const EdgeInsets.fromLTRB(0, 64, 0, 0), child: ProfileCard(name: name, profilePhotoUrl: profilePhotoUrl,)),
            AddressCard(address: address),
            CommanCard(text: email, label: "Email", icon: Ionicons.mail_outline,),
            CommanCard(text: contact, label: "Contact", icon: Icons.phone),
          ],
        ),),
    );
  }
}

class AlertGoogleSignInDialog extends StatelessWidget {
  const AlertGoogleSignInDialog({ 
    super.key,
  });
  
void someFunction(context)async{ await FireBaseAuthentication.signInWithGooggle();  print('object');
                            if(FireBaseAuthentication.isSignedIn){await ProfileInfo.setProfileInfo(); return Navigator.of(context).pop();}
                             }
  @override
  Widget build(BuildContext context) {
    return     AlertDialog(
    surfaceTintColor: Colors.white, backgroundColor: Colors.white, 
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))), 
    actions: [FilledButton(onPressed: ()async {someFunction(context);  }, style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black )),  child: const Text("Sign-in with Google")),],
    title: const Text("Did you sign in?"),);
  }
}



class CommanCard extends StatelessWidget {
  final String label;
  final String text;
  final IconData icon;

  const CommanCard({
    super.key,
    required this.text,
    required this.label,
    required this.icon
  });



  @override
  Widget build(BuildContext context) {
    return AspectRatio(aspectRatio: 2.5, child: Card(color: Colors.grey[100], surfaceTintColor:Colors.white, child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Icon(icon, color: Colors.black54,), Text(" $label", style: const TextStyle(color: Colors.black54, fontSize: 16, fontWeight: FontWeight.bold), )], ), Text("\n $text", maxLines: 4, overflow:TextOverflow.ellipsis , style: const TextStyle(color: Colors.black87, fontSize: 16, ),) ],),
    ),));
  }
}

class AddressCard extends StatelessWidget {
  const AddressCard({
    super.key,
    required this.address,
  });

  final String address;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(aspectRatio: 1.9, child: Card(color: Colors.grey[100], surfaceTintColor:Colors.white, child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Row(children: [Icon(Ionicons.location_outline), Text("Address", style: TextStyle(color: Colors.black54, fontSize: 16, fontWeight: FontWeight.bold), )], ), Text("\n$address", maxLines: 4, overflow:TextOverflow.ellipsis , style: const TextStyle(color: Colors.black87, fontSize: 16, ),) ],),
    ),));
  }
}

class ProfileCard extends StatelessWidget {final String? profilePhotoUrl;
  const ProfileCard({
    super.key,
    required this.name,
    required this.profilePhotoUrl
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(aspectRatio: 1.7,
      child: Card(color: Colors.grey[100], surfaceTintColor:Colors.white, margin: const EdgeInsets.fromLTRB(4, 50, 4, 4), child: Stack(clipBehavior: Clip.none,
        children: [ Positioned(top: -50, left: 50, right: 50, child: ProfilePhoto(profilePhotoUrl: profilePhotoUrl,),),Center(child: Text(name),)
        ]
      )),
    );
  }
}

class ProfilePhoto extends StatelessWidget {final String? profilePhotoUrl;
  ProfilePhoto({ required this.profilePhotoUrl,
    super.key,
  });

bool isProfilePhotoUrlNULL = false;  
String defaultProfilePhotoUrl = "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftoppng.com%2Fpublic%2Fuploads%2Fpreview%2Finstagram-default-profile-picture-11562973083brycehrmyv.png&f=1&nofb=1&ipt=b908581363375011bb93f35f0062299ee5f34cc57f71eb9ea05c7c8f5068bcdf&ipo=images";
  @override
  Widget build(BuildContext context) {
    if(profilePhotoUrl == null) {isProfilePhotoUrlNULL = true;}
    return Container( height: 100,width: 100, decoration: BoxDecoration( color: Colors.blue[50], shape: BoxShape.circle, border: Border.all(color: const Color.fromARGB(255, 40, 42, 88),) ,
    image: isProfilePhotoUrlNULL? null: DecorationImage(fit: BoxFit.fitHeight,  image: NetworkImage(profilePhotoUrl??defaultProfilePhotoUrl)) 
    ),
      child:isProfilePhotoUrlNULL? const Icon(Ionicons.person, size: 60,): null //Image.network(profilePhotoUrl??"None", fit: BoxFit.cover, width: 60, height: 60,)
    );
  }
}




