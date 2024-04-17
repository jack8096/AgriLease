import 'package:agrilease/login_api.dart';
import 'package:agrilease/pages/chats.dart';
import 'package:agrilease/pages/review_and_rating.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'calender_page.dart';


class FullProductDetail extends StatelessWidget {final double? rating; final int? reviews; final String? productID; final String image; final String price; final String? sellingPrice; final String title; final String description; final String email;  final String contact; final String location; //final Color? appBarBackGroundColor; final List<Color> gradientColor;
  const FullProductDetail({super.key,  this.rating, this.reviews, this.productID,  required  this.image, required this.price, this.sellingPrice, required this.title, required this.description, required this.email, required this.location, required this.contact, }); //required this.appBarBackGroundColor, required this.gradientColor,
final  backgroundcolor = const Color.fromARGB(255, 255, 249, 255,);

// addFavourites(){
//   if(productID == null){return null;}
//   Favourites.add(productID);
// }

  @override
  Widget build(BuildContext context) {//print("FullProductDetail:- sellingPrice: $sellingPrice");
    //print("rating: $rating, reviews:$reviews, productID: $productID,");
    return Scaffold( 
      appBar: AppBar( backgroundColor: Colors.green[300], surfaceTintColor: Colors.transparent,),
      body: Container(  color: Colors.white,
        child: ListView(padding: const EdgeInsets.only(left: 10, right: 10, top: 5,),
          children: [
            ImageCard(image: image, productID: productID),
            TitleCard(rating: rating??0, reviews:reviews??0, productID: productID, title: title, price: price, sellPrice: sellingPrice, location: location, email: email,),//title price 
            DescriptionCard(description: description),// description
            AddressCard(address: location,),
            
          ],
        ),
      ),



    bottomNavigationBar: SafeArea(child: Container( color: Colors.white,
      child: AspectRatio(aspectRatio: 5.85, child:Padding( padding: const EdgeInsets.all(8),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
          children: [ OutlinedButton( style: ButtonStyle(    shape: MaterialStateProperty.all<RoundedRectangleBorder>( RoundedRectangleBorder(side: const BorderSide( color: Color.fromRGBO(102, 187, 106, 1)), borderRadius: BorderRadius.circular(6.0),)),
           ),
                        
                        onPressed: ()async{ 
                          print("pressed chat button");
                          if(!FireBaseAuthentication.isSignedIn){
                            await FireBaseAuthentication().signInWithGooggle(); try{print("us: ${FireBaseAuthentication.emailID} them: ${email} ");}catch(e){print(e);}
                            }else{ try{print("us: ${FireBaseAuthentication.emailID} them: ${email} ");
                            await Chats().createChatRoom(FireBaseAuthentication.emailID, email).then((value){  
                              Navigator.of(context).push(MaterialPageRoute(builder: (context){return ChatSection(roomID: value, reciverEmail: email);}));
                               });
                            }catch(e){print(e);} } 

                        }, child: Text(AppLocalizations.of(context)!.tagChat, style: TextStyle(color: Colors.green[400]),) ),
                      ElevatedButton( style: ButtonStyle( backgroundColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(102, 187, 106, 1)), foregroundColor: MaterialStateProperty.all<Color>(Colors.white),  shape: MaterialStateProperty.all<RoundedRectangleBorder>( RoundedRectangleBorder( borderRadius: BorderRadius.circular(6.0),))),
                        onPressed: (){ launchUrl(Uri(scheme: 'tel', path: contact)); }, child: Text(AppLocalizations.of(context)!.tagCall)),]
                       
        ),
      ) ,),
    )),
    floatingActionButton: (FireBaseAuthentication.emailID.replaceAll(" ", "") != email.replaceAll(" ", ""))?FloatingActionButton(onPressed: ()async{ print("FireBaseAuthentication.emailID: '${FireBaseAuthentication.emailID.replaceAll(" ", "")}', email: '${email.replaceAll(" ", "")}'");
        if(productID == null){return ;}
        await Chats().createChatRoom(FireBaseAuthentication.emailID, email).then((value){  
        Navigator.of(context).push(MaterialPageRoute(builder: (context){
          return CalenderPage(calendarController: ChatSection.calendarController, productID: productID??"", name: title, image: image, price: price, chatRoomID: value, reciverEmail: email);
          }  ));
        });
    }, backgroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)), child: const Icon(Icons.schedule_outlined)):null,
    );
  }


}


