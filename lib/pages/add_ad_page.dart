// ignore_for_file: unnecessary_string_interpolations

import 'dart:io';

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

static void write(ProductDetail productDetail) async{ //ProductDetail data

final FirebaseDatabase database = await DatabaseInitiation().recentSectionData();

final dataPath = {
  'title':productDetail.title,
  'price':productDetail.price,
  'description':productDetail.description,
  'location':productDetail.location,
  'contact':productDetail.contact,
  'image':'NONE',
  };

await database.ref().push().set(dataPath);

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
  InputInfoSecton({super.key});

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
print('form validate $validate' );
final productDetail =   ProductDetail(title: title.text, price: price.text, description: description.text, image: 'None', location: location.text, contact: contact.text );
print(productDetail);
//if(UploadData.isImageSelected){UploadData.uploadImage();}
//UploadData.write(productDetail);
}


void setStateisImageSelected()async{
  await UploadData.selectImage();
  setState(() { UploadData.isImageSelected; });
}


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
      labelText("Ad's Title"),  TextFormField( decoration: InputDecoration(suffixIcon: const Icon(Ionicons.checkmark_circle_outline), suffixIconColor: titleValidate? Colors.green:Colors.white, contentPadding: const EdgeInsets.all(8), border: const OutlineInputBorder(), focusedBorder: const OutlineInputBorder(borderSide: BorderSide(width: 2, color: Colors.black))  ),  validator: (value) { if(value!=''   ){ setState(() {titleValidate=true;});}else{ setState(() {titleValidate=false;}); } return null; }, ), //value.runtimeType==String);
      labelText("Price"),       TextFormField( decoration: InputDecoration(suffixIcon: const Icon(Ionicons.checkmark_circle_outline), suffixIconColor: priceValidate? Colors.green:Colors.white, contentPadding: const EdgeInsets.all(8), border: const OutlineInputBorder(), focusedBorder: const OutlineInputBorder(borderSide: BorderSide(width: 2, color: Colors.black))  ),  validator: (value) {    try {int.parse(value??"None"); setState((){priceValidate = true;}); } catch (e) { setState((){priceValidate = false;}); } return null; }, ), //value.runtimeType==String);
      labelText("Description"), TextFormField( decoration: InputDecoration(suffixIcon: const Icon(Ionicons.checkmark_circle_outline), suffixIconColor: desValidate? Colors.green:Colors.white, contentPadding: const EdgeInsets.all(8), border: const OutlineInputBorder(), focusedBorder: const OutlineInputBorder(borderSide: BorderSide(width: 2, color: Colors.black))  ),  validator: (value) { if(value!='' ){ setState(() {desValidate=true;});}else{ setState(() {desValidate=false;}); } return null;}, ), //value.runtimeType==String);
      labelText("Locaton"),     TextFormField( decoration: InputDecoration(suffixIcon: const Icon(Ionicons.checkmark_circle_outline), suffixIconColor: locValidate? Colors.green:Colors.white, contentPadding: const EdgeInsets.all(8), border: const OutlineInputBorder(), focusedBorder: const OutlineInputBorder(borderSide: BorderSide(width: 2, color: Colors.black))  ),  validator: (value) { if(value!=''            ){ setState(() {locValidate=true;});}else{ setState(() {locValidate=false;}); } return null; }, ), //value.runtimeType==String);
      labelText("Contact"),     TextFormField( decoration: InputDecoration(suffixIcon: const Icon(Ionicons.checkmark_circle_outline), suffixIconColor: contValidate? Colors.green:Colors.white, contentPadding: const EdgeInsets.all(8), border: const OutlineInputBorder(), focusedBorder: const OutlineInputBorder(borderSide: BorderSide(width: 2, color: Colors.black))  ),  validator: (value) { try {int.parse(value??"None"); setState((){contValidate = true;}); } catch (e) { setState((){contValidate = false;}); } return null; }, ), //value.runtimeType==String);
      Row( mainAxisAlignment: MainAxisAlignment.start,
        children: [selectImageButton(), Icon(Ionicons.checkmark_circle_outline, color: UploadData.isImageSelected?Colors.green:Colors.white )],),
      submitbutton() // disable button till every thing is valid
      //Publish ADD
      ],));
  }

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