//import 'dart:ffi';

import 'package:agrilease/login_api.dart';
import 'package:agrilease/main.dart';
import 'package:agrilease/pages/ad_form.dart';
import 'package:agrilease/pages/product_card_full_detail_page.dart';
import 'package:agrilease/pages/recent_section.dart';
import 'package:agrilease/pages/review_and_rating.dart';
import 'package:agrilease/recent_section_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FireStore {
  static  dynamic emailID = FireBaseAuthentication.emailID;
  static late dynamic document;

   static void write( final String productDetailID ) async{
    
  //emailID??=  FireBaseAuthentication.accountInfo;

  dynamic writeproductDetailID =  FirebaseFirestore.instance.collection('users_published_ad');
  writeproductDetailID.doc(emailID).set({productDetailID:null}, SetOptions(merge: true)); //.set({productDetailID:null});
   print('hi');

  }

  static  fetchProductDetalID()async{ //Future<List<String>>
  if(!FireBaseAuthentication.isSignedIn){ print('Not Signed in to access data(FireStore.fetchProductDetalID())'); return false;}
    print(emailID);
    emailID = FireBaseAuthentication.emailID;
    late dynamic productDetailIDList;
    if(!FireBaseAuthentication.isSignedIn){print('if statement signed in false');
      await FireBaseAuthentication().signInWithGooggle(); }
    await FirebaseFirestore.instance.collection('users_published_ad').doc(emailID).get().then( (DocumentSnapshot doc){ productDetailIDList = doc.data() as Map<String, dynamic>; } );
    productDetailIDList = productDetailIDList.keys.toList();
    print(productDetailIDList);

    return productDetailIDList;
  }

  static delete(id)async{
   try{ 
    print("delete method");
    final adRef =  FirebaseFirestore.instance.collection('users_published_ad').doc(emailID);
    final updates = <String, dynamic>{id:FieldValue.delete()};
    adRef.update(updates);

     }catch(e){print(e);}

  }

  static deleteCategory(categorySection, id)async{
    final docRef = FirebaseFirestore.instance.collection("category").doc(categorySection);
    final updates = <String, dynamic>{id:FieldValue.delete()};
    docRef.update(updates);
  }
  
}


class MyAds {
static late dynamic productDetailIDList;
static final Map ratingList = {};
static final Map noOfReviews = {};

static Future<List<SpecialProductDetail>>  fetchProductDetal()async{//Future<List<ProductDetail>>
    List<SpecialProductDetail> productDetailList = [];
    productDetailIDList = await FireStore.fetchProductDetalID();
    final FirebaseDatabase snapShotData = await DatabaseInitiation().recentSectionData();
    List mapObjectList = [];
    for(String id in productDetailIDList){ 
    DataSnapshot data = await snapShotData.ref(id).get();
    print("data: ${data.value}");
    final detail = data.value as Map<dynamic, dynamic>?;
    //print("Future<List<SpecialProductDetail>>");
    //print(detail);
    mapObjectList.add(data.value);
    var	priceType = detail?["price"].runtimeType;
	 
	 var price = "null";
	 var priceUnit;
	 if(priceType != String){price = detail?["price"]["price"]; priceUnit = detail?["price"]["priceUnit"]; print(detail?["price"]["price"]); }else{price = detail?["price"];}
	 
	 //print("priceInfo: {title: ${detail?['title']}}, image: ${detail?["image"]} price $price, priceRunType: $priceType");

    productDetailList.add( SpecialProductDetail(productID: id, image:  detail?['image'], title: detail?['title'], price: price  , priceUnit: priceUnit,  sellingPrice: detail?['sellingPrice'], description: detail?['description'], email: detail?["email"], location: detail?['location'], contact: detail?["contact"]) );

    //print("mapObjectList: $mapObjectList");
    //mapObjectList.add({"productID":id});
    ratingList[id] = await RatingsAndReviews(productID: id).rating;
    noOfReviews[id] = await RatingsAndReviews(productID: id).noOfReviews;

    
    }
    
    return productDetailList;

}






}




