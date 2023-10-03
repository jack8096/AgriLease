import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;


class FullProductDetail extends StatelessWidget {final String image; final String price; final String title; final String description; final String contact; final String location;
  const FullProductDetail({super.key, required  this.image, required this.price, required this.title, required this.description, required this.location, required this.contact,});
final  backgroundcolor = const Color.fromARGB(255, 255, 249, 255,);


  @override
  Widget build(BuildContext context) {
    return Scaffold( appBar: AppBar(title: const Text('Full product detail page', style: TextStyle(color: Color.fromARGB(255, 255, 249, 255,)),),  backgroundColor: Theme.of(context).colorScheme.inversePrimary,),
      body: Container(color: backgroundcolor,
        child: ListView(padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
          children: [
            AspectRatio(aspectRatio: 1.3, child: Container(height: 200, decoration: BoxDecoration( color: Colors.grey[850], borderRadius: BorderRadius.circular(4), border: Border.all(color: Colors.black12,)), child: AspectRatio(aspectRatio: 1.56, child: Image.network(image, fit: BoxFit.fitWidth,)), )),
            TitleCard(title: title, price: price, location: location, ),//title price 
            DescriptionCard(description: description),// description
            
          ],
        ),
      ),



    bottomNavigationBar: SafeArea(child: Container( color: backgroundcolor,
      child: AspectRatio(aspectRatio: 5.85, child:Padding( padding: const EdgeInsets.all(8),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
          children: [ OutlinedButton( style: ButtonStyle(shape: MaterialStateProperty.all<RoundedRectangleBorder>( RoundedRectangleBorder( borderRadius: BorderRadius.circular(6.0),)),),
                        onPressed: (){  }, child: Text('Chat') ),
                      ElevatedButton( style: ButtonStyle( backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor), foregroundColor: MaterialStateProperty.all<Color>(Colors.white),  shape: MaterialStateProperty.all<RoundedRectangleBorder>( RoundedRectangleBorder( borderRadius: BorderRadius.circular(6.0),))),
                        onPressed: (){ UrlLauncher.canLaunchUrl(Uri(scheme: 'tele', path:contact) ); }, child: const Text("Call")),
           ]
        //      AspectRatio(aspectRatio: 2.5, child: Container( alignment: Alignment.center, decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color.fromARGB(255, 106, 63, 183), width: 2), borderRadius: const BorderRadius.all(Radius.circular(4)),),
        // child: Text('Chat', style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w600),),),),
        // AspectRatio(aspectRatio: 2.5, child: Container( alignment: Alignment.center, decoration:  BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: const BorderRadius.all(Radius.circular(4)),),
        // child: const Text('Call', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),),),
            
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
    return AspectRatio(aspectRatio: 2, child: Container( decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
      margin: const EdgeInsets.fromLTRB(0, 3, 0, 0), padding: const EdgeInsets.all(15), 
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text('Description', style: TextStyle(color: Colors.grey[850], fontSize: 20, fontWeight: FontWeight.normal )), 
        Expanded(child: Text(description, style: const TextStyle(fontSize: 12, color: Colors.black54), ),)])));
  }
}



class TitleCard extends StatelessWidget {
  const TitleCard({
    super.key,
    required this.title,
    required this.price,
    required this.location,
  });

  final String title;
  final String price;
  final String location;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(aspectRatio: 2.5, child: Container( decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
      margin: const EdgeInsets.fromLTRB(0, 3, 0, 0),  padding: const EdgeInsets.all(15), 
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisAlignment: MainAxisAlignment.spaceEvenly,  children: [
      AutoSizeText(title, style: TextStyle(color: Colors.grey[850], fontSize: 22, fontWeight: FontWeight.normal ),), 
      Text('\u20B9 $price', style: TextStyle(color: Colors.grey[850], fontSize: 20, fontWeight: FontWeight.w500 ),),
      Expanded(child: AutoSizeText(location, maxLines: 2, maxFontSize: 12, minFontSize:10, style: const TextStyle(color: Colors.black38), ),)
      ],)));
  }
}