import 'package:flutter/material.dart';
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
          child: const Row(children: [Expanded(flex:1, child: Spacer()), Expanded(flex:9, child: Text('search' ), ), Expanded(flex:1, child: Icon(Ionicons.search_outline), ) ]
         
        ),)
      ),
      body: const Center(
        child: Text('Welcome to the App',),),
      bottomNavigationBar: navigationBar(),
      
      //floatingActionButton: FloatingActionButton(onPressed: _incrementCounter, tooltip: 'Increment', child: const Icon(Icons.add),), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  BottomNavigationBar navigationBar() {
    return BottomNavigationBar( type: BottomNavigationBarType.fixed , showUnselectedLabels:false,
    onTap: (value) => _navigationBarIndex(value),
    currentIndex: _currentIndex,
      items:  const [
      BottomNavigationBarItem(icon: Icon(Ionicons.home_outline), label: 'Home'),
      BottomNavigationBarItem(icon: Icon(Ionicons.chatbox), label: 'Chat'),
      BottomNavigationBarItem(icon: Icon(Ionicons.heart_circle_outline), label: 'ads'),
      BottomNavigationBarItem(icon: Icon(Ionicons.person_circle_outline), label: 'profile'),
      ]);
  }
}
