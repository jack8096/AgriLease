// ignore_for_file: unnecessary_string_interpolations

import 'dart:io';
//import 'dart:js_util';

import 'package:agrilease/login_api.dart';
import 'package:agrilease/pages/my_adds.dart';
import 'package:agrilease/pages/recent_section.dart';
import 'package:agrilease/recent_section_api.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UploadData {



  static late XFile selectedImage;
  static bool isImageSelected = false;
  static late String rtdbRef;


 static Future<String> write( ProductDetail productDetail ) async{ 

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
final key = await value.key;
print("Class UploadData void write var key: $key");
await value.set(productDetailData);
print("productDetailID : ${value.key}");
FireStore.write(value.key??'none');
//}catch(e){print(e);}
return key??"NONE";
}

static selectImage()async{
    ImagePicker picker = ImagePicker();
  dynamic image = await picker.pickImage(source: ImageSource.gallery);
  try{selectedImage = image; isImageSelected=true; return true; } catch(e){print(e);}
  return false;
}

static Future<bool> uploadImage()async{
  final storageRef = FirebaseStorage.instance.ref();

  final imageRef = storageRef.child(selectedImage.name);

  try {
    File file = File(selectedImage.path);
    await imageRef.putFile(file).whenComplete(() => true);
  } catch (e) {  print(e);  }
  return false;
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
      appBar: AppBar(backgroundColor: Colors.white, surfaceTintColor: Colors.transparent,),
      body: Container(padding: const EdgeInsets.all(10),  color: Colors.white,
      child: ListView( children: const [InputInfoSecton(),] )
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





Future<bool> submitForm()async{
var validate = _formKey.currentState!.validate();
print('form is $validate');
if( _formKey.currentState!.validate() & UploadData.isImageSelected ){
   final productDetail =   ProductDetail(email:FireBaseAuthentication.emailID, title: title.text, price: price.text, description: description.text, image: UploadData.selectedImage.name, location: location.text, contact: contact.text );
   await UploadData.uploadImage();
   final productDetailID = await UploadData.write(productDetail);
   final FirebaseDatabase rtdb = await DatabaseInitiation().recentSectionData();
   final DatabaseReference dbRef = rtdb.ref(productDetailID);
   final DataSnapshot snapShot = await dbRef.get();

   if(snapShot.value ==null){print(false); return false;}else{print(true); return true;}

}
return false;
}


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
child: Padding(padding: const EdgeInsets.all(20),
  child:   Column(  crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  
        children: [
  
        labelText(AppLocalizations.of(context)!.tagTitle),       TextFormField( decoration: inputDecoration(titleValidate? Colors.green:Colors.white),  controller: title,       validator: (value) { if(value!=''   ){ setState(() {titleValidate=true;});              return null; }else{ setState(() {titleValidate=false;}); return AppLocalizations.of(context)!.tagTitleErrorMSG; }  }, ), //value.runtimeType==String);
  
        labelText("${AppLocalizations.of(context)!.tagPrice} \u{20B9}"),       TextFormField( inputFormatters: [FilteringTextInputFormatter.digitsOnly], decoration: inputDecoration(  priceValidate? Colors.green:Colors.white),  controller: price,       validator: (value) { try {int.parse(value??"None"); setState((){priceValidate = true;});return null; } catch (e) { setState((){priceValidate = false;}); } return AppLocalizations.of(context)!.tagPriceErrorMSG; }, ), //value.runtimeType==String);
  
        labelText(AppLocalizations.of(context)!.tagDescription), TextFormField( decoration: inputDecoration(desValidate?   Colors.green:Colors.white),  controller: description, validator: (value) { if(value!='' ){ setState(() {desValidate=true;});                  return null; }else{ setState(() {desValidate=false;}); } return AppLocalizations.of(context)!.tagDescriptionErrorMSG;}, ), //value.runtimeType==String);
  
        labelText(AppLocalizations.of(context)!.tagLocation),     TextFormField( decoration: inputdecoration(locValidate?   Colors.green:Colors.white),  controller: location,    validator: (value) { if(value!=''            ){ setState(() {locValidate=true;});       return null; }else{ setState(() {locValidate=false;}); } return AppLocalizations.of(context)!.tagLocationErrorMSG; }, ), //value.runtimeType==String);
  
        labelText(AppLocalizations.of(context)!.tagContact),     TextFormField( inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10), ], decoration: inputDecoration(contValidate?  Colors.green:Colors.white),  controller: contact,     validator: (value) {  try { if(value!.length==10){ setState((){contValidate = true;});  return null;} } catch (e) { setState((){contValidate = false;}); } return AppLocalizations.of(context)!.tagContactErrorMSG; }, ), //value.runtimeType==String);
  
        Row( mainAxisAlignment: MainAxisAlignment.start,
  
          children: [selectImageButton(), Padding(padding: const EdgeInsets.all(8.0),
            child: Icon(Ionicons.checkmark_circle_outline, color: UploadData.isImageSelected?Colors.green:Colors.white ),
          )],),
  
        submitbutton() // disable button till every thing is valid
  
        ],),
));
  }

  InputDecoration inputDecoration(conditionalStatment) => InputDecoration( suffixIcon: const Icon(Ionicons.checkmark_circle_outline), suffixIconColor: conditionalStatment, contentPadding: const EdgeInsets.all(8), border: const OutlineInputBorder(), focusedBorder: const OutlineInputBorder(borderSide: BorderSide(width: 2, color: Colors.black))  );

  selectImageButton() {
    return Container(margin: const EdgeInsets.only(top: 10, bottom: 10), child: OutlinedButton.icon( onPressed: (){ setStateisImageSelected();   }, style: ButtonStyle(shape: MaterialStateProperty.all(const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))))), label: Text(AppLocalizations.of(context)!.tagSelectImage, style: const TextStyle(color: Colors.black),), icon: const Icon(Ionicons.camera_outline, color: Colors.black,),));
  }

  FilledButton submitbutton() {return FilledButton( style:ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red[50]), shape: MaterialStateProperty.all<RoundedRectangleBorder>( RoundedRectangleBorder( borderRadius: BorderRadius.circular(6.0),))) ,
      
      
      onPressed: ()async{
        if(_formKey.currentState!.validate()){
        showDialog(context: context, builder: (context)=>publishIndecator(), barrierDismissible: false, );
        //await UploadData.uploadImage();
        await submitForm().then((value) {print("indicator value: $value");
         if(value){  Navigator.popUntil(context, ModalRoute.withName("/"));     
          }}
        );
        }
        
        
         



       }, child: Text(AppLocalizations.of(context)!.tagPublish, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),), );
  }

Dialog publishIndecator(){return  const Dialog(surfaceTintColor: Colors.transparent, backgroundColor: Color.fromARGB(0, 255, 255, 255), child: Center(child: CircularProgressIndicator(color: Color.fromRGBO(255, 235, 238, 1),) )); }




  InputDecoration inputdecoration(Color? checkColor) => InputDecoration(suffixIcon: const Icon(Ionicons.checkmark_circle_outline), suffixIconColor: checkColor, contentPadding: const EdgeInsets.all(8), border: const OutlineInputBorder(), focusedBorder: const OutlineInputBorder(borderSide: BorderSide(width: 2, color: Colors.black))  );

  Padding labelText(final String text) => Padding(padding: const EdgeInsets.fromLTRB(0, 8, 8, 8), child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),);
}

