
import 'package:agrilease/pages/product_card_full_detail_page.dart';
import 'package:agrilease/pages/recent_section.dart';
import 'package:agrilease/pages/review_and_rating.dart';
import 'package:agrilease/recent_section_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}



class _AdminPageState extends State<AdminPage> {

@override
  void initState() {

    someFunction();
    super.initState();
  }


dynamic loading =  const Dialog(surfaceTintColor: Colors.transparent, backgroundColor: Color.fromARGB(0, 255, 255, 255), child: Center(child: CircularProgressIndicator(color: Color.fromRGBO(255, 235, 238, 1),) )) ;

int itemCount = 0;
List<SpecialProductDetail> productDetailList = [];
List<dynamic> productDetailIDList = [];
bool isLoading = true;
Map<String, double> rating = {};
Map<String, int> reviews = {};

void refresh()async{
  productDetailList = [ ];
  await someFunction();
}


Future<void> someFunction()async{
FirebaseDatabase rtdbInstance = await DatabaseInitiation().recentSectionData();
final data = rtdbInstance.ref();
final DataSnapshot snapshot = await data.get();
final Map<dynamic, dynamic> productData = snapshot.value as Map<dynamic, dynamic>;
productDetailIDList = productData.keys.toList();

itemCount = productData.keys.toList().length;

//final data3 =  data2.values.toList();


for(dynamic id in productDetailIDList){
print(productData[id]);
String? price;
if(productData[id]["price"].runtimeType == String){ price = productData[id]["price"];  }else{price = productData[id]["price"]["price"];}

print("productID: $id, image: ${productData[id]["image"]}, title: ${productData[id]["title"]}, price: $price, sellingPrice: ${productData[id]["sellingPrice"]}, description: ${productData[id]["description"]}, email: ${productData[id]["email"]}, location: ${productData[id]["location"]}, contact: ${productData[id]["contact"]}");
productDetailList.add(SpecialProductDetail(productID: id, image: productData[id]["image"], title: productData[id]["title"], price: price!, sellingPrice: productData[id]["sellingPrice"], description: productData[id]["description"], email: productData[id]["email"], location: productData[id]["location"], contact: productData[id]["contact"].toString()));  

String? imageURL = await ImageMapURL().imageURL(productData[id]["image"]);
ImageMapURL.store[productData[id]["image"]] = imageURL!;

rating[id] = await RatingsAndReviews(productID: id).rating;
reviews[id] = await RatingsAndReviews(productID: id).noOfReviews;
}

print(ImageMapURL.store);

//print("data3: ${data3[0]}");

setState(() {
itemCount;  
productDetailList;
isLoading = false;
});
}


Future<int> deleteAD(index, email)async{
  print("productDetailID: ${productDetailIDList[index]}");
  final String productDetailID = productDetailIDList[index];
  final FirebaseDatabase rtdbInstance = await DatabaseInitiation().recentSectionData();
  final fireStoreInstance = FirebaseFirestore.instance;
  await rtdbInstance.ref().child(productDetailID).remove();
  await fireStoreInstance.collection("users_published_ad").doc(email).update({productDetailID:FieldValue.delete()});

  return 0;
}



  @override
  Widget build(BuildContext context) {
dynamic loadingScreen(){return const Center(child: CircularProgressIndicator(color: Colors.black,));  }

    return Scaffold(
      appBar: AppBar(backgroundColor:  Colors.white, surfaceTintColor: Colors.transparent, title: Text(AppLocalizations.of(context)!.tagAdmin, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors. black87), ),  ),
      body: Container( padding: const EdgeInsets.all(20), color: Colors.white,
        child: isLoading? loadingScreen() :listView(),
        )

    );
  }

  ListView listView() {
    return ListView.builder(itemCount: itemCount, itemBuilder: (context, index){return GestureDetector(onTap: (){  
     Navigator.of(context).push( MaterialPageRoute(builder: (context){return FullProductDetail(productID:productDetailList[index].productID, rating: rating[productDetailList[index].productID], reviews: reviews[productDetailList[index].productID], image: ImageMapURL.store[productDetailList[index].image]??"https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.ncenet.com%2Fwp-content%2Fuploads%2F2020%2F04%2FNo-image-found.jpg&f=1&nofb=1&ipt=974f896e187b823800b88e7cc781f35a1020b685e44f12f53721f38462dd9bb7&ipo=images", price: productDetailList[index].price, sellingPrice: productDetailList[index].sellingPrice, title: productDetailList[index].title, description: productDetailList[index].description, email: productDetailList[index].email, location: productDetailList[index].location, contact: productDetailList[index].contact) ;})  );  
  }, child: adminCard(index, productDetailList[index].title,  productDetailList[index].image,
       productDetailList[index].description,  productDetailList[index].price,  productDetailList[index].email,  productDetailList[index].location,  productDetailList[index].contact, ));});
  }


