//import 'package:agrilease/login_api.dart';

import 'package:agrilease/pages/product_card_full_detail_page.dart';
import 'package:agrilease/pages/recent_section.dart';
import 'package:agrilease/recent_section_api.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

List<ProductDetail> productDetailList = [];
Map<dynamic, dynamic> result = {};
int queryLength = 0;
dynamic resultKeys = [];
late Map<dynamic, dynamic> queryResult;
List<String> selectedChips=[];

void someFunction(List<ProductDetail>? value){
productDetailList = []; 
queryLength = 0;
if(value!=null){
productDetailList = value; 
queryLength = value.length;}

setState(() {
productDetailList;
queryLength;
});

}


  @override
  Widget build(BuildContext context) { 
final List<String> labels = [AppLocalizations.of(context)!.tagTitle, AppLocalizations.of(context)!.tagDescription, AppLocalizations.of(context)!.tagLocation, AppLocalizations.of(context)!.tagPrice,  ];
final List<String> searchFields = ["title", "description", "location", "price"];
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white, surfaceTintColor: Colors.transparent, ),
      body: Container( padding: const EdgeInsets.all(20), color: Colors.white,
        child: Column(children: [
          Padding(padding: const EdgeInsets.all(20.0),
            child: Material( shadowColor: Colors.grey, elevation: 3, color: Colors.white, surfaceTintColor: Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.circular(40)),
              child: TextField( onSubmitted: (String value) async{  await searchQuery( searchFields[chosenIndex] , value).then((value){ someFunction(value); });
              }, 
              
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(contentPadding: const EdgeInsets.only(left: 40), hintText: AppLocalizations.of(context)!.tagSearch, focusedBorder: InputBorder.none,   border: InputBorder.none )
            
            
              ),
            ),),


              AspectRatio(aspectRatio: 4, child: GridView.count(crossAxisCount: 4,children: List.generate(labels.length, (index){return customChip(labels[index], index);}) )),



            Expanded(child: ListView.builder(itemCount: queryLength, itemBuilder: (context, index){return SearchQueryAdCard(image: productDetailList[index].image, title: productDetailList[index].title, price: productDetailList[index].price, description: productDetailList[index].description, contact: productDetailList[index].contact, email: productDetailList[index].email, location: productDetailList[index].location ); }))
        ]),
      ),


    );
  }
int chosenIndex = 0;

  dynamic customChip(String label, int index) => Container(margin: const EdgeInsets.all(5), child: ChoiceChip(label: Text(label), selected: chosenIndex==index, onSelected: (isSelected){ setState((){ if(isSelected){chosenIndex = index;}   });  }, color: MaterialStateProperty.all(Colors.white ), selectedColor: Colors.green, surfaceTintColor: Colors.transparent, ));
}

class SearchQueryAdCard extends StatelessWidget {final String image; final String title; final String price; final String description; final String contact; final String email; final String location;
  const SearchQueryAdCard({  
    super.key, required this.image, required this.title,  required this.price, required this.description, required this.contact, required this.email, required this.location,
  });

  @override
  Widget build(BuildContext context) {//print(image); print(ImageMapURL.store[image]);
    return GestureDetector( onTap: (){  Navigator.of(context).push( MaterialPageRoute(builder: (context){return FullProductDetail(appBarBackGroundColor: Colors.white, gradientColor: const [Colors.white, Colors.white], image: ImageMapURL.store[image]??"https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.ncenet.com%2Fwp-content%2Fuploads%2F2020%2F04%2FNo-image-found.jpg&f=1&nofb=1&ipt=974f896e187b823800b88e7cc781f35a1020b685e44f12f53721f38462dd9bb7&ipo=images", price: price, title: title, description: description, email: email, location: location, contact: contact) ;})  );  },
      child: AspectRatio( aspectRatio: 2.5,
        child: Card( color: Colors.white, surfaceTintColor: Colors.transparent, clipBehavior: Clip.hardEdge,
           child: Row(children: [AspectRatio(aspectRatio: 1, child: Card(clipBehavior: Clip.hardEdge, color: Colors.black, margin: const EdgeInsets.all(10), child: Image( fit: BoxFit.cover, image: NetworkImage(ImageMapURL.store[image]??"https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.ncenet.com%2Fwp-content%2Fuploads%2F2020%2F04%2FNo-image-found.jpg&f=1&nofb=1&ipt=974f896e187b823800b88e7cc781f35a1020b685e44f12f53721f38462dd9bb7&ipo=images" )), )), //EdgeInsets.all(10),
           Padding(
             padding: const EdgeInsets.all(10.0),
             child: Column(
               children: [
                 Expanded(
                   child: AspectRatio( aspectRatio: 1.7,
                     child: Column(  mainAxisAlignment: MainAxisAlignment.spaceAround,  crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),), 
                      Text("\u{20B9} $price", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12), ), 
                      Text(description,softWrap: true,  style: const TextStyle(overflow: TextOverflow.ellipsis, fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12,),),
                      Text("+91 $contact",  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12, overflow: TextOverflow.ellipsis,),),
                     ],),
                   ),
                 ),
               ],
             ),
           )
           ],)
        
        ),
      ),
    );
  }
}

Future<List<ProductDetail>?> searchQuery(String field, String value) async {
  final FirebaseDatabase fireBase = await  DatabaseInitiation().recentSectionData();
  final Map<dynamic, dynamic>? result = await fireBase.ref().orderByChild(field).startAt(value).limitToFirst(4).once().then((value){print("value: ${value.snapshot.value}");  if(value.snapshot.value==null){return null;} return value.snapshot.value  as Map<dynamic, dynamic>;  }  ) ;
  print("result: $result");
  if(result==null){ImageMapURL.store={}; return null;}
  List<ProductDetail> productDetailList = [];
  for (String mapId in result.keys){

    productDetailList.add( ProductDetail(description: result[mapId]?['description'], email: result[mapId]?["email"], title: result[mapId]['title'], image: result[mapId]['image'], location: result[mapId]['location'], contact: result[mapId]['contact'], price: result[mapId]['price']) );
    ImageMapURL.store[result[mapId]['image']] = await ImageMapURL().imageURL(result[mapId]['image'])??"https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.ncenet.com%2Fwp-content%2Fuploads%2F2020%2F04%2FNo-image-found.jpg&f=1&nofb=1&ipt=974f896e187b823800b88e7cc781f35a1020b685e44f12f53721f38462dd9bb7&ipo=images";
  }
  return productDetailList;
}





class ImageMapURL{
static Map<String, String> store = {};

Future<String?> imageURL(String imageName) async{
final fireStoreRef = FirebaseStorage.instance.ref();
try{return await fireStoreRef.child(imageName).getDownloadURL();}catch(e){return null;}


}
}

