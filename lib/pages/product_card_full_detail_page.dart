import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class FullProductDetail extends StatelessWidget {final String image; final String price; final String title; final String description;
  const FullProductDetail({super.key, required  this.image, required this.price, required this.title, required this.description});
final  backgroundcolor = const Color.fromARGB(255, 255, 249, 255,);
  @override
  Widget build(BuildContext context) {
    return Scaffold( appBar: AppBar(title: const Text('Full product detail page', style: TextStyle(color: Color.fromARGB(255, 255, 249, 255,)),),  backgroundColor: Theme.of(context).colorScheme.inversePrimary,),
      body: Container(color: backgroundcolor,
        child: ListView(padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
          children: [
            Expanded(flex:3, child: Container( decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(4),), child: AspectRatio(aspectRatio: 1.56, child: Image.network(image, fit: BoxFit.fitWidth,)), )),
            Expanded(flex:1, child: TitleCard(title: title, price: price)),//title price 
            Expanded(flex:1, child: DescriptionCard(description: description),),// description
            const Expanded(flex:1, child: ContactCard(),),//contact
          ],
        ),
      ),
    bottomNavigationBar: SafeArea(child: Container( color: backgroundcolor,
      child: AspectRatio(aspectRatio: 5.85, child:Padding( padding: const EdgeInsets.all(8),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
          children: [ AspectRatio(aspectRatio: 2.5, child: Container( alignment: Alignment.center, decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black, width: 2), borderRadius: const BorderRadius.all(Radius.circular(4)),),
        child: const Text('Chat', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),),),),
        AspectRatio(aspectRatio: 2.5, child: Container( alignment: Alignment.center, decoration: const BoxDecoration(color: Colors.black, borderRadius: BorderRadius.all(Radius.circular(4)),),
        child: const Text('Call', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),),),
            ],
        ),
      ) ,),
    )),
    );
  }

  AspectRatio custombutton(final String text) {
    return AspectRatio(
      aspectRatio: 2.5,
      child: Container( alignment: Alignment.center,
        decoration: const BoxDecoration(color: Colors.black, borderRadius: BorderRadius.all(Radius.circular(4)),),
        child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
      ),
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
       child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [Text('Location', style: TextStyle(color: Colors.grey[630], fontSize: 25, fontWeight: FontWeight.w300 ))],),));
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
    return AspectRatio(aspectRatio: 2.81, child: Container( decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
      margin: const EdgeInsets.fromLTRB(0, 3, 0, 0), padding: const EdgeInsets.all(15), 
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [Text('Description', style: TextStyle(color: Colors.grey[630], fontSize: 25, fontWeight: FontWeight.w300 )), AutoSizeText(description, style: TextStyle(color: Colors.grey[630], fontSize: 16, fontWeight: FontWeight.w400 ))],),));
  }
}

class TitleCard extends StatelessWidget {
  const TitleCard({
    super.key,
    required this.title,
    required this.price,
  });

  final String title;
  final String price;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(aspectRatio: 2.81, child: Container( decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
      margin: const EdgeInsets.fromLTRB(0, 3, 0, 0),  padding: const EdgeInsets.all(15), 
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [AutoSizeText(title, style: TextStyle(color: Colors.grey[630], fontSize: 28, fontWeight: FontWeight.w300 ),), Text('\u20B9 $price', style: TextStyle(color: Colors.grey[630], fontSize: 25, fontWeight: FontWeight.bold ),)],)));
  }
}