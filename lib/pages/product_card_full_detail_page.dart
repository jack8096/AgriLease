import 'package:agrilease/login_api.dart';
import 'package:agrilease/pages/chats.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class FullProductDetail extends StatelessWidget {final Color? appBarBackGroundColor; final List<Color> gradientColor; final String image; final String price; final String title; final String description; final String email;  final String contact; final String location;
  const FullProductDetail({super.key,required this.appBarBackGroundColor, required this.gradientColor,  required  this.image, required this.price, required this.title, required this.description, required this.email, required this.location, required this.contact,});
final  backgroundcolor = const Color.fromARGB(255, 255, 249, 255,);


  @override
  Widget build(BuildContext context) {
    return Scaffold( appBar: AppBar( backgroundColor: appBarBackGroundColor,
      //title: const Text('Full product detail page', style: TextStyle(color: Color.fromARGB(255, 255, 249, 255,)),),  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Container(  decoration: BoxDecoration( gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: gradientColor) ),
        child: ListView(padding: const EdgeInsets.only(left: 10, right: 10, top: 5,),
          children: [
            //AspectRatio(aspectRatio: 1.3, child: Container(height: 200, decoration: BoxDecoration( color: Colors.grey[850], borderRadius: BorderRadius.circular(4), border: Border.all(color: Colors.black12,)), child: AspectRatio(aspectRatio: 1.56, child: Image.network(image, fit: BoxFit.fitWidth,)), )),
            // AspectRatio(aspectRatio: 1.3, child: Card(color: Colors.black45, surfaceTintColor: Colors.transparent,  child: Padding(padding: const EdgeInsets.all(2.0),child: Card(clipBehavior: Clip.hardEdge, child: Image.network(image, fit: BoxFit.fitWidth,)),
            // )),),
            Card(clipBehavior: Clip.hardEdge, child: Image.network(image, fit: BoxFit.fitWidth,)),
            TitleCard(title: title, price: price, location: location, email: email,),//title price 
            //const Divider(color: Colors.black45, thickness: 1, indent: 8, endIndent: 8,),
            DescriptionCard(description: description),// description
            AddressCard(address: location,),
            
          ],
        ),
      ),



    bottomNavigationBar: SafeArea(child: Container( color: Colors.white,
      child: AspectRatio(aspectRatio: 5.85, child:Padding( padding: const EdgeInsets.all(8),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
          children: [ OutlinedButton( style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.black),   shape: MaterialStateProperty.all<RoundedRectangleBorder>( RoundedRectangleBorder( borderRadius: BorderRadius.circular(6.0),)),
           ),
                        
                        onPressed: ()async{ 
                          print("pressed chat button");
                          if(!FireBaseAuthentication.isSignedIn){
                            await FireBaseAuthentication.signInWithGooggle(); try{print("us: ${FireBaseAuthentication.emailID} them: ${email} ");}catch(e){print(e);}
                            }else{ try{print("us: ${FireBaseAuthentication.emailID} them: ${email} ");
                            await Chats().createChatRoom(FireBaseAuthentication.emailID, email).then((value){  
                              Navigator.of(context).push(MaterialPageRoute(builder: (context){return ChatSection(roomID: value, reciverEmail: email);}));
                               });
                            }catch(e){print(e);} } 
                            
                            
                        
                        
                        
                        }, child: const Text('Chat') ),
                      ElevatedButton( style: ButtonStyle( backgroundColor: MaterialStateProperty.all<Color>(Colors.black), foregroundColor: MaterialStateProperty.all<Color>(Colors.white),  shape: MaterialStateProperty.all<RoundedRectangleBorder>( RoundedRectangleBorder( borderRadius: BorderRadius.circular(6.0),))),
                        onPressed: (){ launchUrl(Uri(scheme: 'tel', path: contact)); }, child: const Text("Call")),
           ]            
        ),
      ) ,),
    )),
    );
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
    return AspectRatio(aspectRatio: 2, child: //Container( decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
    Card( surfaceTintColor: Colors.transparent, color: Colors.white,
      child:Padding(  padding: const EdgeInsets.all(15), 
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text('Description', style: TextStyle(color: Colors.grey[850], fontSize: 20, fontWeight: FontWeight.normal )), 
        Text(description, style: const TextStyle(fontSize: 12, color: Colors.black54, overflow: null), )]))));
  }
}



class TitleCard extends StatelessWidget {
  const TitleCard({
    super.key,
    required this.title,
    required this.price,
    required this.location,
    required this.email,
  });

  final String title;
  final String price;
  final String location;
  final String email;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(aspectRatio: 2.5, 
      // child: Container( decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
      // padding: const EdgeInsets.all(15), 
      child:
      Card( surfaceTintColor: Colors.transparent, color: Colors.white,
        child: Padding( 
          padding: const EdgeInsets.all(15), 
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceEvenly,  children: [
          AutoSizeText(title, style: TextStyle(color: Colors.grey[850], fontSize: 22, fontWeight: FontWeight.normal ),), 
          Text('\u20B9 $price', style: TextStyle(color: Colors.grey[850], fontSize: 20, fontWeight: FontWeight.w500 ),),
          Text(email,  style: const TextStyle(color: Colors.black38, overflow: TextOverflow.ellipsis), ), //maxFontSize: 12, minFontSize:10,
          Text(location,  style: const TextStyle(color: Colors.black38, overflow: TextOverflow.ellipsis), ), //maxFontSize: 12, minFontSize:10,
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
    return AspectRatio(aspectRatio: 2, child: Card( surfaceTintColor: Colors.transparent, color: Colors.white, 
    child: Padding(padding: const EdgeInsets.all(15), 
    child: Column( crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [ 
      Text("Address", style: TextStyle(color: Colors.grey[850], fontWeight: FontWeight.normal, fontSize: 20),),
      Text(address, style: const TextStyle(fontSize: 12, color: Colors.black54, overflow: null), )
    ],),),),);
  }
}