import 'package:agrilease/pages/recent_section.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';

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

class ImageSection extends StatelessWidget {
  const ImageSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const AspectRatio(aspectRatio: 1.5, child: Placeholder());
  }
}


// ignore: must_be_immutable
class InputInfoSecton extends StatelessWidget {
  InputInfoSecton({super.key});

TextEditingController title = TextEditingController();
TextEditingController price = TextEditingController();
TextEditingController description = TextEditingController();
TextEditingController location = TextEditingController();
TextEditingController contact = TextEditingController();


void submitForm(){
final productDetail =   ProductDetail(title: title.text, price: price.text, description: description.text, image: 'None', location: 'None', contact: 'None' );
print(productDetail);
}

void selectImage ()async{
final gallaryFile = await ImagePicker().pickImage(source: ImageSource.gallery );
print(gallaryFile?.path??'No path Selected');
}


  @override
  Widget build(BuildContext context) {
  


    return Column(  crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
      labelText("Ad's Title"),  formField(title),
      labelText("Price"),       formField(price),
      labelText("Description"), formField(description),
      labelText("Locaton"),     formField(location),      
      labelText("Contact"),     formField(contact),
      selectImageButton(), 
      submitbutton() // disable button till every thing is valid
      //Publish ADD
      ],);
  }

  Padding selectImageButton() {
    return Padding( padding: const EdgeInsets.all(8.0),
      child: OutlinedButton.icon( onPressed: (){ selectImage(); }, label: const Text('Select Image'), icon: const Icon(Ionicons.camera_sharp),),
    );
  }

  Padding submitbutton() {return Padding( padding: const EdgeInsets.all(8.0),
    child: Center(child: OutlinedButton( style:ButtonStyle(shape: MaterialStateProperty.all<RoundedRectangleBorder>( RoundedRectangleBorder( borderRadius: BorderRadius.circular(6.0),))) ,
        onPressed: () { submitForm(); }, child: const Text("Publish Ad"), ),
      ),
  );
  }

  TextFormField formField( controller ) => TextFormField( decoration: const InputDecoration( contentPadding: EdgeInsets.all(8), border: OutlineInputBorder(), focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 2, color: Colors.black))  ), 
  controller: controller,
  );

  Padding labelText(final String text) => Padding(padding: const EdgeInsets.fromLTRB(0, 8, 8, 8), child: Text(text, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),);
}