import 'package:agrilease/login_api.dart';
import 'package:agrilease/pages/profile.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return     WillPopScope(
      onWillPop: () {return Future.delayed(Duration.zero, (){  if(FireBaseAuthentication.isSignedIn){return true;}else{return false;} });},
      child: Scaffold(
        body: Container( padding: const EdgeInsets.all(20), decoration: const BoxDecoration( image: DecorationImage( fit: BoxFit.cover,  image: AssetImage("assets/loginScreen01.jpg")) ), 
          child: ListView(children: [AspectRatio(aspectRatio: 1, child: Container(  decoration: const BoxDecoration(image: DecorationImage( image: AssetImage("assets/LoginLogo.png"))),)),
                  
          //const AspectRatio(aspectRatio: 2, child: Text(style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 1 ), "Unlock Possibilities, Share Tools: \nWelcome to Agrilease - Where Equipment Finds Its Next Adventure")).animate(effects: [const ShimmerEffect(duration: Duration(seconds: 2))]),
                  
          const Text( style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26, letterSpacing: 1.3 ), textAlign: TextAlign.center, maxLines: 1, "Agrilease", ),
                  
          AspectRatio(aspectRatio: 3, child: Center(child: FilledButton(  onPressed: ()async{await FireBaseAuthentication().signInWithGooggle().then( (value){if(FireBaseAuthentication.isSignedIn){Navigator.of(context).pop(); ProfileInfo.setProfileInfo();} ProfileInfo.setProfileInfo();  }  );  },  style: ButtonStyle(shape: MaterialStateProperty.all(const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))),   backgroundColor: MaterialStateProperty.all(Colors.transparent,) ),child: const Image(height: 40, image: AssetImage("assets/android_neutral_sq_SI@4x.png")) ) )), //const Text("Sign in with Google"),
            ],
          ),
        ),
      ),
    );
  }
}


