import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ionicons/ionicons.dart';

void main() {
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
@override
void initState() {
  isloading = true;
  Future.delayed(const Duration(seconds: 3), (){
  setState(() {
    isloading = false;
  });


  } );

    super.initState();
  }



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
          //child: const Row(children: [Expanded(flex:1, child: Spacer()), Expanded(flex:9, child: Text('search' ), ), Expanded(flex:1, child: Icon(Ionicons.search_outline), ) ]
         
        ),)
      ),
      body:
      //ListView.builder(shrinkWrap: true, itemCount: 2, itemBuilder: ((BuildContext context, int index) => const Text('data i'))),
      Column( 
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Container(padding: const EdgeInsets.all(20),  child: const Text('Recent'),), //padding: EdgeInsets.all(20),
        isloading?
        const Expanded(child: LoadingshimmeringEffect())
        :const Text('recent equipment are showed here'),



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
      BottomNavigationBarItem(icon: Icon(Ionicons.chatbox), label: 'Chat'),
      BottomNavigationBarItem(icon: Icon(Ionicons.heart_circle_outline), label: 'ads'),
      BottomNavigationBarItem(icon: Icon(Ionicons.person_circle_outline), label: 'profile'),
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
    child: 
    ListView.separated(shrinkWrap: true, itemCount: 4, itemBuilder: ((BuildContext context, int index) => //const Text('data i')),
    Row( mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [ ProductCards(), ProductCards(),],) ),
    separatorBuilder: (context, index)=>  const SizedBox(height: 10), 
    ));
  }
}

class ProductCards extends StatelessWidget {
   ProductCards({super.key,});

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

class RecentSection extends StatelessWidget {
  const RecentSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Welcome to the App',),);
  }
}
