import 'package:agrilease/login_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {

Future<dynamic> someFunction()async{
  
try {
  print("someFunction");
  
  return await Chats().chatRoomsIDs(FireBaseAuthentication.emailID);
} catch (e) {print(e);}
  }

@override
  void initState() {
    FireBaseAuthentication.signInWithGooggle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return 
    Scaffold(
      appBar: AppBar(title: const Text("Chat List Under Construction"), backgroundColor : Colors.green[50],),
      body: FutureBuilder(future: someFunction(), builder: (context, snapShot){late dynamic Data; try{ Data =  snapShot.data ; print("Data runtimeType: ${Data.runtimeType}");}catch(e){print(e);}
        if(snapShot.hasData){ 
          return ChatList(Data: Data);
          
          
          }
        else{return const Text("No Data");}
         }),
    );

// Center(
//   child:   Column(children: [const Center(child:Text('Page under Construction')),
        
//         OutlinedButton(onPressed: (){someFunction();}, child: const Text("sendMsg"))
  
//         ],
  
//       ),
// );

  }
}

class ChatList extends StatelessWidget {
  const ChatList({
    super.key,
    required this.Data,
  });

  final  Data;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(itemBuilder: (context, index){return ChatUserBox(Data: Data, index:index );}, separatorBuilder: (context, sep){return const Divider();}, itemCount: Data.length); //ListView.builder( itemCount: Data.length, itemBuilder: (context, index){return ChatUserBox(Data: Data, index:index ) ;  });
  }
}

class ChatUserBox extends StatelessWidget {
  const ChatUserBox({
    super.key,
    required this.Data,
    required this.index
  });

  final List<String> Data;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: (){Navigator.of(context).push(MaterialPageRoute(builder: (context){return ChatSection(roomID: Data[index]);}));}, child: Container( child: Padding(padding: const EdgeInsets.all(20), child: Text(Data[index]),)));
  }
}


class ChatSection extends StatefulWidget {final String roomID;
  const ChatSection({super.key, required this.roomID});

  @override
  State<ChatSection> createState() => _ChatSectionState( );
}

class _ChatSectionState extends State<ChatSection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold( appBar: AppBar(title: const Text("chat section Under Construction",), backgroundColor: Colors.green[50],),
    body: Center(child: Column(children: [
          Text(widget.roomID),
          OutlinedButton(onPressed: (){ Chats().someFunction(); }, child: const Text("run someFunction"))
          
        ],
      ),
    ),

    );
  }
}





class Chats {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

void sendMessage(String reciverID, String message, )async{
  

final  String currentUserID = _firebaseAuth.currentUser!.uid;
final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
final timeStamp = Timestamp.now();
//final reciverID = reciverID;

Message messageHeader = Message(senderID: currentUserID, senderEmail: currentUserEmail, reciverID: reciverID, message: message, timeStamp: timeStamp);


final List<String> ids = [currentUserID, reciverID];
ids.sort();
final String chatRoomID = ids.join("-");


await _fireStore.collection("chat_rooms").doc(chatRoomID).collection("message").add(messageHeader.toMap());



Stream<QuerySnapshot> getMessage(String userID, String reciverID){
List<String> ids = [userID,reciverID ];
ids.sort();
final String chatRoomID = ids.join("-");

return _fireStore.collection("chat_rooms").doc(chatRoomID).collection("message").orderBy("timeStamp", descending: false).snapshots(); 

}}


Future<void> createChatRoom(final String user1, final String user2)async{
  print("$user1  $user2");
  final List<String> emails = [user1, user2];
  emails.sort();
  final String chatRoomID = emails.join("-");
  print("chatRoomID: $chatRoomID");
try{

  await _fireStore.collection("user_chatroomID").doc(user1).set({chatRoomID:null}, SetOptions(merge: true));
  await _fireStore.collection("user_chatroomID").doc(user2).set({chatRoomID:null}, SetOptions(merge: true));
  //await _fireStore.collection( "chat_rooms" ).doc("roomID");

  

}catch(e){print(e);}
}

someFunction()async{ try {
  await _fireStore.collection( "chats" ).doc("roomID");
} catch (e) {print(e);}}

Future<List> chatRoomsIDs(email)async{
late dynamic docSnap;
//try {
var docRef = await _fireStore.collection("user_chatroomID").doc(email);
await docRef.get().then((value) { docSnap = value.data() as Map<String, dynamic>;});
var chatRoomsIDs = docSnap.keys.toList();
return chatRoomsIDs; 


//} catch (e) {print(e);}

}

  
}



class Message{final String senderID; final String senderEmail; final String reciverID; final String message; final Timestamp timeStamp;
Message({required this.senderID, required this.senderEmail, required this.reciverID, required this.message, required this.timeStamp});

Map<String, dynamic> toMap(){
  return{
    "senderID":senderID,
    "senderEmail":senderEmail,
    "reciverID":reciverID,
    "message":message,
    "timeStamp":timeStamp,
  };
}
}