class MyAdsPage extends StatelessWidget {
  const MyAdsPage({super.key});
  
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      
      appBar: AppBar(surfaceTintColor: Colors.white, backgroundColor: Colors.green[300], title: Text(AppLocalizations.of(context)!.tagMyAds , style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),),),
      body: //!FireBaseAuthentication.isSignedIn? Center(child: Column(children: [const Text("You have not signed in yet,sign in to see your previous Ad's"), GestureDetector(onTap: (){}, child: GoogleButton())]),):
      
      const ShowAds(),

      floatingActionButton: FilledButton(  style: ButtonStyle(padding: MaterialStateProperty.all(const EdgeInsets.all(20)), backgroundColor: MaterialStateProperty.all(Colors.green[200]), shape: MaterialStateProperty.all( const CircleBorder())),
      onPressed: ()async{ //if(!FireBaseAuthentication.isSignedIn){await FireBaseAuthentication.signInWithGooggle();}  //await MyAds.fetchProductDetal();
        if(FireBaseAuthentication.isSignedIn){print('signed in'); Navigator.push(context,  MaterialPageRoute(builder: (context) {return const AddAdSecton();}));}
      else{print('signed out'); alertDialog(context);   FireBaseAuthentication().signInWithGooggle(); print('isSignedIn: ${FireBaseAuthentication.isSignedIn}');}  //FireBaseAuth.signInWithGooggle();


        }, 
      child: const Icon(Ionicons.add, color: Colors.black,)
       //const Text('Add', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),),
      )
    );
  }

  Future<dynamic> alertDialog(BuildContext context) {
    return showDialog (  context: context,  builder: (BuildContext context) =>   AlertDialog(
        title: const Text("you aren't signed in yet,\nsign in to publish ad"),
        actions: [GestureDetector( onTap: ()async{print('google button'); try{FireBaseAuthentication().signInWithGooggle(); Navigator.of(context).pop();}catch(e){print(e);}  },child: const GoogleButton())],
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(6.0))),
        
    
             ));
  }
}

class ShowAds extends StatefulWidget {
  const ShowAds({super.key});

  @override
  State<ShowAds> createState() => _ShowAdsState();
}

class _ShowAdsState extends State<ShowAds> {
late dynamic productDetailList;
bool isLoading = true;


Future<void> initFunction()async{  
//  for(dynamic index in productDetailList){ rating[] =  await RatingsAndReviews(productID: productDetailList[index].productID).rating;  }
  
  
    await MyAds.fetchProductDetal().then((value){ productDetailList=value;  setState(() { isLoading=false; });  }); } //isLoading=false;


someFunction1(name){  final  url = recentAds.imageURLMap[name]??"https://firebasestorage.googleapis.com/v0/b/agrilease-ecd0b.appspot.com/o/None.jpeg?alt=media&token=ca13e835-b713-4991-8233-3d1098eec860";
  print("Name: $name , URL: $url"); return url; }

Future<void> someFunction3(value, index )async{ print("$value $index");

  print("someFunction3 start");
  final id = MyAds.productDetailIDList[index]; 
  final firebaseApp = Firebase.app(); 
  final dbref = FirebaseDatabase.instanceFor(app: firebaseApp, databaseURL: 'https://agrilease-ecd0b-default-rtdb.asia-southeast1.firebasedatabase.app/').ref();
  final data =   await dbref.child(id).get().then((value) {return value.value as Map<dynamic, dynamic>?;});// required for "data to be removed from category section"
  await dbref.child(id).remove(); 


  
  
  String? category;
  print("id: $id, data?['category']: ${data?['category'] } 'category is String':${data?['category']  is String}");
  if(data?['category'] is String){  
  category= data?['category']; print("category: $category");
  final docRef = FirebaseFirestore.instance.collection("category").doc(category);
  final update  = <String, dynamic>{id:FieldValue.delete()};
  await docRef.update(update);
  print("update: $update");     }  

  FireStore.delete(id); 
   setState((){ productDetailList; });
   }

@override
  void initState(){
  initFunction();
    super.initState();
  }


  @override
  
  Widget build(BuildContext context) {  //print("productDetailList[0].productID: ${productDetailList[0].productID}");
  return 
  RefreshIndicator(color: Colors.black, onRefresh: ()async{return initFunction();},
  child: Container(color: Colors.white, child: !isLoading && FireBaseAuthentication.isSignedIn ?AdsListView():
   const NotpublishedAd()  ,)
  );

  }

