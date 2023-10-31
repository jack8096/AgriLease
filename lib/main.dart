//import 'package:agrilease/login_api.dart';

import 'package:agrilease/l10n/l10.dart';
import 'package:agrilease/pages/chats.dart';
import 'package:agrilease/pages/my_adds.dart';
import 'package:agrilease/pages/profile.dart';
import 'package:agrilease/pages/recent_section.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ionicons/ionicons.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:agrilease/pages/login_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'pages/search_page.dart';



void main()async {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
static void setLocal(BuildContext context, Locale newLocale){
_MyAppState? state = context.findAncestorStateOfType();
state?.setLocale(newLocale);

}

}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  setLocale(Locale locale){
setState(() {
  _locale = locale;
});
  }
  @override
  Widget build(BuildContext context) {

    return MaterialApp( 
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,),
        
        supportedLocales: L10.all,
        locale: _locale,
        localizationsDelegates: const[
           AppLocalizations.delegate,
           GlobalMaterialLocalizations.delegate,
           GlobalWidgetsLocalizations.delegate,
           GlobalCupertinoLocalizations.delegate
         ],
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  //final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
late bool isloading;
Future<void> firebaseIntiation()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  await FetchData.fetchData();
  await FirebaseAuth;
  print(Firebase.apps);
  Future.delayed(const Duration(seconds: 1),(){
  if(Firebase.apps.isNotEmpty & FetchData.list.isNotEmpty ){ isloadingSetState(false);  } //Firebase.apps.isNotEmpty is a list of services initated if empty connect to firebase is failed
});
} 

void isloadingSetState( bool condition ){ setState(() {    isloading = condition;     });  }


@override
void initState() {
WidgetsBinding.instance.addPostFrameCallback((_){


Navigator.of(context).push(MaterialPageRoute(builder: (context){return const LoginPage();}));
});  
isloading = true;
firebaseIntiation();
super.initState();
}



int _currentIndex = 0;
void _navigationBarIndex(int index){  setState(() { _currentIndex = index; });}



  @override
  Widget build(BuildContext context) {
final List<Widget> pages = [RecentPage( isloadingSetState:isloadingSetState, isloading: isloading,  ), const ChatsPage(), const MyAdsPage(), const Profile() ]; 
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: //Theme.of(context).colorScheme.inversePrimary,
      //   title: Container( padding: const EdgeInsets.all(5), decoration: const BoxDecoration(color: Colors.white, borderRadius:BorderRadius.all(Radius.circular(18))),
      //     child: Row(children: [ Padding(padding: const EdgeInsets.only(left: 15), child: Text('search', style: TextStyle(color: Colors.grey[800]),)), const Spacer(),  const Icon(color:Colors.black54, Ionicons.search_outline), ]
         
      //   ),)
      // ),
      body: pages[_currentIndex],
      
      
      bottomNavigationBar: navigationBar(),
    );
  }

  BottomNavigationBar navigationBar() {
    return BottomNavigationBar( backgroundColor: Colors.white, selectedItemColor: Colors.black,
      type: BottomNavigationBarType.fixed , showUnselectedLabels:false,
    onTap: (value) => {_navigationBarIndex(value), },
    currentIndex: _currentIndex,
      items:  [
      BottomNavigationBarItem(icon: const Icon(Ionicons.home_outline), label: AppLocalizations.of(context)!.tagHome),
      BottomNavigationBarItem(icon: Icon(Ionicons.chatbox_outline), label: AppLocalizations.of(context)!.tagChat),
      BottomNavigationBarItem(icon: Icon(Ionicons.heart_outline), label: AppLocalizations.of(context)!.tagMyAds),
      BottomNavigationBarItem(icon: Icon(Ionicons.person_outline), label: AppLocalizations.of(context)!.tagProfile),
      ]);
  }
}
// ignore: must_be_immutable
class RecentPage extends StatefulWidget   { Function isloadingSetState; bool isloading;
  RecentPage({
    super.key, required this.isloadingSetState, required this.isloading,
  });

  @override
  State<RecentPage> createState() => _RecentPageState();
}

class _RecentPageState extends State<RecentPage> {
  @override
  Widget build(BuildContext context) { 
    return Scaffold(
    appBar: AppBar(actions: [IconButton(onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (context){return const SearchPage();}));}, icon: const Padding(padding: EdgeInsets.only(right: 10), child: Icon(Ionicons.search_outline))  )], surfaceTintColor: Colors.white, backgroundColor: Colors.green[300], title: Text(AppLocalizations.of(context)!.tagHome, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors. black87),),),
    body: RefreshIndicator(color: Colors.black, onRefresh: ()async{print('refresh indicator'); setState(() { widget.isloading = true;}); await FetchData.fetchData(); setState(() { widget.isloading = false;}); },
      child:Column( crossAxisAlignment: CrossAxisAlignment.stretch, 
      children: [Container(color: Colors.white,  padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),  child: Text('Recent', style: TextStyle(color: Colors.grey[850], fontSize: 20, fontWeight: FontWeight.w500),),),
        widget.isloading?
        const Expanded(child: LoadingshimmeringEffect())
        :const RecentSection(),
      ],),),
  );

  }
}

class LoadingshimmeringEffect extends StatelessWidget {
  const LoadingshimmeringEffect({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return 
     Animate(onComplete: (controller) => controller.repeat(),  effects:const  [ShimmerEffect(color: Colors.white38, duration: Duration(seconds: 2)), ],
    child: Container( padding: const EdgeInsets.all(5),
      child: GridView.count(crossAxisCount: 2, mainAxisSpacing: 5, crossAxisSpacing: 5, childAspectRatio: 0.7,
        children: [DemoProductCards(),DemoProductCards(),DemoProductCards(),DemoProductCards(),],
        ),
    ));
  }
}

class DemoProductCards extends StatelessWidget {
   DemoProductCards({super.key,});

final foregroundColor = Colors.grey[400];
final backgroundColor = Colors.grey[200];

  @override
  Widget build(BuildContext context) {
    return Container( height: 200, width: 150, color: backgroundColor,
        child: Column( mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [ 
          Container( height: 100, width: 130, color: foregroundColor, ),  
          Container( height: 10, width: 130, color: foregroundColor, ),  
          Container( height: 10, width: 130, color: foregroundColor, ),  
          Container( height: 10, width: 130, color: foregroundColor, ),  
        ],),
      );
  }
}

