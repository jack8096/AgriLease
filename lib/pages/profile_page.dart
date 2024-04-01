

import 'package:agrilease/login_api.dart';
import 'package:agrilease/pages/admin_page.dart';
import 'package:agrilease/pages/login_page.dart';
import 'package:agrilease/pages/profile.dart';
import 'package:agrilease/pages/profile_settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'favorates_page.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
String? profilePhotoUrl;
initFunction()async{
  ProfileInfo.setProfileInfo();
profilePhotoUrl = ProfileInfo.profilePhotoUrl;
print("profilePhotoUrl: $profilePhotoUrl");

}



@override
  void initState() {
    initFunction();
    super.initState();
  }

Color colorDivider = Colors.black;
double thicknessDivider = 1;
  @override
  Widget build(BuildContext context) {

    bool switchValue =false;
    String currentLanguage = Localizations.localeOf(context).toString();
    if(currentLanguage=="en"){  switchValue = false;}else{switchValue=true; }


    print("currentLanguage: $currentLanguage");
    changeSwitchValue(bool value) {
      LanguageModel.changeLanguage(context);
      return  setState((){ switchValue = !value;  });   }    


    return Scaffold(
      appBar: AppBar( surfaceTintColor: Colors.transparent, backgroundColor: const Color.fromARGB(255,248,248,248), foregroundColor: Colors.transparent,  ),
      body: ListView(
        children: [
          Container(color: const Color.fromARGB(255,248,248,248),
            child: Column( children: [ Center( child: ProfilePhoto(profilePhotoUrl: profilePhotoUrl)), Padding(padding: const EdgeInsets.all(8), child: Text(ProfileInfo.name, style: const TextStyle(fontSize: 22,),)),
            const AspectRatio(aspectRatio: 5, child: SizedBox(),),
            ListView(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), children:  [
              //dividerCommonCardProfile(),
              CommonCardProfile(icon: "assets/profilePageIcons/farmer.png", title: AppLocalizations.of(context)!.tagProfile, onTap: (){  Navigator.of(context).push( MaterialPageRoute(builder: (context){return const Profile();}) );  }),
          
              //dividerCommonCardProfile(),
              CommonCardProfile(icon: "assets/profilePageIcons/heart.png", title: AppLocalizations.of(context)!.tagFavorites, onTap: (){        Navigator.of(context).push(MaterialPageRoute(builder: (context){return const FavoratesPage();} )  ); } ),
          
              //dividerCommonCardProfile(),
              CommonCardProfile(icon: "assets/profilePageIcons/admin.png", title: AppLocalizations.of(context)!.tagAdmin, onTap: ()async{
                await isAdminUser().then((isAdmin){
                if(isAdmin){  Navigator.of(context).push(MaterialPageRoute(builder: (context){return const AdminPage();   }));  }else{
                showDialog(context: context, builder: (context){return AlertDialog(backgroundColor: Colors.white, surfaceTintColor: Colors.transparent, title: Text(AppLocalizations.of(context)!.tagNotLoggedInMSG),);   });}              
                });
              }),
              AspectRatio(aspectRatio: 4, child: Card( color: Colors.white, surfaceTintColor: Colors.transparent,
                  child: Row(children: [  Padding(padding: const EdgeInsets.all(15), child: SizedBox(height: 50, width: 50, child: Image.asset("assets/profilePageIcons/languages.png"),)),  Text(AppLocalizations.of(context)!.tagMarathi, style: const TextStyle(fontSize: 20),), const Spacer(), Padding(padding: const EdgeInsets.all(10), child: Switch(value: switchValue, onChanged: (newValue){ changeSwitchValue(switchValue);   }))],),),),
              // dividerCommonCardProfile(),
              CommonCardProfile(icon: "assets/profilePageIcons/logout.png", title: AppLocalizations.of(context)!.tagLogOut, onTap: (){
                FireBaseAuthentication().userSignOut().then((value)async{await Navigator.of(context).push(MaterialPageRoute(builder: (context){return const LoginPage();}));});
              }),
          
              // dividerCommonCardProfile(),
              ],)
            //ListView.separated(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: 4, separatorBuilder:(context, separatorNo){return const Divider(color: Colors.black, thickness: 1,);} , itemBuilder: (context, itemNo){return Text(itemNo.toString());},
            
              
            ]),
          ),
        ],
      ),
    );
  }

  Divider dividerCommonCardProfile() => Divider(color: colorDivider, thickness: thicknessDivider);
}


class CommonCardProfile extends StatelessWidget {final dynamic icon; final String title; final void Function()? onTap;
   const CommonCardProfile({super.key, required this.icon, required this.title, required this.onTap});


  @override
  
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap,  child: AspectRatio(aspectRatio: 4,
        child: Card(  color: const Color.fromARGB(255,254,255,253), surfaceTintColor: Colors.transparent,
          child: Row( 
            children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: SizedBox(height: 50, width: 50,child: Image.asset(icon,)),),
            //  Padding(padding: const EdgeInsets.all(10), child: )
            Text(title, style: const TextStyle(fontSize: 20, color: Color.fromARGB(255,51,62,42)),)
          ],),
        ),
      ),
    );
  }
}

