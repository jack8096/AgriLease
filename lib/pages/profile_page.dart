

import 'package:agrilease/login_api.dart';
import 'package:agrilease/pages/admin_page.dart';
import 'package:agrilease/pages/login_page.dart';
import 'package:agrilease/pages/profile.dart';
import 'package:agrilease/pages/profile_settings_page.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
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
    return Scaffold(
      appBar: AppBar(),
      body: ListView( children: [ Center( child: ProfilePhoto(profilePhotoUrl: profilePhotoUrl)),
      const AspectRatio(aspectRatio: 3, child: SizedBox(),),
      ListView(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), children:  [
        dividerCommonCardProfile(),
        CommonCardProfile(icon: Ionicons.person_circle_outline, title: "Profile", onTap: (){  Navigator.of(context).push( MaterialPageRoute(builder: (context){return const Profile();}) );  }),

        dividerCommonCardProfile(),
        CommonCardProfile(icon: Ionicons.heart_outline, title: "Favorites", onTap: (){        Navigator.of(context).push(MaterialPageRoute(builder: (context){return const FavoratesPage();} )  ); } ),

        dividerCommonCardProfile(),
        CommonCardProfile(icon: Icons.computer_outlined, title: "Admin", onTap: ()async{
          await isAdminUser().then((isAdmin){
          if(isAdmin){  Navigator.of(context).push(MaterialPageRoute(builder: (context){return const AdminPage();   }));  }else{
          showDialog(context: context, builder: (context){return AlertDialog(backgroundColor: Colors.white, surfaceTintColor: Colors.transparent, title: Text(AppLocalizations.of(context)!.tagNotLoggedInMSG),);   });}              
          });
        }),

        dividerCommonCardProfile(),
        CommonCardProfile(icon: Ionicons.log_out_outline, title: "Log Out", onTap: (){
          FireBaseAuthentication().userSignOut().then((value)async{await Navigator.of(context).push(MaterialPageRoute(builder: (context){return const LoginPage();}));});
        }),

        dividerCommonCardProfile(),
        ],)
      //ListView.separated(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: 4, separatorBuilder:(context, separatorNo){return const Divider(color: Colors.black, thickness: 1,);} , itemBuilder: (context, itemNo){return Text(itemNo.toString());},
      
        
      ]),
    );
  }

  Divider dividerCommonCardProfile() => Divider(color: colorDivider, thickness: thicknessDivider);
}


class CommonCardProfile extends StatelessWidget {final IconData icon; final String title; final void Function()? onTap;
   const CommonCardProfile({super.key, required this.icon, required this.title, required this.onTap});


  @override
  
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap,  child: AspectRatio(aspectRatio: 6,
        child: Row(children: [
          AspectRatio(aspectRatio: 1, child: Icon(icon, size: 40,),), Text(title, style: const TextStyle(fontSize: 20),)
        ],),
      ),
    );
  }
}