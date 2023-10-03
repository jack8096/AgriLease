import 'package:agrilease/pages/add_ad_page.dart';
import 'package:flutter/material.dart';

class MyAds extends StatefulWidget {
  const MyAds({super.key});

  @override
  State<MyAds> createState() => _MyAdsState();
}

class _MyAdsState extends State<MyAds> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AspectRatio(
        aspectRatio: 1.5,
        child: Container( margin: const EdgeInsets.all(5),padding: const EdgeInsets.all(10),  decoration:  BoxDecoration( 
          border: Border.all(color: Theme.of(context).primaryColor, width: 2), borderRadius: const BorderRadius.all(Radius.circular(6)) ),  child: Center(
          child: Column(children: [
            Expanded(child: Container( decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/publications.webp'), fit: BoxFit.fitHeight)), )),
            const Text("You haven't listed anything yet", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16), ),
            ],),),
        ),
      ),

      floatingActionButton: FilledButton( style: ButtonStyle( shape: MaterialStateProperty.all<RoundedRectangleBorder>( RoundedRectangleBorder( borderRadius: BorderRadius.circular(6.0),))),
      onPressed: (){Navigator.push(context,  MaterialPageRoute(builder: (context) {return AddAdSecton();}));}, 
      child: const Text('Add'),)
    );
  }
}