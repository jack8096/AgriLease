// ignore_for_file: unnecessary_string_interpolations

import 'dart:io';

import 'package:agrilease/login_api.dart';
import 'package:agrilease/pages/my_adds.dart';
import 'package:agrilease/pages/recent_section.dart';
import 'package:agrilease/recent_section_api.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';


class UploadData {



  static late XFile selectedImage;
  static bool isImageSelected = false;
  static late String rtdbRef;


 static void write( ProductDetail productDetail ) async{ 

final FirebaseDatabase database = await DatabaseInitiation().recentSectionData();

final productDetailData = {
  'title':productDetail.title,
  'price':productDetail.price,
  'description':productDetail.description,
  'location':productDetail.location,
  'contact':productDetail.contact,
  'image':productDetail.image,
  'email':productDetail.email,
  };

DatabaseReference value =  database.ref().push();
//try{
await value.set(productDetailData);
print("productDetailID : ${value.key}");
FireStore.write(value.key??'none');
//}catch(e){print(e);}

}

static selectImage()async{
    ImagePicker picker = ImagePicker();
  dynamic image = await picker.pickImage(source: ImageSource.gallery);
  try{selectedImage = image; isImageSelected=true; return true; } catch(e){print(e);}
  return false;
}

static void uploadImage()async{
  final storageRef = FirebaseStorage.instance.ref();

  final imageRef = storageRef.child(selectedImage.name);

  try {
    File file = File(selectedImage.path);
    await imageRef.putFile(file).whenComplete(() => null);
  } catch (e) {  print(e);  }
}
  
}



class AddAdSecton extends StatefulWidget {
  const AddAdSecton({super.key});

  @override
  State<AddAdSecton> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<AddAdSecton> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(padding: const EdgeInsets.all(10), 
      child: ListView( children: [InputInfoSecton(),] )
      ),

    );
  }
}



// ignore: must_be_immutable
class InputInfoSecton extends StatefulWidget {
  const InputInfoSecton({super.key});

  @override
  State<InputInfoSecton> createState() => _InputInfoSectonState();
}

class _InputInfoSectonState extends State<InputInfoSecton> {
TextEditingController title = TextEditingController();
TextEditingController price = TextEditingController();
TextEditingController description = TextEditingController();
TextEditingController location = TextEditingController();
TextEditingController contact = TextEditingController();





void submitForm(){
var validate = _formKey.currentState!.validate();
print('form is $validate');
if( _formKey.currentState!.validate() & UploadData.isImageSelected ){
   final productDetail =   ProductDetail(email:FireBaseAuthentication.emailID, title: title.text, price: price.text, description: description.text, image: UploadData.selectedImage.name, location: location.text, contact: contact.text );
   UploadData.uploadImage();
   UploadData.write(productDetail);
}}


void setStateisImageSelected()async{ await UploadData.selectImage();  setState(() { UploadData.isImageSelected; }); }


final _formKey = GlobalKey<FormState>();

bool titleValidate = false;
bool priceValidate = false;
bool desValidate = false;
bool locValidate = false;
bool contValidate = false;

  @override
  Widget build(BuildContext context) {
return Form( key: _formKey,
child: Column(  crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
      labelText("Ad's Title"),  TextFormField( decoration: inputDecoration(titleValidate? Colors.green:Colors.white),  controller: title,       validator: (value) { if(value!=''   ){ setState(() {titleValidate=true;});              return null; }else{ setState(() {titleValidate=false;}); return "Enter Ad's Title"; }  }, ), //value.runtimeType==String);
      labelText("Price"),       TextFormField( decoration: inputDecoration(priceValidate? Colors.green:Colors.white),  controller: price,       validator: (value) { try {int.parse(value??"None"); setState((){priceValidate = true;});return null; } catch (e) { setState((){priceValidate = false;}); } return 'Enter a Valid Number'; }, ), //value.runtimeType==String);
      labelText("Description"), TextFormField( decoration: inputDecoration(desValidate?   Colors.green:Colors.white),  controller: description, validator: (value) { if(value!='' ){ setState(() {desValidate=true;});                  return null; }else{ setState(() {desValidate=false;}); } return 'Enter Description';}, ), //value.runtimeType==String);
      labelText("Locaton"),     TextFormField( decoration: inputdecoration(locValidate?   Colors.green:Colors.white),  controller: location,    validator: (value) { if(value!=''            ){ setState(() {locValidate=true;});       return null; }else{ setState(() {locValidate=false;}); } return 'Enter a Valid Location'; }, ), //value.runtimeType==String);
      labelText("Contact"),     TextFormField( decoration: inputDecoration(contValidate?  Colors.green:Colors.white),  controller: contact,     validator: (value) { try {int.parse(value??"None"); setState((){contValidate = true;}); return null; } catch (e) { setState((){contValidate = false;}); } return 'Enter Contact Nummber'; }, ), //value.runtimeType==String);
      Row( mainAxisAlignment: MainAxisAlignment.start,
        children: [selectImageButton(), Icon(Ionicons.checkmark_circle_outline, color: UploadData.isImageSelected?Colors.green:Colors.white )],),
      submitbutton() // disable button till every thing is valid
      ],));
  }

  InputDecoration inputDecoration(conditionalStatment) => InputDecoration(suffixIcon: const Icon(Ionicons.checkmark_circle_outline), suffixIconColor: conditionalStatment, contentPadding: const EdgeInsets.all(8), border: const OutlineInputBorder(), focusedBorder: const OutlineInputBorder(borderSide: BorderSide(width: 2, color: Colors.black))  );

  Padding selectImageButton() {
    return Padding( padding: const EdgeInsets.all(8.0),
      child: OutlinedButton.icon( onPressed: (){ setStateisImageSelected();   }, label: const Text('Select Image'), icon: const Icon(Ionicons.camera_sharp,),),
    );
  }

  Padding submitbutton() {return Padding( padding: const EdgeInsets.all(8.0),
    child: Center(child: OutlinedButton( style:ButtonStyle(shape: MaterialStateProperty.all<RoundedRectangleBorder>( RoundedRectangleBorder( borderRadius: BorderRadius.circular(6.0),))) ,
        onPressed: () { submitForm(); //_formKey.currentState!.validate() ;      //UploadData.uploadImage(); submitForm();
         }, child: const Text("Publish Ad"), ),
      ),
  );
  }



  InputDecoration inputdecoration(Color? checkColor) => InputDecoration(suffixIcon: const Icon(Ionicons.checkmark_circle_outline), suffixIconColor: checkColor, contentPadding: const EdgeInsets.all(8), border: const OutlineInputBorder(), focusedBorder: const OutlineInputBorder(borderSide: BorderSide(width: 2, color: Colors.black))  );

  Padding labelText(final String text) => Padding(padding: const EdgeInsets.fromLTRB(0, 8, 8, 8), child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),);
}