import 'package:flutter/material.dart';
import 'package:ease_neura/constants/layout_constants.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Chat'),
        automaticallyImplyLeading: false,
        // Sem botão de voltar: esta tela agora vive como uma aba dentro do
        // IndexedStack da HomePage, então não há rota anterior para dar pop
        // (Navigator.pop aqui derrubaria a própria Home).
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            : null,
      ),
      // SafeArea + padding inferior (kPillNavBarClearance): esta tela vive
      // como aba dentro do IndexedStack de HomePage, cuja navbar em pílula
      // flutua por cima do conteúdo (Scaffold.extendBody: true). Sem esse
      // espaço reservado, o campo "Type your message..." ficava totalmente
      // coberto pela pílula.
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(bottom: kPillNavBarClearance),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(8.0),
                  children: [
                    ChatMessage(isSentByMe: true, message: 'Hello!'),
                    ChatMessage(isSentByMe: false, message: 'Hi there!'),
                    // Add more messages as needed
                  ],
                ),
              ),
              _buildInputField(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(BuildContext context) {
    TextEditingController _messageController = TextEditingController();

    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Type your message...',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 8.0),
          IconButton(
            icon: Icon(Icons.send, color: Colors.white),
            onPressed: () {
              String messageText = _messageController.text.trim();
              if (messageText.isNotEmpty) {
                // Add your logic to send the message
                // For now, let's just print the message to the console
                print('Sending message: $messageText');
              }
              _messageController.clear();
            },
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final bool isSentByMe;
  final String message;

  const ChatMessage({
    required this.isSentByMe,
    required this.message,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isSentByMe ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: Colors.black),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isSentByMe ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MessageScreen(),
  ));
}
