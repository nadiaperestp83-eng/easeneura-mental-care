// lib/models/chat_message_model.dart

/// Papel da mensagem, no mesmo vocabulário usado pela API de chat
/// (OpenAI/OpenRouter): "system", "user" ou "assistant".
enum ChatRole { system, user, assistant }

class ChatMessageModel {
  final ChatRole role;
  final String content;
  final DateTime timestamp;

  /// true enquanto a resposta da IA ainda está sendo carregada (usado para
  /// mostrar um indicador de "digitando..." na UI).
  final bool isLoading;

  /// true se esta mensagem representa um erro (ex.: falha do modelo
  /// principal e do fallback) — permite estilizar diferente na UI.
  final bool isError;

  const ChatMessageModel({
    required this.role,
    required this.content,
    required this.timestamp,
    this.isLoading = false,
    this.isError = false,
  });

  bool get isUser => role == ChatRole.user;
  bool get isAssistant => role == ChatRole.assistant;

  ChatMessageModel copyWith({
    ChatRole? role,
    String? content,
    DateTime? timestamp,
    bool? isLoading,
    bool? isError,
  }) {
    return ChatMessageModel(
      role: role ?? this.role,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
    );
  }

  /// Nome do papel no formato esperado pela API (chat/completions).
  String get apiRole {
    switch (role) {
      case ChatRole.system:
        return 'system';
      case ChatRole.user:
        return 'user';
      case ChatRole.assistant:
        return 'assistant';
    }
  }

  Map<String, String> toApiJson() => {
        'role': apiRole,
        'content': content,
      };
}
