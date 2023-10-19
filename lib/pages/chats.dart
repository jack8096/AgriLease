import 'package:agrilease/login_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';



class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {

Future<dynamic> someFunction()async{
  
try {
  print("someFunction");
  Map<String, dynamic> data = await Chats().chatRoomsIDs(FireBaseAuthentication.emailID);
  print("ChatsPage SomeFunction var data: $data");
  return data;
} catch (e) {print("ChatsPage SomeFunction error: $e");}
  }

@override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return 
    Scaffold(
      appBar: AppBar(surfaceTintColor: Colors.white, title: const Text("Chat", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),), backgroundColor : Colors.blue[50],),
      body: FutureBuilder(future: someFunction(), builder: (context, snapShot){late dynamic Data; try{ Data =  snapShot.data ; print("Data runtimeType: ${Data.runtimeType} Data = '$Data'");}catch(e){print(e);}
        if(snapShot.hasData){ //snapShot.hasData
          return ChatList(data: Data);
          
          
          }
        else{return const Center(child: Text("Chat list is empty, try chating...", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 24),),);}
         }),
    );
  }
}

class ChatList extends StatelessWidget {
  const ChatList({
    super.key,
    required this.data,
  });

  final  Map<String, dynamic>  data;
  
  @override
  Widget build(BuildContext context) {
    print("ChatsList var data: $data runtime: ${data.runtimeType} " );
    final List dataList = data.values.toList();
    final List roomIDList = data.keys.toList();
    return Container(color: Colors.white,
      child: ListView.separated( separatorBuilder: (context, sep){return const Divider( indent: 15, endIndent: 15, height: 1, );}, itemCount:data.length, 
      itemBuilder: (context, index){return ChatUserBox(roomID: roomIDList[index], Data: dataList[index], index:index );},),
    );// Data.length  //ListView.builder( itemCount: Data.length, itemBuilder: (context, index){return ChatUserBox(Data: Data, index:index ) ;  });
  }
}

class ChatUserBox extends StatelessWidget {
  const ChatUserBox({
    super.key,
    required this.Data,
    required this.roomID,
    required this.index
  });
  final String roomID;
  final String Data; //Map<String, dynamic>
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: (){Navigator.of(context).push(MaterialPageRoute(builder: (context){return ChatSection(roomID: roomID, reciverEmail: Data,);}));}, 
    child: Container(padding: const EdgeInsets.all(20), child: Row(children: [const Padding(padding: EdgeInsets.only(right:10), child: InkWell(child: Icon(size: 40, Ionicons.person_circle_outline),)),   Text(Data)],  )));
  }
}


class ChatSection extends StatefulWidget {final String roomID; final String reciverEmail;
  const ChatSection({super.key, required this.roomID, required this.reciverEmail });

  @override
  State<ChatSection> createState() => _ChatSectionState( );
}

class _ChatSectionState extends State<ChatSection> {
final TextEditingController _messageController = TextEditingController();

  Widget _someWidget(){return StreamBuilder(stream: Chats().getMessage(widget.roomID, widget.reciverEmail )  , builder:(context , final snapshot){
    if(snapshot.connectionState == ConnectionState.waiting){return const Center(child: Text("Start a chat to connect and discuss further", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),),);}
    
    if(snapshot.hasData){return ListView(children: snapshot.data!.docs.map((e) =>   messageBox(e.data()) ).toList(), ); }
    else{return const Center(child: Text("Error", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),);}
    
  }  ,);}

Widget messageBox(doc){
  doc as Map<String, dynamic>;  
  AlignmentGeometry alignment = Alignment.centerRight;
  late Color? color;
  late Radius bottomLeftTeardrop;
  late Radius bottomRightTeardrop;
  if(doc["reciverID"]==widget.reciverEmail){  alignment = Alignment.centerRight; color = Colors.grey[200]; bottomLeftTeardrop = const Radius.circular(20) ; bottomRightTeardrop = const Radius.circular(0); }else{alignment = Alignment.centerLeft; color = Colors.blue[100]; bottomLeftTeardrop = const Radius.circular(0) ; bottomRightTeardrop = const Radius.circular(20);}
  // print("_ChatSectionState widget.reciverEmail: ${widget.reciverEmail}, doc['reciverID']: ${doc["reciverID"]}, alignment: $alignment ");
  return 
  Container( alignment: alignment, padding: const EdgeInsets.all(15), child: messageBubbble(bottomLeftTeardrop, bottomRightTeardrop, color, doc),

  );  
  
}

