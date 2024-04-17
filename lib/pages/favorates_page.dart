import 'package:agrilease/pages/product_card_full_detail_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FavoratesPage extends StatefulWidget {
  const FavoratesPage({super.key});

  @override
  State<FavoratesPage> createState() => _FavoratesPageState();
}

class _FavoratesPageState extends State<FavoratesPage> {
  List favoratesList = [];
  bool isLoading = true;

  Map? productDetail;
  List imagesName = [];
  Map? imagesSrcs = {};

  initFunction()async{
    print("initFunction");
    favoratesList = await Favourites.getList()??[];
    await Future.delayed(const Duration(seconds: 2));
    productDetail = await FavorateProducts.productDetail(favoratesList); if(productDetail?.isEmpty??true){ setState((){isLoading = false;}); return null;   }
    
    for(String productID in productDetail!.keys){  imagesName.add(productDetail?[productID]["image"]);  }
    
    

    imagesSrcs = await FavorateProducts.productImage(imagesName);
    print("imagesName: ${imagesName}"); print("imagesSrcs: $imagesSrcs");
    setState((){isLoading = false;});

  }

  @override
    void initState() {
      initFunction();
      super.initState();
    }

  @override
  Widget build(BuildContext context) {
    //print('productDetail?[favoratesList[0]?["image"]: ${productDetail?[favoratesList]}');
    return  Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.tagFavorites),),
      body: 
      isLoading?const Center(child:  CircularProgressIndicator(color: Colors.black, )):favoratesList.isEmpty?const Center(child: Text("No Favorate")):
      
      ListView.builder(itemCount: productDetail!.keys.length, itemBuilder: (context, itemNo)=> FavorateProductCard(image: imagesSrcs?[productDetail?[favoratesList[itemNo]]["image"]], productDetail: productDetail?[favoratesList[itemNo]], productDetailID: favoratesList[itemNo], ))
         //imagesSrcs?[imagesName[0]]
    );
  }

}



class FavorateProductCard extends StatelessWidget {final String image; final Map productDetail; final String productDetailID;
  const FavorateProductCard({super.key,required this.image, required this.productDetail, required this.productDetailID });

  @override
  Widget build(BuildContext context) { print("price: ${productDetail["price"]}");
    dynamic price = productDetail['price'];
    if(price is !String){price = productDetail["price"]['price']; }
    
    // c
    return GestureDetector( onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context)=> FullProductDetail(
      image: image, title: productDetail['title'], contact: productDetail["contact"], description: productDetail["description"], email: productDetail['email'], location: productDetail['location'], price: price, productID: productDetailID,
    ))),
      child: AspectRatio(aspectRatio: 3, child: Card(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        AspectRatio(aspectRatio: 1, child: Image.network(image),),
        AspectRatio(aspectRatio:2, child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,  mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Text(productDetail['title'], ),
            Text("\u{20B9} $price", style: const TextStyle(fontWeight: FontWeight.bold),),
            Text(productDetail["description"], style: const TextStyle(overflow: TextOverflow.ellipsis,), maxLines: 1,),
            Text("+91 ${productDetail["contact"]}")
        
          ],),
        ),)
      ],),),),
    );
  }
}

class FavorateProducts{
  static final firebaseApp = Firebase.app();
  static final rtdbRef = FirebaseDatabase.instanceFor(databaseURL: "https://agrilease-ecd0b-default-rtdb.asia-southeast1.firebasedatabase.app/", app: firebaseApp).ref();
  static final  fireStorage = FirebaseStorage.instance.ref();
  
  static Future<Map?> productDetail(List? productIDs)async{ print("productIDs: $productIDs");
    if(productIDs == null){ return null;}
    final Map<String,Map?  > productDetals = {}; 
    Map productDetal = {};
    for(String productID in productIDs){  print("for loop productIDs, productID: $productID");
    DataSnapshot snapshot = await rtdbRef.child(productID).get();
    if(snapshot.value == null){print("productID: $productID = map<String, Null>"); continue; }
    print("snapshot.value: ${snapshot.value}");
    productDetal =  snapshot.value as Map;
    
    productDetals[productID] = productDetal;}  
    print("productDetail: $productDetail");
    return productDetals;

  }

  static Future<Map?> productImage(List imagesName)async{
    if(imagesName.isEmpty){return null;}
    Map imagesSrcs= {};
    for(String imageName in imagesName){
    imagesSrcs[imageName] = await fireStorage.child(imageName).getDownloadURL();  
    }
    return imagesSrcs;
  }

}