  ListView AdsListView() {

Future<dynamic> alertDeleteDialog(BuildContext context, value, index) => showDialog(context: context, builder: (context){return AlertDialog(
  backgroundColor: Colors.white, surfaceTintColor: Colors.transparent,
  title: const Text("Are you sure you want to delete?"),
  actions: [
    FilledButton( onPressed: (){ Navigator.of(context).pop(); },    style: ButtonStyle(shape: MaterialStateProperty.all(const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))), backgroundColor: MaterialStateProperty.all(Colors.white)), child: const Text("Cancel", style: TextStyle(color: Colors.grey),)),
    FilledButton( onPressed: ()async{Navigator.of(context).pop(); 
    await someFunction3(value, index).then((value){ initFunction(); }) ;
      },
        style: ButtonStyle(shape: MaterialStateProperty.all(const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))), backgroundColor: MaterialStateProperty.all(Colors.red[800])), child: const Text("Delete")),
    
  ],
  
  );});


    return ListView.builder(padding: const EdgeInsets.all(20), itemCount: productDetailList.length, itemBuilder: ((context, index) {return GestureDetector(onTap: (){Navigator.of(context).push(MaterialPageRoute(builder: (context){return FullProductDetail(productID:productDetailList[index].productID, rating: MyAds.ratingList[productDetailList[index].productID], reviews: MyAds.noOfReviews[productDetailList[index].productID], image: someFunction1(productDetailList[index].image), price: productDetailList[index].price, sellingPrice: productDetailList[index].sellingPrice, title: productDetailList[index].title, description: productDetailList[index].description, email: productDetailList[index].email??"email", location: productDetailList[index].location??"location", contact: productDetailList[index].contact);}));},
      child: Card(surfaceTintColor: Colors.white, color: Colors.white, child: Row( //Dismissible(key: UniqueKey(), onDismissed: (direction){ setState((){productDetailList.removeAt(index);}); }, 
     children: [
        
        Expanded(child: Row(children: [ Expanded(child: AspectRatio(aspectRatio: 0.9, child: Container(margin: const EdgeInsets.all(10),   decoration: BoxDecoration(color: Colors.black, image: DecorationImage(image: NetworkImage(someFunction1(productDetailList[index].image)))) ))), //decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(someFunction1(productDetailList[index].image))))
              Expanded(child: AspectRatio(aspectRatio: 1, child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceEvenly,  children: [ 
                
                Text(productDetailList[index].title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),), 
                  Text("\u{20B9} ${productDetailList[index].price} ${productDetailList[index].priceUnit == null?"":"per ${productDetailList[index].priceUnit}"}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), ), 
                    Text(productDetailList[index].description, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 16, overflow: TextOverflow.ellipsis,), ),
                      Text("+91 ${productDetailList[index].contact}",  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 14, overflow: TextOverflow.ellipsis,),)
     
      ])) ),
            ],
          ),
        ),
        Row( children: [PopupMenuButton(icon: const Icon(Ionicons.ellipsis_vertical, color: Colors.black,), color: Colors.red[50], surfaceTintColor: Colors.white, onSelected: (value){ alertDeleteDialog(context, value, index);  },  itemBuilder: (context){return[ PopupMenuItem( value: 0, child: Text(AppLocalizations.of(context)!.tagDelete, textAlign:TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),))];})],),
     ],
     )),
    );}  ));
  
  
  
  
  
  
  }
}




class NotpublishedAd extends StatelessWidget {
  const NotpublishedAd({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(child: AspectRatio( aspectRatio: 1.5,
        child: Container(  margin: const EdgeInsets.all(20),padding: const EdgeInsets.all(20),  decoration:  BoxDecoration( 
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 2), borderRadius: const BorderRadius.all(Radius.circular(6)) ),  child: Center(
          child: Column(children: [
            Expanded(child: Container( decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/publications.webp'), fit: BoxFit.fitHeight)), )),
            Text(AppLocalizations.of(context)!.tagNoAdsMSG, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), ),
            ],),),
        ),
      ),
    );
  }
}

class GoogleButton extends StatelessWidget {
  const GoogleButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container( color: Colors.grey[200], padding: const EdgeInsets.all(5), child: const Row(
      children: [
        Expanded(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Ionicons.logo_google), Text(" Sign in Google")],)),
      ],
    ),);
  }
}




