// lib/services/ai_chat_service.dart
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:ease_neura/models/chat_message_model.dart';
import 'package:ease_neura/services/ai_config.dart';

/// Exceção lançada quando NENHUM dos modelos (principal e fallback)
/// conseguiu responder.
class AiChatException implements Exception {
  final String message;
  const AiChatException(this.message);

  @override
  String toString() => message;
}

/// Serviço responsável por conversar com a API de IA (OpenRouter).
///
/// Arquitetura de fallback: toda chamada tenta primeiro [AiConfig.primaryModel].
/// Se essa chamada falhar (timeout, erro de rede, erro HTTP 4xx/5xx, limite
/// de uso esgotado etc.), o serviço tenta automaticamente de novo com
/// [AiConfig.fallbackModel] — usando exatamente o mesmo System Prompt e o
/// mesmo histórico de conversa, para manter o comportamento do chat idêntico
/// independente de qual modelo respondeu.
class AiChatService {
  AiChatService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  bool get isConfigured => AiConfig.openRouterApiKey.isNotEmpty;

  /// Envia o histórico de mensagens (sem contar o system prompt, que é
  /// adicionado automaticamente aqui) e retorna o texto de resposta da IA.
  Future<String> sendMessage(List<ChatMessageModel> history) async {
    if (!isConfigured) {
      throw const AiChatException(
        'A chave da API de IA não foi configurada neste build. '
        'Verifique o secret OPENROUTER_API_KEY no GitHub Actions.',
      );
    }

    final messages = <Map<String, String>>[
      {'role': 'system', 'content': AiConfig.systemPrompt},
      ...history.map((m) => m.toApiJson()),
    ];

    try {
      // 1ª tentativa: modelo principal.
      return await _callModel(model: AiConfig.primaryModel, messages: messages);
    } catch (primaryError) {
      // Fallback: mesmo prompt, mesmo histórico, outro modelo.
      try {
        return await _callModel(
          model: AiConfig.fallbackModel,
          messages: messages,
        );
      } catch (fallbackError) {
        throw AiChatException(
          'Não foi possível obter resposta da IA agora. '
          'Tente novamente em instantes. '
          '(principal: $primaryError | fallback: $fallbackError)',
        );
      }
    }
  }

  Future<String> _callModel({
    required String model,
    required List<Map<String, String>> messages,
  }) async {
    final response = await _client
        .post(
          Uri.parse(AiConfig.baseUrl),
          headers: {
            'Authorization': 'Bearer ${AiConfig.openRouterApiKey}',
            'Content-Type': 'application/json',
            'HTTP-Referer': AiConfig.appReferer,
            'X-Title': AiConfig.appTitle,
          },
          body: jsonEncode({
            'model': model,
            'messages': messages,
            'temperature': 0.7,
          }),
        )
        .timeout(AiConfig.requestTimeout);

    if (response.statusCode != 200) {
      throw AiChatException(
        'Erro ${response.statusCode} do modelo "$model": ${response.body}',
      );
    }

    final decoded = jsonDecode(utf8.decode(response.bodyBytes));
    final choices = decoded['choices'] as List<dynamic>?;
    if (choices == null || choices.isEmpty) {
      throw AiChatException('Resposta vazia do modelo "$model".');
    }

    final content = choices.first['message']?['content'] as String?;
    if (content == null || content.trim().isEmpty) {
      throw AiChatException('Conteúdo vazio na resposta do modelo "$model".');
    }

    return content.trim();
  }

  void dispose() {
    _client.close();
  }
}