Container messageBubbble(Radius bottomLeftTeardrop,Radius bottomRightTeardrop, Color? color, Map<String, dynamic> doc) => 
Container(padding: const EdgeInsets.all(10), constraints: const BoxConstraints(minWidth: 50),
decoration: BoxDecoration( boxShadow: null, color: color, borderRadius: BorderRadius.only(topLeft: const Radius.circular(20), topRight: const Radius.circular(20), bottomLeft: bottomLeftTeardrop,  bottomRight: bottomRightTeardrop)  ), //BorderRadius.all(Radius.circular(18))
child: Text( doc["message"]??"none", textAlign: TextAlign.center,style: const TextStyle(color: Colors.black87, fontSize: 16, ), ));


void sendMessage(){
print("_ChatSectionState Function sendMessage");
Chats().sendMessage(widget.reciverEmail, _messageController.text, widget.roomID);

}


  @override
  Widget build(BuildContext context) {
    return Scaffold( appBar: AppBar(title:  Text(widget.reciverEmail), backgroundColor: Colors.blue[50],),
    body: Center(child: Column(children: [
          //Text(widget.roomID),
          //OutlinedButton(onPressed: (){ Chats().someFunction(); }, child: const Text("run someFunction")),
          Expanded(child: Container(color: Colors.white, child: _someWidget())),
          const Divider(thickness: 1, indent: 10, endIndent: 10, height: 1),
          TextField( cursorColor: Colors.black, controller: _messageController, decoration: InputDecoration(fillColor: const Color.fromARGB(255, 246, 251, 254), filled: true, contentPadding: const EdgeInsets.all(20),border: InputBorder.none,   hintText: "Type a message", suffixIcon: InkWell(child: const Icon(Ionicons.paper_plane_outline), onTap:(){sendMessage(); _messageController.clear();}   ,) ),  )
        ],
      ),
    ),

    );
  }
}





class Chats {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

void sendMessage(String reciverID, String message, String chatRoomID)async{
  


final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
final timeStamp = Timestamp.now();
//final reciverID = reciverID;

Message messageHeader = Message(senderEmail: currentUserEmail, reciverID: reciverID, message: message, timeStamp: timeStamp);




await _fireStore.collection("chat_rooms").doc(chatRoomID,).collection("message").add(messageHeader.toMap()); //await _fireStore.collection("chat_rooms").doc(chatRoomID).collection("message").add(messageHeader.toMap());
}

Stream<QuerySnapshot> getMessage(String chatRoomID, String reciverEmail){
return _fireStore.collection("chat_rooms").doc(chatRoomID).collection("message").orderBy("timeStamp", descending: false).snapshots(); 

}


Future<String> createChatRoom(final String user1, final String user2)async{
  print("$user1  $user2");
  final List<String> emails = [user1, user2];
  emails.sort();
  final String chatRoomID = emails.join("-");
  print("chatRoomID: $chatRoomID");


  await _fireStore.collection("user_chatroomID").doc(user1).set({chatRoomID:user2}, SetOptions(merge: true));
  await _fireStore.collection("user_chatroomID").doc(user2).set({chatRoomID:user1}, SetOptions(merge: true));

  return chatRoomID;


}

someFunction()async{ try {
  await _fireStore.collection( "chats" ).doc("roomID");
} catch (e) {print(e);}}

Future<Map<String, dynamic>> chatRoomsIDs(email)async{
late dynamic docSnap;
//try {
var docRef = await _fireStore.collection("user_chatroomID").doc(email);
await docRef.get().then((value) { docSnap = value.data() as Map<String, dynamic>;});
var chatRoomsIDs = docSnap;
print("docSnap: $docSnap, runtimeType:${docSnap.runtimeType} " );   //var chatRoomsIDs = docSnap.keys;
return chatRoomsIDs; 


}

  
}



class Message{ final String senderEmail; final String reciverID; final String message; final Timestamp timeStamp;
Message({required this.senderEmail, required this.reciverID, required this.message, required this.timeStamp});

Map<String, dynamic> toMap(){
  return{
    "senderEmail":senderEmail,
    "reciverID":reciverID,
    "message":message,
    "timeStamp":timeStamp,
  };
}
}