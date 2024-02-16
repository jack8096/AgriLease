import 'package:agrilease/pages/product_card_full_detail_page.dart';
import 'package:agrilease/pages/review_and_rating.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:agrilease/recent_section_api.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ProductDetail { final String image; final String title; final Map<String, String> price; final String? sellPrice; final String description; final String? category; final String email;  final String contact; final String location;
  ProductDetail({required this.image, required this.title, required this.price, this.sellPrice, required this.description, this.category, required this.email, required this.location, required this.contact,});

// factory ProductDetail.fromSnapshot(DataSnapshot snapshot){
//   Map<String,String> data = snapshot.value as Map<String, String>;
//   return ProductDetail(image: data['image']??"None.jpeg", title: data["title"]??"None", price: data["price"]??"None", description: data["description"]??"None",  email: data["email"]??"None", location: data["location"]??"None", contact: data["contact"]??"None");
// }
}


class SpecialProductDetail {final String productID; final String image; final String? sellingPrice; final String? priceUnit; final String title; final String price; final String description; final String email;  final String contact; final String location;
  SpecialProductDetail({required this.productID, required this.image, this.sellingPrice, this.priceUnit, required this.title, required this.price, required this.description, required this.email, required this.location, required this.contact,});
}

FetchData recentAds = FetchData();


class FetchData{
late List<SpecialProductDetail> _list;  List<SpecialProductDetail> get list => _list;
int _dataListLength = 0;         int get dataListLength => _dataListLength;
final List _imageURLlist = [];   List get imageURLlist => _imageURLlist;
final Map _imageURLMap = {};     Map get imageURLMap => _imageURLMap;
final Map _productIdRatingMap = {}; Map get productIdRatingMap => _productIdRatingMap;
final Map _productIdNoOfReviews = {}; Map get productIdNoOfReviews => _productIdNoOfReviews;

Future<void> fetchData()async{
List<SpecialProductDetail> productDetailList = [];

final FirebaseDatabase snapShotData = await DatabaseInitiation().recentSectionData();
dynamic data = await snapShotData.ref().get();
dynamic dataList = data.value;

_dataListLength = dataList.length;
dynamic mapId;
print('dataList: $dataList,');
String noneJpeg = "https://firebasestorage.googleapis.com/v0/b/agrilease-ecd0b.appspot.com/o/None.jpeg?alt=media&token=ca13e835-b713-4991-8233-3d1098eec860";
for( mapId in dataList.keys ){
  var price = "null";
  var priceUnit;
  if(dataList[mapId]['price'].runtimeType == String){price = dataList[mapId]['price'];}else{price = dataList[mapId]['price']['price']; priceUnit = dataList[mapId]['price']['priceUnit'];}
  productDetailList.add( SpecialProductDetail(productID: mapId, sellingPrice: dataList[mapId]?['sellingPrice'], priceUnit: priceUnit, description: dataList[mapId]?['description']??'None', email: dataList[mapId]?["email"]??"None", title: dataList[mapId]['title']??'None', image: dataList[mapId]['image']??noneJpeg, location: dataList[mapId]['location']??'None.', contact: dataList[mapId]['contact']??'None.', price: price) ); //dataList[mapId]['price']??'None'
  print("sellingPrice: ${dataList[mapId]?['sellingPrice']}");
  fetchImage(dataList[mapId]['image']??'None.jpeg');
  print("mapId: $mapId");
  _productIdRatingMap[mapId]= await RatingsAndReviews(productID: mapId).rating;
  //print("productIdRatingMap[$mapId]: ${productIdRatingMap[mapId]}");
  productIdNoOfReviews[mapId] = await RatingsAndReviews(productID: mapId).noOfReviews;
 }
 
print(productDetailList); 

_list = productDetailList;
}






void  fetchImage(imageName)async{
  print(imageName);
final storageRef = FirebaseStorage.instance.ref();
final String imageURL =  await storageRef.child(imageName).getDownloadURL();
//print(imageURL);
_imageURLMap[imageName] = imageURL;
//imageURLlist.add(imageURL);

}

}






class RecentSection extends StatelessWidget  {
    const RecentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: GridView.count(shrinkWrap:true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 2, mainAxisSpacing: 5, crossAxisSpacing: 5, childAspectRatio: 0.7,
          children: List<Widget>.generate(recentAds.dataListLength, (index) {return Builder(builder: (BuildContext context){return ProductCard(index: index);});})
          ),
      ),
    );
  }
}




class ProductCard extends StatelessWidget {final int index;
ProductCard({super.key,  required this.index});

final textColor = Colors.grey[850];



  @override
  Widget build(BuildContext context){
    //String image = FetchData.imageURLlist[index];
    
    String productID = recentAds.list[index].productID;
    double rating = recentAds.productIdRatingMap[productID];
    int reviews = recentAds.productIdNoOfReviews[productID];
    String? sellPrice = recentAds.list[index].sellingPrice;//'price';

    String image = recentAds.imageURLMap[recentAds.list[index].image];
    String price = recentAds.list[index].price;//'price';
    String? priceUnit = recentAds.list[index].priceUnit;
    String title = recentAds.list[index].title;//'tractor';
    String description = recentAds.list[index].description; //'description';//'very good tractor';
    String location = recentAds.list[index].location;
    String contact = recentAds.list[index].contact;
    String email = recentAds.list[index].email;
    return  GestureDetector( onTap: () { Navigator.push( context,
              MaterialPageRoute(builder: (context) =>  FullProductDetail(rating: rating, reviews: reviews, productID: productID,  image: image, price:price, sellingPrice: sellPrice, title:title, description:description, email:email, location: location, contact: contact,)),); },
      //child: Container( height: 200,   decoration: BoxDecoration(color: Colors.white,  border: Border.all(color: Colors.black12)),//width: 150, 
child: Card( surfaceTintColor: Colors.white, color: Colors.white,
         child: Column( mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
           children: [ 
              Expanded(flex:7, child: Padding(padding: const EdgeInsets.fromLTRB(5,5,5,0), child: AspectRatio(aspectRatio: 0.9, child: 
              Card(clipBehavior: Clip.hardEdge, surfaceTintColor: Colors.white, color: Colors.white,
                child: Container( decoration: BoxDecoration( image: DecorationImage( image: //color: Colors.grey[200],  borderRadius: const BorderRadius.all(Radius.circular(8)),border: Border.all(color: Colors.black26,),
                NetworkImage(image),  fit: BoxFit.fitHeight, filterQuality: FilterQuality.low, opacity: 0.9)  ),),
              )),),), //child: Image.network(image, fit: BoxFit.fitHeight,),

              Padding( padding: const EdgeInsets.fromLTRB(5,0,5,5),
              child: Column( crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('\u20B9$price ${priceUnit == null?"":"per $priceUnit"}',style: const TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold), selectionColor: textColor,), Text(title, style: const TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.normal),), Text(description,  maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.normal,))]),
              ),

         ],),
       ),
    );}
}




