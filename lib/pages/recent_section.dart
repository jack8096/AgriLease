import 'package:flutter/material.dart';

class RecentSection extends StatelessWidget {
  const RecentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding( padding: const EdgeInsets.all(5),
        child: GridView.count(crossAxisCount: 2, mainAxisSpacing: 5, crossAxisSpacing: 5, childAspectRatio: 0.7,
        children: [ProductCard(),ProductCard(),ProductCard(),ProductCard()],
        ),
      ),
    );
  }
}




class ProductCard extends StatelessWidget {
ProductCard({super.key});

final foregroundColor = Colors.grey[400];
final backgroundColor = Colors.grey[200];


  @override
  Widget build(BuildContext context) {
    return  Container( height: 200,  color: backgroundColor, //width: 150,
       child: Column( mainAxisAlignment: MainAxisAlignment.spaceEvenly,
         children: [ 
         Container( height: 100, width: 130, color: Colors.white, ),  
         Container( height: 20, width: 130, color: foregroundColor, child: const Text('Price'),),  
         Container( height: 20, width: 130, color: foregroundColor, child: const Text('Title'),),  
         Container( height: 20, width: 130, color: foregroundColor, child: const Text('Description'),),  
       ],),
     );}
}