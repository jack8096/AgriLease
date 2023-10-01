import 'package:firebase_storage/firebase_storage.dart';

import 'package:agrilease/recent_section_api.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ProductDetail { final String image; final String title; final String price; final String description;
  ProductDetail({required this.image, required this.title, required this.price, required this.description, });
}


class FetchData{
static late List<ProductDetail> list;
static List imageURLlist = [];
static Map imageURLMap = {};

static Future<void> fetchData()async{
List<ProductDetail> productDetailList = [];

final FirebaseDatabase snapShotData = await DatabaseInitiation().recentSectionData();
dynamic data = await snapShotData.ref().get();
dynamic dataList = data.value;

int dataSize = dataList.length;
for(var index = 0; index < dataSize; index++ ){ //print(index);
  productDetailList.add( ProductDetail(description: dataList[index]['description']??'None', title: dataList[index]['title']??'None.', image: dataList[index]['image']??'None.jpeg', //fetchImage(dataList[index]['image']), 
  price: dataList[index]['price']??'None') );
  fetchImage(dataList[index]['image']??'None.jpeg');
 }
 //print('list size is $dataSize');
print(productDetailList); 
//print(dataList.runtimeType); 
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
    //child: GridView.builder(gridDelegate: gridDelegate, itemBuilder: itemBuilder)
    return Expanded(
      child:Padding( padding: const EdgeInsets.all(5),
        child: GridView.count(crossAxisCount: 2, mainAxisSpacing: 5, crossAxisSpacing: 5, childAspectRatio: 0.7,
        children: [ProductCard(index: 0),ProductCard(index: 1), //Container(color:Colors.black, height: 200, width: 200, child: Image.network(FetchData.imagesURL),),
        ],
        ),
      ),
    );
  }
}




class ProductCard extends StatelessWidget {final int index;
ProductCard({super.key,  required this.index});

final textColor = Colors.grey[700];



  @override
  Widget build(BuildContext context) {
    //String image = FetchData.imageURLlist[index];
    String image = FetchData.imageURLMap[FetchData.list[index].image];
    String price = FetchData.list[index].price;//'price';
    String title = FetchData.list[index].title;//'tractor';
    String description = FetchData.list[index].description; //'description';//'very good tractor';
    return  GestureDetector( onTap: () {  },
      child: Container( height: 200,   decoration: BoxDecoration(color: Colors.white,  border: Border.all(color: Colors.grey)),//width: 150, 
         child: Column( mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
           children: [ 
              Expanded(flex:7, child: Padding(padding: const EdgeInsets.fromLTRB(5,5,5,0), child: AspectRatio(aspectRatio: 0.9, child: Container( color: Colors.grey[200], child: Image.network(image, fit: BoxFit.fitHeight,), ),)),),
              Expanded(flex:3, child: Padding( padding: const EdgeInsets.fromLTRB(5,0,5,5),
                child: Column( crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [Text('\u20B9$price',style: const TextStyle(fontSize: 16), selectionColor: textColor,), Text(title), Text(description,  maxLines: 1, overflow: TextOverflow.ellipsis,)]),
              )
              //Container(color: Colors.black,)
              ),




          //  Expanded(flex: 1, child: Spacer()),
          //  Expanded(flex: 3, child: AspectRatio(aspectRatio: 0.9, child: Container( color: Colors.grey[200], ),  ),),
          //  Expanded(flex: 1, child: Text(price ,      style: TextStyle( color: textColor, ),),),
          //  Expanded(flex: 1, child: Text(title ,      style: TextStyle( color: textColor, ),),),
          //  Expanded(flex: 1, child: Text(description, style: TextStyle( color: textColor, ),),),
         ],),
       ),
    );}
}




