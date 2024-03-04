import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';

class ChatbotPage extends StatefulWidget {
  @override
  _ChatbotPageState createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  List<ChatMessage> messages = <ChatMessage>[];
  ChatUser user = ChatUser(
    name: "You",
    uid: "user",
    avatar: "https://www.example.com/avatar.jpg", // URL avatar pengguna
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chatbot"),
      ),
      body: DashChat(
        currentUser: user,
        messages: messages,
        onSend: (message) {
          setState(() {
            messages.add(message);
            // Di sini Anda bisa menambahkan logika untuk merespons pesan yang dikirim oleh pengguna
            // Misalnya, melakukan pengolahan pesan dan mengirim balasan dari chatbot
            // Anda dapat menggunakan informasi di dalam 'message' untuk menentukan balasan yang tepat
            // Contoh:
            // if (message.text.toLowerCase() == 'hai') {
            //   _sendReply('Halo, ada yang bisa saya bantu?');
            // }
          });
        },
      ),
    );
  }

  // Metode ini digunakan untuk mengirim pesan balasan dari chatbot
  void _sendReply(String text) {
    ChatMessage reply = ChatMessage(
      text: text,
      user: ChatUser(
        name: "Chatbot",
        uid: "chatbot",
        avatar: "https://www.example.com/chatbot_avatar.jpg", // URL avatar chatbot
      ),
    );
    setState(() {
      messages.add(reply);
    });
  }
}
