import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messaging_app/models/message.dart';

class ChatServices {
  //instance firestore
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //getUserstream

  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _fireStore.collection("users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  //send message
  Future<void> sendMessage(String recievedId, String msg) async {
    //getCurent User and the time
    String currentUserId = _firebaseAuth.currentUser!.uid;
    String currentUserMail = _firebaseAuth.currentUser!.email!;
    Timestamp timesTamp = Timestamp.now();
    //creatMessage
    Message message = Message(
      senderId: currentUserId,
      senderMail: currentUserMail,
      receiverId: recievedId,
      message: msg,
      timesTamp: timesTamp,
    );
    //construir chatRoom for the two users
    List<String> ids = [currentUserId, recievedId];
    ids.sort(); //meme chatRoom for the two of them
    String chatRoomId = ids.join('_');
    //add the mssage to db

    await _fireStore
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("messages")
        .add(message.toMap());
  }
  //getMessage

  Stream<QuerySnapshot> getMessages(String userId, String receivedUserId) {
    List<String> ids = [userId, receivedUserId];
    ids.sort();
    String chatRoomId = ids.join('_');
    return _fireStore
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("timesTamp", descending: false)
        .snapshots();
  }
}
