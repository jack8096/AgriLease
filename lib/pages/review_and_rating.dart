import 'package:agrilease/login_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ionicons/ionicons.dart';

class ReviewAndRatingPage extends StatefulWidget {final String? productID; final String email;
  const ReviewAndRatingPage({super.key, required this.productID, required this.email});

  @override
  State<ReviewAndRatingPage> createState() => _ReviewAndRatingPageState();
}

class _ReviewAndRatingPageState extends State<ReviewAndRatingPage> {
  bool isLoading = true;
  Map<String, String> reviews = {};
  List<String> reviewer = [];

Future<void> initFunction ()async { 
  final Map<String,String>? reviewData =  await RatingsAndReviews(productID: widget.productID??"Null").getReviews;
  print("reviewData: $reviewData");
  if(reviewData==null){return;}
  reviews.addAll(reviewData);
  reviewer.addAll(reviewData.keys);
  setState((){  isLoading = false;  });
  
  }

@override
  void initState() {
    if(widget.productID !=null){
      initFunction();
    }
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("review section"), backgroundColor: Colors.white,),
      body: Container(color: Colors.white,
      child: isLoading?
      const Center(child: Text("loading..."))
      :(reviews.isNotEmpty)?ListView.builder( itemCount: reviews.length, itemBuilder: (context, item){return ReviewCard(reviewer: reviewer[item], review: reviews[reviewer[item]]??"Null"); })
      :const Center(child: (Text("No Reviews to Show", style: TextStyle(fontSize: 16),))),),
      // Column(children: [
      //   Center(child: FilledButton(onPressed: ()async{
      //     if(widget.productID!=null){
      //     print("productID: ${widget.productID}");
      //     final Map<String, String>? data = await RatingsAndReviews(productID: widget.productID!).getReviews;
      // }}, child: const Text("test0")),)
      // ],),
      floatingActionButton: (FireBaseAuthentication.emailID.replaceAll(" ", "") != widget.email.replaceAll(" ", ""))?   FloatingActionButton(onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (context){return ReviewAndRatingFormPage(productID: widget.productID,);}));}, backgroundColor: Colors.white, child: const Icon(Ionicons.pencil),)
      :null
    );
  }
}

class ReviewCard extends StatelessWidget { final String reviewer; final String review;
  const ReviewCard({super.key, required this.reviewer, required this.review});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Card( color: Colors.white, surfaceTintColor: Colors.transparent,
        child: Container( padding: const EdgeInsets.all(8.0), constraints: const BoxConstraints(minHeight: 100),
        child: Column( crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          Text("Reviewer: $reviewer", textAlign: TextAlign.left,),
          Text("\nReview: $review"),
        ],),
      ),),
    );
  }
}

class ReviewAndRatingFormPage extends StatelessWidget {final String? productID;
  const ReviewAndRatingFormPage({super.key, required this.productID});

  //final TextEditingController reviewController = TextEditingController();
  static double rating = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,  surfaceTintColor: Colors.transparent,),
      body: Container( padding: const EdgeInsets.all(20), color: Colors.white,
        child: ListView( children: const [

            Padding(padding: EdgeInsets.all(8), child: Text("Rate", style: TextStyle(color: Colors.black54, fontSize: 16),)),
            RatingCard(),
            Padding(padding: EdgeInsets.all(8), child: Text("Review", style: TextStyle(color: Colors.black54, fontSize: 16),),),
            ReviewForm(),

        ],),
      ),
      floatingActionButton: FloatingActionButton(
        
        onPressed: ()async{ 
          if(productID ==null){return;}
          print("productID: $productID, rating: ${RatingCard.rating}, review: ${ReviewForm.reviewController.text}");
          if(RatingCard.rating != 0){  await RatingsAndReviews(productID: productID!).setRating(RatingCard.rating).then((value){  RatingCard.rating = 0;  } );   }
            
          if(ReviewForm.reviewController.text !=""){  await RatingsAndReviews(productID: productID!).setReview(ReviewForm.reviewController.text).then((value){  ReviewForm.reviewController.text = "";   } ); }

          Navigator.of(context).popUntil( ModalRoute.withName('/')   );
        
          },
      
      
       backgroundColor: Colors.black, child: const Icon(Ionicons.checkmark, color: Colors.white,),),
    );
  }
}

