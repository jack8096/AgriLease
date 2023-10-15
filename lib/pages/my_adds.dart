//import 'dart:ffi';

import 'package:agrilease/login_api.dart';
import 'package:agrilease/pages/ad_form.dart';
import 'package:agrilease/pages/recent_section.dart';
import 'package:agrilease/recent_section_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class FireStore {
  static  dynamic emailID = FireBaseAuthentication.emailID;
  static late dynamic document;

   static void write( final String productDetailID ) async{
    
  //emailID??=  FireBaseAuthentication.accountInfo;

  dynamic writeproductDetailID =  FirebaseFirestore.instance.collection('users_published_ad');
  writeproductDetailID.doc(emailID).update({productDetailID:null}); //.set({productDetailID:null});
   print('hi');

  }

  static  fetchProductDetalID()async{ //Future<List<String>>
  if(!FireBaseAuthentication.isSignedIn){ print('Not Signed in to access data(FireStore.fetchProductDetalID())'); return false;}
    print(emailID);
    emailID = FireBaseAuthentication.emailID;
    late dynamic productDetailIDList;
    if(!FireBaseAuthentication.isSignedIn){print('if statement signed in false');
      await FireBaseAuthentication.signInWithGooggle(); }
    await FirebaseFirestore.instance.collection('users_published_ad').doc(emailID).get().then( (DocumentSnapshot doc){ productDetailIDList = doc.data() as Map<String, dynamic>; } );
    productDetailIDList = productDetailIDList.keys.toList();
    print(productDetailIDList);

    return productDetailIDList;
  }

  static delete(id)async{
   try{ 
    final docRef =  FirebaseFirestore.instance.collection('users_published_ad').doc(emailID);
    final updates = <String, dynamic>{id:FieldValue.delete()};
    docRef.update(updates);
     }catch(e){print(e);}

  }
  
}


class MyAds {
static late dynamic productDetailIDList;

static  fetchProductDetal()async{ //Future<List<ProductDetail>>
    productDetailIDList = await FireStore.fetchProductDetalID();
    final FirebaseDatabase snapShotData = await DatabaseInitiation().recentSectionData();
    List mapObjectList = [];
    for(String id in productDetailIDList){ 
    DataSnapshot data = await snapShotData.ref(id).get();
    mapObjectList.add(data.value);}
    

    List productDetailList = [];
     for( dynamic data in mapObjectList ){ print("hi deepak 24"); print(data);
      productDetailList.add( ProductDetail(image: data['image']??"None.jpeg", title: data['title'], price: data['price'], description: data['description'], email: data["email"], location: data['location'], contact: data["contact"]) );
      }
    print(productDetailList);
    print("code block run");
    return productDetailList;

}






}




class MyAdsPage extends StatelessWidget {
  const MyAdsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.green[50], title: const Text("My Ads", style: TextStyle(color: Colors.black45),),),
      body: //!FireBaseAuthentication.isSignedIn? Center(child: Column(children: [const Text("You have not signed in yet,sign in to see your previous Ad's"), GestureDetector(onTap: (){}, child: GoogleButton())]),):
      
      const ShowAds(),

      floatingActionButton: FilledButton( style: ButtonStyle( shape: MaterialStateProperty.all<RoundedRectangleBorder>( RoundedRectangleBorder( borderRadius: BorderRadius.circular(6.0),))),
      onPressed: ()async{ //if(!FireBaseAuthentication.isSignedIn){await FireBaseAuthentication.signInWithGooggle();}  //await MyAds.fetchProductDetal();
        if(FireBaseAuthentication.isSignedIn){print('signed in'); Navigator.push(context,  MaterialPageRoute(builder: (context) {return const AddAdSecton();}));}
      else{print('signed out'); alertDialog(context);   FireBaseAuthentication.signInWithGooggle(); print('isSignedIn: ${FireBaseAuthentication.isSignedIn}');}  //FireBaseAuth.signInWithGooggle();


        }, 
      child: const Text('Add'),)
    );
  }

  Future<dynamic> alertDialog(BuildContext context) {
    return showDialog (  context: context,  builder: (BuildContext context) =>   AlertDialog(
        title: const Text("you aren't signed in yet,\nsign in to publish ad"),
        actions: [GestureDetector( onTap: ()async{print('google button'); try{FireBaseAuthentication.signInWithGooggle(); Navigator.of(context).pop();}catch(e){print(e);}  },child: GoogleButton())],
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
Future<void> someFunction()async{   productDetailList = await MyAds.fetchProductDetal(); print("someFunction"); setState(() { isLoading=false; });} //isLoading=false;


someFunction1(name){  final  url = FetchData.imageURLMap[name]??"None.jpeg";  print("URL: $url"); return url; }

someFunction3(value, index )async{ print("$value $index"); try{
  final id = MyAds.productDetailIDList[index]; final firebaseApp = Firebase.app(); FirebaseDatabase.instanceFor(app: firebaseApp, databaseURL: 'https://agrilease-ecd0b-default-rtdb.asia-southeast1.firebasedatabase.app/').ref().child(id).remove(); 
  FireStore.delete(id); setState((){ productDetailList; });
}catch(e){print(e);} }

@override
  void initState(){
  someFunction();
    super.initState();
  }


  @override
  
  Widget build(BuildContext context) {
  return 
  RefreshIndicator( onRefresh: ()async{return someFunction();},
  child: !isLoading && FireBaseAuthentication.isSignedIn ?AdsListView():
   const NotpublishedAd()  ,
  );
  
   



    
  
  }

  ListView AdsListView() {
    return ListView.builder(itemCount: productDetailList.length, itemBuilder: ((context, index) {return Card(surfaceTintColor: Colors.white,  child: Row( //Dismissible(key: UniqueKey(), onDismissed: (direction){ setState((){productDetailList.removeAt(index);}); }, 
 children: [
      
      Expanded(child: Row(children: [ Expanded(child: AspectRatio(aspectRatio: 0.9, child: Container(margin: const EdgeInsets.all(10),   decoration: BoxDecoration(color: Colors.black, image: DecorationImage(image: NetworkImage(someFunction1(productDetailList[index].image)))) ))), //decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(someFunction1(productDetailList[index].image))))
            Expanded(child: AspectRatio(aspectRatio: 1, child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceEvenly,  children: [ 
              
              Text(productDetailList[index].title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),), 
                Text("\u{20B9} ${productDetailList[index].price}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), ), 
                  Text(productDetailList[index].description, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 16, overflow: TextOverflow.ellipsis,), ),
                    Text("+91 ${productDetailList[index].contact}",  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 14, overflow: TextOverflow.ellipsis,),)
 
  ])) ),
          ],
        ),
      ),
      Row( children: [PopupMenuButton(onSelected: (value){someFunction3(value, index); someFunction();},  itemBuilder: (context){return[ const PopupMenuItem( value: 0, child: Text("delete"))];})],),
 ],
 ));}  ));
  }
}




class NotpublishedAd extends StatelessWidget {
  const NotpublishedAd({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(child: AspectRatio( aspectRatio: 1.5,
        child: Container( margin: const EdgeInsets.all(20),padding: const EdgeInsets.all(20),  decoration:  BoxDecoration( 
          border: Border.all(color: Theme.of(context).primaryColor, width: 2), borderRadius: const BorderRadius.all(Radius.circular(6)) ),  child: Center(
          child: Column(children: [
            Expanded(child: Container( decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/publications.webp'), fit: BoxFit.fitHeight)), )),
            const Text("You haven't listed anything yet", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16), ),
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