AspectRatio adminCard(index, title, image, description, price, email, location, contact ){ 
  return AspectRatio( aspectRatio: 2.5,
      child: Card( color: Colors.white, surfaceTintColor: Colors.transparent, clipBehavior: Clip.hardEdge,
         child: Row(children: [AspectRatio(aspectRatio: 1, child: Card(clipBehavior: Clip.hardEdge, color: Colors.black, margin: const EdgeInsets.all(10), child: Image( fit: BoxFit.cover, image: NetworkImage(ImageMapURL.store[image]??"https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.ncenet.com%2Fwp-content%2Fuploads%2F2020%2F04%2FNo-image-found.jpg&f=1&nofb=1&ipt=974f896e187b823800b88e7cc781f35a1020b685e44f12f53721f38462dd9bb7&ipo=images" )), )), //EdgeInsets.all(10),
         Expanded(
           child: AspectRatio( aspectRatio: 1.7,
             child: Padding(
               padding: const EdgeInsets.all(10.0),
               child: Column(  mainAxisAlignment: MainAxisAlignment.spaceAround,  crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),), 
                Text("\u{20B9} $price", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12), ), 
                Text(description,softWrap: true,  style: const TextStyle(overflow: TextOverflow.ellipsis, fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12,),),
                Text("+91 $contact",  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12, overflow: TextOverflow.ellipsis,),),
               ],),
             ),
           ),
         ),
         Container(child: PopupMenuButton(icon: const Icon(Ionicons.ellipsis_vertical, color: Colors.black54,),  color: Colors.white, surfaceTintColor: Colors.transparent,  itemBuilder: (context) {return [PopupMenuItem( onTap: (){ alertDeleteDialog(context, index, email);  }, child: Text(AppLocalizations.of(context)!.tagDelete))];
           

        

         },),),


         ],)
      
      ),
    );
}

Future<dynamic> alertDeleteDialog(BuildContext context, int index, String email) => showDialog(context: context, builder: (context){return AlertDialog(
  backgroundColor: Colors.white, surfaceTintColor: Colors.transparent,
  title: Text(AppLocalizations.of(context)!.tagAlertDeleteMSG),
  actions: [
    FilledButton( onPressed: (){ Navigator.of(context).pop(); },    style: ButtonStyle(shape: MaterialStateProperty.all(const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))), backgroundColor: MaterialStateProperty.all(Colors.white)), child: Text( AppLocalizations.of(context)!.tagCancel , style: const TextStyle(color: Colors.grey),)),
    FilledButton( onPressed: ()async{Navigator.of(context).pop(); setState((){ isLoading=true; }); await deleteAD(index, email).then((value)async{return  await Future.delayed(const Duration(seconds: 5), (){print("delayed refresh admin page"); refresh();});  }); },
        style: ButtonStyle(shape: MaterialStateProperty.all(const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))), backgroundColor: MaterialStateProperty.all(Colors.red[800])), child: Text(AppLocalizations.of(context)!.tagDelete) ),
    
  ],
  
  );});

  
}







class ImageMapURL{
static Map<String, String> store = {};

Future<String?> imageURL(String imageName) async{
final fireStoreRef = FirebaseStorage.instance.ref();
try{return await fireStoreRef.child(imageName).getDownloadURL();  }catch(e){return null;}


}
}