class Favourites{
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;

static Future<bool> exist(productID)async{ 
  final docRef = fireStore.collection('userData').doc(FireBaseAuthentication.emailID).collection("favorateCollection").doc("favorate");
  final data =  await docRef.get(); 
  final data0 = data.data()?.keys.toList();
  
  bool result = data0?.contains(productID)??false;
  return result;
}

static Future<List?> getList()async{ 
  final docRef = fireStore.collection("userData").doc(FireBaseAuthentication.emailID).collection("favorateCollection").doc("favorate");
  final snapShot = await docRef.get();
  final favorates = snapShot.data()?.keys.toList();
  print(favorates);
  return favorates ;
}

static Future<void> add(String? productID)async{ if(productID== null){return null;}
final docRef = fireStore.collection("userData").doc(FireBaseAuthentication.emailID).collection("favorateCollection");
await docRef.doc("favorate").set({productID:null}, SetOptions(merge: true));
}

static Future<void> delete(productID)async{
  final docRef = fireStore.collection("userData").doc(FireBaseAuthentication.emailID).collection("favorateCollection").doc("favorate");
  await docRef.set({productID:FieldValue.delete()}, SetOptions(merge: true));
}
}

class ImageCard extends StatefulWidget {
  const ImageCard({
    super.key,
    required this.image,
    required this.productID
  });

  final String image;
  final String? productID;

  @override
  State<ImageCard> createState() => _ImageCardState();
}

class _ImageCardState extends State<ImageCard> {
  bool isFavorate = false;
  void favoriteToggle()async{
    if(isFavorate){await Favourites.delete(widget.productID).then((value){  isFavorate = !isFavorate; setState((){isFavorate;});  });}
    else{await Favourites.add(widget.productID).then((value){ isFavorate = !isFavorate; setState((){isFavorate;}); });}
  
  }

  initFunction()async{isFavorate = await Favourites.exist(widget.productID);
  setState((){  isFavorate;  });
  }

  @override
  void initState() {  initFunction(); super.initState();  }

  @override
  Widget build(BuildContext context) {
    return Card(clipBehavior: Clip.hardEdge, child: GestureDetector(onTap: (){favoriteToggle();}, child: Badge( label: Icon(isFavorate?Ionicons.heart:Ionicons.heart_outline, color:isFavorate?Colors.red:Colors.black , size: 30,), alignment: Alignment.topRight, largeSize: 50, backgroundColor: Colors.transparent,  child: Image.network(widget.image, fit: BoxFit.fitWidth,))));
  }
}
class ContactCard extends StatelessWidget {
  const ContactCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(aspectRatio: 2.81, child: Container( decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
       margin: const EdgeInsets.fromLTRB(0, 3, 0, 0), padding: const EdgeInsets.all(15), 
       child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text('Location', style: TextStyle(color: Colors.grey[850], fontSize: 20, fontWeight: FontWeight.normal ))],),));
  }
}



class DescriptionCard extends StatelessWidget {
  const DescriptionCard({
    super.key,
    required this.description,
  });

  final String description;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(aspectRatio: 3, child: //Container( decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
    Card( surfaceTintColor: Colors.transparent, color: Colors.white,
      child:Padding(  padding: const EdgeInsets.all(15), 
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(AppLocalizations.of(context)!.tagDescription, style: TextStyle(color: Colors.grey[850], fontSize: 20, fontWeight: FontWeight.normal )), 
        Text(description, style: const TextStyle(fontSize: 12, color: Colors.black54, overflow: null), )]))));
  }
}



