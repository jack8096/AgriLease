import 'package:agrilease/pages/product_card_full_detail_page.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:agrilease/recent_section_api.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ProductDetail { final String image; final String title; final String price; final String description; final String email;  final String contact; final String location;
  ProductDetail({required this.image, required this.title, required this.price, required this.description, required this.email, required this.location, required this.contact,});

factory ProductDetail.fromSnapshot(DataSnapshot snapshot){
  Map<String,String> data = snapshot.value as Map<String, String>;
  return ProductDetail(image: data['image']??"None.jpeg", title: data["title"]??"None", price: data["price"]??"None", description: data["description"]??"None",  email: data["email"]??"None", location: data["location"]??"None", contact: data["contact"]??"None");
}
}






class FetchData{
static late List<ProductDetail> list;
static late int dataListLength;
static List imageURLlist = [];
static Map imageURLMap = {};

static Future<void> fetchData()async{
List<ProductDetail> productDetailList = [];

final FirebaseDatabase snapShotData = await DatabaseInitiation().recentSectionData();
dynamic data = await snapShotData.ref().get();
dynamic dataList = data.value;

dataListLength = dataList.length;
dynamic mapId;
print('dataList: $dataList,');

for( mapId in dataList.keys ){

  productDetailList.add( ProductDetail(description: dataList[mapId]?['description']??'None', email: dataList[mapId]?["email"]??"None", title: dataList[mapId]['title']??'None', image: dataList[mapId]['image']??'None.jpeg', location: dataList[mapId]['location']??'None.', contact: dataList[mapId]['contact']??'None.',
  price: dataList[mapId]['price']??'None') );
  fetchImage(dataList[mapId]['image']??'None.jpeg');
 }
 
print(productDetailList); 

list = productDetailList;
}






static void  fetchImage(imageName)async{
  print(imageName);
final storageRef = FirebaseStorage.instance.ref();
final String imageURL =  await storageRef.child(imageName).getDownloadURL();
print(imageURL);
imageURLMap[imageName] = imageURL;
print('hi deepak up is imagesRef');
//imageURLlist.add(imageURL);

}

}






class RecentSection extends StatelessWidget  {
    const RecentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(child:Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: GridView.count(crossAxisCount: 2, mainAxisSpacing: 5, crossAxisSpacing: 5, childAspectRatio: 0.7,
          children: List<Widget>.generate(FetchData.dataListLength, (index) {return Builder(builder: (BuildContext context){return ProductCard(index: index);});})
          ),
      ),
    ));
  }
}




class ProductCard extends StatelessWidget {final int index;
ProductCard({super.key,  required this.index});

final textColor = Colors.grey[850];



  @override
  Widget build(BuildContext context) {
    //String image = FetchData.imageURLlist[index];
    String image = FetchData.imageURLMap[FetchData.list[index].image];
    String price = FetchData.list[index].price;//'price';
    String title = FetchData.list[index].title;//'tractor';
    String description = FetchData.list[index].description; //'description';//'very good tractor';
    String location = FetchData.list[index].location;
    String contact = FetchData.list[index].contact;
    String email = FetchData.list[index].email;
    return  GestureDetector( onTap: () { Navigator.push( context,
              MaterialPageRoute(builder: (context) =>  FullProductDetail(image: image, price:price, title:title, description:description, email:email, location: location, contact: contact,)),); },
      child: Container( height: 200,   decoration: BoxDecoration(color: Colors.white,  border: Border.all(color: Colors.black12)),//width: 150, 
         child: Column( mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
           children: [ 
              Expanded(flex:7, child: Padding(padding: const EdgeInsets.fromLTRB(5,5,5,0), child: AspectRatio(aspectRatio: 0.9, child: 
              Container( decoration: BoxDecoration(color: Colors.grey[200], border: Border.all(color: Colors.black26), image: DecorationImage( image: 
              NetworkImage(image), fit: BoxFit.fitHeight, filterQuality: FilterQuality.low, opacity: 0.9)  ),)),),), //child: Image.network(image, fit: BoxFit.fitHeight,),

              Padding( padding: const EdgeInsets.fromLTRB(5,0,5,5),
              child: Column( crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('\u20B9$price',style: const TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold), selectionColor: textColor,), Text(title, style: const TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.normal),), Text(description,  maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.normal,))]),
              ),

         ],),
       ),
    );}
}




