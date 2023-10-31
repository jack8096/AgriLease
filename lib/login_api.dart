

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FireBaseAuthentication {
static bool isSignedIn = false;
static late FirebaseAuth fireBaseAuthInstance;
static late String emailID;
static late GoogleSignInAccount? accountInfo;
static late dynamic photoURL;
final GoogleSignIn googleSignIn = GoogleSignIn();

static void  main()async{
  fireBaseAuthInstance = FirebaseAuth.instance;
  fireBaseAuthInstance.authStateChanges().listen((event) { if(event==null){isSignedIn = false;}else{print("this is event $event"); photoURL = event.photoURL;  isSignedIn=true;} });
  }

signInWithGooggle()async{
  if(!FireBaseAuthentication.isSignedIn){FireBaseAuthentication.main();}
  
  final  GoogleSignInAccount? account = await googleSignIn.signIn();
   final gAuthentication = await account?.authentication;
   final credential = GoogleAuthProvider.credential( idToken: gAuthentication?.idToken, accessToken: gAuthentication?.accessToken );
   await fireBaseAuthInstance.signInWithCredential( credential );
   accountInfo = account;
   emailID = account!.email;
   print("hi this is account info $account");
   print(emailID);
    
//final dynamic data = 

   return true;
   
}

Future<dynamic> userSignOut() async {
  await googleSignIn.disconnect();  await fireBaseAuthInstance.signOut(); return 0;}
}