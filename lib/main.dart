//import 'package:agrilease/login_api.dart';


import 'package:agrilease/l10n/l10.dart';
import 'package:agrilease/pages/chats.dart';
import 'package:agrilease/pages/my_adds.dart';
import 'package:agrilease/pages/product_card_full_detail_page.dart';
import 'package:agrilease/pages/profile.dart';
import 'package:agrilease/pages/recent_section.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
//import 'package:flutter/foundation.dart';
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
 static bool isloading =true;
 static set setLoading(bool value){isloading = value;}
Future<void> firebaseIntiation()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  await recentAds.fetchData();
  await FirebaseAuth;
  print(Firebase.apps);
  Future.delayed(const Duration(seconds: 1),(){
  print("Firebase.apps.isNotEmpty: ${Firebase.apps.isNotEmpty} & recentAds.list.isNotEmpty: ${recentAds.list.isNotEmpty}");
  if(Firebase.apps.isNotEmpty & recentAds.list.isNotEmpty ){ isloadingSetState(false);  } //Firebase.apps.isNotEmpty is a list of services initated if empty connect to firebase is failed
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
// ignore: prefer_const_constructors
final List<Widget> pages = [HomePage(), const ChatsPage(), const MyAdsPage(), const Profile() ]; 
    return Scaffold(

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
      BottomNavigationBarItem(icon: const Icon(Ionicons.chatbox_outline), label: AppLocalizations.of(context)!.tagChat),
      BottomNavigationBarItem(icon: const Icon(Ionicons.heart_outline), label: AppLocalizations.of(context)!.tagMyAds),
      BottomNavigationBarItem(icon: const Icon(Ionicons.person_outline), label: AppLocalizations.of(context)!.tagProfile),
      ]);
  }
}




class CategorySection extends StatefulWidget { final bool showAll;
  const CategorySection({super.key, required this.showAll});

  @override
  State<CategorySection> createState() => _CategorySection();
}

class _CategorySection extends State<CategorySection> {
  
List<String> category = ['Battery sprayer', 'Boom sprayer', 'Brushcutter', 'Cultivator', 'Engine sprayer', 'Harrow', 'HTP sprayer', 'Intercultivator', 'MB plough', 'Mini rotator', 'Power tiller', 'Reaper', 'Reversible plough', 'Ridger', 'Rotator', 'Super seeder', 'Thresher', 'Water pump'];

  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.all(6), color: Colors.white,
    child: GridView.count( shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 4, crossAxisSpacing:5, mainAxisSpacing: 5,  children: List.generate(widget.showAll?category.length: 4, (index) => CategoryTile(title: category[index])) ));
  }
}

class CategoryTile extends StatelessWidget {final String title;
  const CategoryTile({super.key, required this.title});
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector( onTap: (){print("onTap on $title"); Navigator.push(context, MaterialPageRoute(builder: (context){return CategorySearchPage(title: title,);}));},
      child: Card( surfaceTintColor: Colors.transparent, color: Colors.white, child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, 
        children: [
          AspectRatio(aspectRatio: 6, child: Text(title, style: const TextStyle(color: Colors.transparent),)),
          AspectRatio(aspectRatio: 1.6, child: Image.asset("assets/categoryImage/$title.jpg")),
          //AspectRatio(aspectRatio: 1.6, child: Row(children: [const Spacer(),  const Spacer(), ],)),
          
          AspectRatio(aspectRatio: 6, child: Text(title, textAlign: TextAlign.center,)),
        ],
      ),),
    );
  }
}

class CategorySectionSearch{
static Future<List?> search(String search)async{ 
Map? searchQuery;
final ref = FirebaseFirestore.instance.collection("category").doc(search);
await ref.get().then((value) { searchQuery =  value.data();   });
print("searchQuery: $searchQuery");
if(searchQuery?.isEmpty??true){return null;}
final List result = searchQuery!.keys.toList();
print('search: $result');
return result;

  }
static Future<List<dynamic>?>productDetail(final List<dynamic>? productIDs)async{
  if(productIDs!.isEmpty){return null;}
  print("productIDs: $productIDs");
  List productDetails =[];
  final firebaseApp = Firebase.app();
  for (var productID in productIDs){  print("productID: $productID, productIDs: $productIDs");
  final productRef = FirebaseDatabase.instanceFor(app: firebaseApp, databaseURL: 'https://agrilease-ecd0b-default-rtdb.asia-southeast1.firebasedatabase.app/').ref().child(productID);
  productDetails.add(await productRef.get().then((snapshot){ return snapshot.value; }));
  }
  print("productDetails: $productDetails");
  return productDetails;
}

static Future<Map<String, String?>?> loadImagesSRCs(List<dynamic> imageNames)async{
  Map<String, String?> imagesSrcs= {};
  if(imageNames.isEmpty){return null;}
  for (String imageName in imageNames){
    //print(imageName);
    String? src = await FirebaseStorage.instance.ref().child(imageName).getDownloadURL().then((value) => value);//String src = await ref.get()
    imagesSrcs[imageName] = src;
  }
  //print("imagesSrcs: $imagesSrcs");
  return imagesSrcs;
}


}

class CategorySearchPage extends StatefulWidget { final String title;
  const CategorySearchPage({super.key, required this.title});

  @override
  State<CategorySearchPage> createState() => _CategorySearchPageState();  
}