class TitleCard extends StatelessWidget {
    final double rating;
    final int reviews;
    final String? productID;
    final String title;
    final String price;
    final String? sellPrice;
    final String location;
    final String email;

  const TitleCard({
    super.key,
    this.sellPrice,
    required this.rating,
    required this.reviews,
    required this.productID,
    required this.title,
    required this.price,
    required this.location,
    required this.email, 
  });


  //final int rating = 0;
  

  @override
  Widget build(BuildContext context) {    print("titleCard:- sellPrice: $sellPrice");
    return AspectRatio(aspectRatio: 2.4, 
      // child: Container( decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
      // padding: const EdgeInsets.all(15), 
      
      child:
      Card( surfaceTintColor: Colors.transparent, color: Colors.white,
        child: Padding( 
          padding: const EdgeInsets.all(15), 
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceEvenly,  children: [
          AutoSizeText(title, style: TextStyle(color: Colors.grey[850], fontSize: 22, fontWeight: FontWeight.normal ),), 
          //Text('\u20B9 $price', style: TextStyle(color: Colors.grey[850], fontSize: 20, fontWeight: FontWeight.w500 ),),
          RichText(text: TextSpan(children: [
             TextSpan(text: '\u20B9 $price', style: TextStyle(color: Colors.grey[850], fontSize: 20, fontWeight: FontWeight.w500 ),),
             const TextSpan(text: ' / Day', style: TextStyle(color: Colors.grey)),
             if(sellPrice!=null)...[ TextSpan(text: " (Selling Price: $sellPrice)", style: const TextStyle(color: Colors.grey,))],
               ])),
          Row(children: [
            RatingBar(itemPadding: const EdgeInsets.all(1),ignoreGestures:true, allowHalfRating:true, initialRating:rating.toDouble(), itemSize:20, ratingWidget: RatingWidget(full: const Icon(Ionicons.star, color: Colors.amber,), half: const Icon(Ionicons.star_half, color: Colors.amber,), empty: const Icon(Ionicons.star_outline, color: Colors.amber,)), onRatingUpdate: (value){}),
            Padding(padding: const EdgeInsets.fromLTRB(4, 0, 4, 0), child: Text(  rating.toString().replaceRange(3, null, "")  , style: const TextStyle(fontSize: 16,  color: Colors.amber),),),
            
            Padding(padding: const EdgeInsets.fromLTRB(10, 0, 4, 0),
            child: InkWell( 
              onTap: (){Navigator.of(context).push(MaterialPageRoute(builder: (context){return ReviewAndRatingPage(productID: productID, email: email,);}));},
              child: Text("($reviews reviews)", style: TextStyle(decoration: TextDecoration.underline,
               decorationColor: Colors.indigo[700], color: Colors.indigo[700] ),),),)
    
          ],),
          Text(email,  style: const TextStyle(color: Colors.black38, overflow: TextOverflow.ellipsis), ), //maxFontSize: 12, minFontSize:10,
          //Text(location,  style: const TextStyle(color: Colors.black38, overflow: TextOverflow.ellipsis), ), //maxFontSize: 12, minFontSize:10,
          ],),
        ),
      ));
      //);
  }
}

class AddressCard extends StatelessWidget {final String address;
  const AddressCard({super.key,required this.address });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(aspectRatio: 3, child: Card( surfaceTintColor: Colors.transparent, color: Colors.white, 
    child: Padding(padding: const EdgeInsets.all(15), 
    child: Column( crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [ 
      Text(AppLocalizations.of(context)!.tagAddress, style: TextStyle(color: Colors.grey[850], fontWeight: FontWeight.normal, fontSize: 20),),
      Text(address, style: const TextStyle(fontSize: 12, color: Colors.black54, overflow: null), )
    ],),),),);
  }
}