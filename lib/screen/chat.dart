import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  String messageContent;
  String messageType;
  ChatMessage({required this.messageContent, required this.messageType});
}

class ChatScreen extends StatefulWidget {
  final String uid1;
  final String uid2;
  const ChatScreen({super.key, required this.uid1, required this.uid2});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();

  // Firestore instance
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Send message to Firestore
  void sendMessage(String message) async {
    if (message.isNotEmpty) {
      String chatId = '${widget.uid1}_${widget.uid2}'; // Chat between two users
      await firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add({
        'senderUid': widget.uid1, // Assuming sender is uid1
        'messageContent': message,
        'timestamp': FieldValue.serverTimestamp(),
        'messageType': 'sender',
      });
      messageController.clear();
    }
  }

  // Stream messages from Firestore
  Stream<QuerySnapshot> getMessages() {
    String chatId = '${widget.uid1}_${widget.uid2}';
    return firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat Detail"),
      ),
      body: Stack(
        children: <Widget>[
          // Chat message list
          StreamBuilder<QuerySnapshot>(
            stream: getMessages(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong'));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final messages = snapshot.data!.docs;
              return ListView.builder(
                itemCount: messages.length,
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                itemBuilder: (context, index) {
                  var message = messages[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    child: Align(
                      alignment: (message['senderUid'] == widget.uid1
                          ? Alignment.topRight
                          : Alignment.topLeft),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: (message['senderUid'] == widget.uid1
                              ? Colors.blue[600]
                              : Colors.grey.shade200),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          message['messageContent'],
                          style: TextStyle(
                            fontSize: 15,
                            color: (message['senderUid'] == widget.uid1
                                ? Colors.white
                                : Colors.black),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: const InputDecoration(
                        hintText: "Write message...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      sendMessage(messageController.text);
                    },
                    backgroundColor: Colors.blue,
                    elevation: 0,
                    child:
                        const Icon(Icons.send, color: Colors.white, size: 18),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
