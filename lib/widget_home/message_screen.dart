// lib/widget_home/message_screen.dart
import 'package:flutter/material.dart';

import 'package:ease_neura/constants/layout_constants.dart';
import 'package:ease_neura/models/chat_message_model.dart';
import 'package:ease_neura/services/ai_chat_service.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AiChatService _aiChatService = AiChatService();

  final List<ChatMessageModel> _messages = [
    ChatMessageModel(
      role: ChatRole.assistant,
      content:
          'Olá! Seja bem-vindo(a). Eu sou a assistente do EaseNeura, aqui para '
          'te acompanhar com os Florais de Bach e uma escuta holística do seu '
          'momento. Como você está se sentindo hoje?',
      timestamp: DateTime.now(),
    ),
  ];

  bool _isSending = false;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _aiChatService.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _handleSend() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _isSending) return;

    final userMessage = ChatMessageModel(
      role: ChatRole.user,
      content: text,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMessage);
      _messages.add(
        ChatMessageModel(
          role: ChatRole.assistant,
          content: '',
          timestamp: DateTime.now(),
          isLoading: true,
        ),
      );
      _isSending = true;
    });
    _messageController.clear();
    _scrollToBottom();

    try {
      // Envia todo o histórico (exceto o placeholder de loading) para que a
      // IA mantenha o contexto da conversa.
      final historyForApi =
          _messages.where((m) => !m.isLoading).toList(growable: false);

      final reply = await _aiChatService.sendMessage(historyForApi);

      setState(() {
        _messages.removeLast(); // remove o placeholder de loading
        _messages.add(
          ChatMessageModel(
            role: ChatRole.assistant,
            content: reply,
            timestamp: DateTime.now(),
          ),
        );
      });
    } on AiChatException catch (e) {
      setState(() {
        _messages.removeLast();
        _messages.add(
          ChatMessageModel(
            role: ChatRole.assistant,
            content: e.message,
            timestamp: DateTime.now(),
            isError: true,
          ),
        );
      });
    } catch (e) {
      setState(() {
        _messages.removeLast();
        _messages.add(
          ChatMessageModel(
            role: ChatRole.assistant,
            content: 'Algo deu errado ao falar com a IA. Tente novamente.',
            timestamp: DateTime.now(),
            isError: true,
          ),
        );
      });
    } finally {
      setState(() => _isSending = false);
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Chat'),
        automaticallyImplyLeading: false,
        // Sem botão de voltar: esta tela vive como uma aba dentro do
        // IndexedStack da HomePage, então não há rota anterior para dar pop
        // (Navigator.pop aqui derrubaria a própria Home).
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              )
            : null,
      ),
      // SafeArea + padding inferior (kPillNavBarClearance): esta tela vive
      // como aba dentro do IndexedStack de HomePage, cuja navbar em pílula
      // flutua por cima do conteúdo (Scaffold.extendBody: true). Sem esse
      // espaço reservado, o campo "Digite sua mensagem..." ficava coberto
      // pela pílula.
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(bottom: kPillNavBarClearance),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return ChatBubble(message: _messages[index]);
                  },
                ),
              ),
              _buildInputField(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField() {
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
              enabled: !_isSending,
              style: const TextStyle(color: Colors.white),
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _handleSend(),
              decoration: InputDecoration(
                hintText: 'Digite sua mensagem...',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          _isSending
              ? const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: _handleSend,
                ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final ChatMessageModel message;

  const ChatBubble({required this.message, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    Color bubbleColor;
    Color textColor;
    if (message.isError) {
      bubbleColor = Colors.red[50]!;
      textColor = Colors.red[900]!;
    } else if (isUser) {
      bubbleColor = Colors.black;
      textColor = Colors.white;
    } else {
      bubbleColor = Colors.white;
      textColor = Colors.black;
    }

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        margin: const EdgeInsets.symmetric(vertical: 6.0),
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.circular(14.0),
          border: Border.all(
            color: message.isError ? Colors.red[200]! : Colors.black,
          ),
        ),
        child: message.isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(
                message.content,
                style: TextStyle(color: textColor),
              ),
      ),
    );
  }
}