class _CategorySearchPageState extends State<CategorySearchPage> {
  bool isloading = true;
  List<dynamic>? searchQuery;
  List<dynamic>? productDetails;
  List<dynamic> imageNames = [];
  Map<String, String?>? imageNamesSrcs;
  void initFunction()async{
    searchQuery = await CategorySectionSearch.search(widget.title);
    print("searchQuery: $searchQuery");
    if(searchQuery?.isNotEmpty??false){productDetails = await CategorySectionSearch.productDetail(searchQuery);  print('productDetails: $productDetails'); }
    productDetails?.forEach((element) { print("element['image']: ${element['image']}"); imageNames.add(element?['image']); });
    print("imageNames: $imageNames");
    imageNamesSrcs = await CategorySectionSearch.loadImagesSRCs(imageNames);
    await Future.delayed(const Duration(seconds: 2));
    setState((){isloading =false;});
  }

  @override
  void initState(){
    initFunction();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(),
      body:isloading? //Container(padding: const EdgeInsets.all(15), child: ListView( children: List.generate(, (index) => null), ))
       const Center(child: SizedBox(height: 100, width: 100, child: CircularProgressIndicator( color: Colors.black,)))
       : searchQuery?.isEmpty??true? Center(child: AspectRatio( aspectRatio: 1,
         child: Container( padding: const EdgeInsets.all(20), margin: const EdgeInsets.all(20),
          decoration: BoxDecoration( border: Border.all( width: 3, color: const Color.fromARGB(255,163, 197, 175),),  borderRadius: const BorderRadius.all(Radius.circular(8)) ) ,
          child: Column( mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AspectRatio(aspectRatio: 1.5, child: Image.asset("assets/categorySearchPagePNG.png")),
              const AspectRatio(aspectRatio: 3, child: Center(child: Text(  textAlign: TextAlign.center, style:TextStyle(color: Color.fromARGB(255,55, 74, 62), fontWeight: FontWeight.bold, fontSize: 24 ), "This category is empty, \nbe first to add this category"))),
            ],
          )),
       ),)
       
       : ListView(children: List.generate(productDetails?.length??0, (index) {print("productDetails[index]: ${productDetails?[index]}"); return CategoryProductCard(productDetail: productDetails?[index], imageNameSrcs:imageNamesSrcs); }),)
    );
  }
}

class CategoryProductCard extends StatelessWidget {final dynamic productDetail; final Map<String, String?>? imageNameSrcs;
  const CategoryProductCard({
    super.key,
    required this.productDetail,
    required this.imageNameSrcs,
  });

  

  @override
  Widget build(BuildContext context) {
    String imageSRC = imageNameSrcs?[productDetail["image"]]??"https://firebasestorage.googleapis.com/v0/b/agrilease-ecd0b.appspot.com/o/None.jpeg?alt=media&token=ca13e835-b713-4991-8233-3d1098eec860";

    String price = productDetail["price"] is Map?productDetail["price"]["price"]:productDetail["price"];

    print("productDetail: $productDetail");
    return GestureDetector( onTap:()async=> await  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>FullProductDetail(image: imageSRC, price: price, title: productDetail["title"], description: productDetail["description"], email: productDetail["email"], location: productDetail["location"], contact: productDetail["contact"]))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [AspectRatio(aspectRatio: 2.5, child: Card(child: Row( mainAxisAlignment: MainAxisAlignment.spaceEvenly,
         children: [ AspectRatio(aspectRatio: 1, child: Image.network(imageSRC)),  
         AspectRatio(aspectRatio: 1.5, child: Padding( padding: const EdgeInsets.all(20),
           child: Column( mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start,
             children: [ Text(productDetail["title"]),Text(price),Text(productDetail["description"]), Text(productDetail['contact'])]
           ),
         ))]))), //OutlinedButton(onPressed: ()async{ await CategorySectionSearch.productDetail(title);}, child: const Text("Test"))
         ],),
      ),
    );
  }
}

// ignore: must_be_immutable
class HomePage extends StatefulWidget   { // bool isloading;
   const HomePage({
    super.key,  //required this.isloading,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showAll = false;
  @override
  Widget build(BuildContext context) { 
    return Scaffold(
    appBar: AppBar(actions: [IconButton(onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (context){return const SearchPage();}));}, icon: const Padding(padding: EdgeInsets.only(right: 10), child: Icon(Ionicons.search_outline))  )], surfaceTintColor: Colors.white, backgroundColor: Colors.green[300], title: Text(AppLocalizations.of(context)!.tagHome, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors. black54),),),
    body: RefreshIndicator(color: Colors.black, onRefresh: ()async{print('refresh indicator'); setState(() { _MyHomePageState.setLoading = true;}); await recentAds.fetchData(); setState(() { _MyHomePageState.setLoading = false;}); },
      child:ListView( //crossAxisAlignment: CrossAxisAlignment.stretch, 
      children: [
        Container(color: Colors.white,  padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),  child: Row(children: [ Text('Category', style: TextStyle(color: Colors.grey[850], fontSize: 20, fontWeight: FontWeight.w500),), const Spacer(), TextButton(onPressed: (){print("button pressed"); setState((){showAll  = true;});}, style: const ButtonStyle(surfaceTintColor:MaterialStatePropertyAll(Colors.amber),  textStyle: MaterialStatePropertyAll(TextStyle(fontSize: 16)), foregroundColor: MaterialStatePropertyAll(Colors.black)), child: const Text("All")) ],)),
        CategorySection(showAll: showAll),
        
        Container(color: Colors.white,  padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),  child: Text('Recent', style: TextStyle(color: Colors.grey[850], fontSize: 20, fontWeight: FontWeight.w500),),),
        //const CategorySection(),
        _MyHomePageState.isloading?
        ListView(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), children: const [LoadingshimmeringEffect()])
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
      child: GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 2, mainAxisSpacing: 5, crossAxisSpacing: 5, childAspectRatio: 0.7,
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

