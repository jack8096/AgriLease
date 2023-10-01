import 'package:agrilease/pages/recent_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ionicons/ionicons.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';




void main()async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
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
  print(Firebase.apps);
  Future.delayed(const Duration(seconds: 1),(){
  if(Firebase.apps.isNotEmpty & FetchData.list.isNotEmpty ){   setState(() {    isloading = false;     });   } //Firebase.apps.isNotEmpty is a list of services initated if empty connect to firebase is failed
});
} 



@override
void initState() {
  isloading = true;


firebaseIntiation(); 
    super.initState(); }



int _currentIndex = 0;
void _navigationBarIndex(int index){

  setState(() {
    _currentIndex = index;
  });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Container( padding: const EdgeInsets.all(5), decoration: const BoxDecoration(color: Colors.white, borderRadius:BorderRadius.all(Radius.circular(18))),
          child: const Row(children: [ Text('search' ), Spacer(),  Icon(Ionicons.search_outline), ]
         
        ),)
      ),
      body:
      
      Column( crossAxisAlignment: CrossAxisAlignment.start,
      children: [Container(padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),  child: const Text('Recent', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),),
        isloading?
        const Expanded(child: LoadingshimmeringEffect())
        :const RecentSection(),



      ],), 
      bottomNavigationBar: navigationBar(),
    );
  }

  BottomNavigationBar navigationBar() {
    return BottomNavigationBar( type: BottomNavigationBarType.fixed , showUnselectedLabels:false,
    onTap: (value) => {_navigationBarIndex(value), },
    currentIndex: _currentIndex,
      items:  const [
      BottomNavigationBarItem(icon: Icon(Ionicons.home_outline), label: 'Home'),
      BottomNavigationBarItem(icon: Icon(Ionicons.chatbox_outline), label: 'Chat'),
      BottomNavigationBarItem(icon: Icon(Ionicons.heart_outline), label: 'My Ads'),
      BottomNavigationBarItem(icon: Icon(Ionicons.person_outline), label: 'Profile'),
      ]);
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
    child: Expanded( child: Padding( padding: const EdgeInsets.all(5),
      child: GridView.count(crossAxisCount: 2, mainAxisSpacing: 5, crossAxisSpacing: 5, childAspectRatio: 0.7,
        children: [DemoProductCards(),DemoProductCards(),DemoProductCards(),DemoProductCards(),],
        ),
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

