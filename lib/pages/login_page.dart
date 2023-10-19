import 'package:agrilease/login_api.dart';
import 'package:agrilease/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return     Scaffold(
      body: Container( padding: const EdgeInsets.all(20), decoration: const BoxDecoration( gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color.fromARGB(255, 240, 240, 240), Color.fromARGB(255, 255, 255, 255),])),
        child: ListView(children: [AspectRatio(aspectRatio: 1, child: Container(  decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/loginScreenPNG.png"))),)),
                
        const AspectRatio(aspectRatio: 2, child: Text(style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 1 ), "Unlock Possibilities, Share Tools: \nWelcome to Agrilease - Where Equipment Finds Its Next Adventure")).animate(effects: [const ShimmerEffect(duration: Duration(seconds: 2))]),
                
        const Text(style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26, letterSpacing: 1.3 ), textAlign: TextAlign.start, maxLines: 1, "Login", ),
                
        AspectRatio(aspectRatio: 3, child: Center(child: FilledButton(onPressed: ()async{await FireBaseAuthentication.signInWithGooggle().then( (value){if(FireBaseAuthentication.isSignedIn){Navigator.of(context).pop(); ProfileInfo.setProfileInfo();} ProfileInfo.setProfileInfo();  }  );  },  style: ButtonStyle(shape: MaterialStateProperty.all(const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))),  backgroundColor: MaterialStateProperty.all(Colors.red[400]) ),child: const Text("Sign in with Google"),) )),
          ],
        ),
      ),
    );
  }
}