class RatingCard extends StatelessWidget {  //final int rating;
  const RatingCard({ 
    super.key, 
    //required this.rating
  });
  static double rating = 0;
  @override
  Widget build(BuildContext context) {
    return Card( color: Colors.white, surfaceTintColor: Colors.transparent,
      child: AspectRatio(aspectRatio: 3, child: Center(
      child: RatingBar( onRatingUpdate: (value){ rating = value;  }, itemSize: 25,  
      ratingWidget: RatingWidget(full: const Icon(Ionicons.star, color: Colors.amber,), half: const Icon(Ionicons.star_half, color: Colors.amber,), empty: const Icon(Ionicons.star_outline, color: Colors.amber,)),))),);
  }
}

class ReviewForm extends StatelessWidget { //final TextEditingController reviewController;
  const ReviewForm({super.key, //required this.reviewController
  });

  static final TextEditingController reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    
    return Column(
      children: [
        Card( color: Colors.white, surfaceTintColor: Colors.transparent,
              child: AspectRatio( aspectRatio: 1.5,child: Column(children: [
                  Padding(padding: const EdgeInsets.all(8), child: TextFormField(
                    controller: reviewController,
                    maxLines: 5, maxLength: 200,
                    cursorColor: Colors.black,
                    
                    decoration: InputDecoration(  filled: true, fillColor: Colors.grey[50], hintText: "(Optional)", border: InputBorder.none ),
                    ))
                ],),
              ),
            ),
      ],
    );
  }

  
}

class RatingsAndReviews {final String productID;
  RatingsAndReviews({required this.productID});
final FirebaseFirestore firebaseInstance = FirebaseFirestore.instance;

  Future<List<dynamic>?> ratingList() async{
    final  data = await firebaseInstance.collection("published_ad_ratings_reviews").doc(productID).get();
    if(data.data() ==null) {return null;}
    final List<dynamic> list = data.data()!.values.toList()[0]??0;
    
    return list;
    
  }

   Future<double> get rating async{
    final List<dynamic>? list = await ratingList();
    if(list == null){print("rating: 0"); return 0;}
    final int length = list.length;
    double value = 0;
    for(dynamic rate in list){  value = value+rate; }
    double result = value/length;
    print("rating: $result");
    return result;

  }
  
  Future<void> setRating(double rate)async{
    final List<dynamic> list = await ratingList()??[];
    list.add(rate);
    await firebaseInstance.collection("published_ad_ratings_reviews").doc(productID).set({"rating":list, }, SetOptions(merge: true));
  }

  Future<void> setReview(String review)async{
    await firebaseInstance.collection("published_ad_ratings_reviews").doc(productID)
    .collection("reviews").doc(FireBaseAuthentication.emailID).set({review:null},);
  }

  Future<int> get noOfReviews async{
    final QuerySnapshot<Map<String, dynamic>> query = await firebaseInstance.collection("published_ad_ratings_reviews").doc(productID).collection("reviews").get();
    return query.docs.length;
    
  }

  Future<Map<String, String>?> get getReviews async{
    final QuerySnapshot<Map<String, dynamic>> query = await firebaseInstance.collection("published_ad_ratings_reviews").doc(productID).collection("reviews").get();
    
    Map<String, String> reviews = {};
    final docs = query.docs;
    for(QueryDocumentSnapshot<Map<String, dynamic>> doc in docs ){
      final String review = doc.data().keys.toString().replaceFirst("(", "").replaceFirst(")", "");
      final String reviewer = doc.id;
      print("reviewer:$reviewer, review:$review");
      reviews[reviewer] = review;
    }
    return reviews;
  }
}

