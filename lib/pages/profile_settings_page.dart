import 'package:flutter/material.dart';
import 'package:agrilease/pages/my_adds.dart';
import 'package:agrilease/login_api.dart';


class ProfileSettings extends StatelessWidget {
  const ProfileSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(child: TempWidget()));
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