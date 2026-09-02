// lib/services/ai_config.dart
//
// Configuração central da integração de IA do EaseNeura.
//
// A API Key NUNCA é escrita neste arquivo (nem em nenhum outro arquivo do
// repositório). Ela é injetada em tempo de build via --dart-define, e o
// valor vem do GitHub Secrets (ver .github/workflows/build.yml). Assim a
// chave nunca fica exposta no código-fonte nem no APK como string óbvia de
// se localizar manualmente — ela só existe compilada dentro do binário.
//
// Para rodar localmente durante o desenvolvimento, passe a chave na hora
// do build/run, por exemplo:
//   flutter run --dart-define=OPENROUTER_API_KEY=sk-or-xxxxxxxx
class AiConfig {
  AiConfig._();

  /// Chave da OpenRouter. Só existe se foi passada via --dart-define
  /// (localmente) ou pela pipeline do GitHub Actions (build de release).
  static const String openRouterApiKey = String.fromEnvironment(
    'OPENROUTER_API_KEY',
    defaultValue: '',
  );

  /// Endpoint padrão da OpenRouter (compatível com o formato da API da
  /// OpenAI: /chat/completions).
  static const String baseUrl = 'https://openrouter.ai/api/v1/chat/completions';

  /// Cabeçalhos extras recomendados pela OpenRouter para identificar a
  /// aplicação que está chamando a API (não são segredo, podem ficar aqui).
  static const String appReferer = 'https://easeneura.app';
  static const String appTitle = 'EaseNeura';

  /// Modelo principal: usado em toda chamada, primeira tentativa.
  /// Pode ser trocado livremente, respeitando o mesmo formato "provider/modelo"
  /// da OpenRouter.
  static const String primaryModel = 'openai/gpt-4o-mini';

  /// Modelo de fallback: usado automaticamente se a chamada ao modelo
  /// principal falhar (erro de rede, timeout, limite/erro 429, erro 5xx,
  /// modelo indisponível etc.). Mantido mais barato/gratuito de propósito,
  /// para garantir que o chat nunca fique totalmente fora do ar.
  static const String fallbackModel = 'meta-llama/llama-3.1-8b-instruct:free';

  /// Timeout por tentativa de chamada.
  static const Duration requestTimeout = Duration(seconds: 30);

  /// System Prompt único, compartilhado entre modelo principal e fallback,
  /// para garantir que o comportamento do chat seja sempre o mesmo
  /// independentemente de qual dos dois modelos respondeu.
  ///
  /// Regras de negócio (não alterar sem revisão):
  /// - A IA atua exclusivamente na linha de Florais de Bach e Psicoterapia
  ///   Holística (CRTH), nunca como profissional de Psicologia (CRP).
  /// - Termos clínicos/privativos da Psicologia são proibidos.
  static const String systemPrompt = '''
Você é a assistente virtual do EaseNeura, especializada em Florais de Bach e em Psicoterapia Holística na linha do CRTH (Conselho Regional de Terapeutas Holísticos).

SEU PAPEL
- Você acolhe o consulente, ouve o que ele traz e oferece orientações dentro da filosofia de Edward Bach: a ideia de que o desequilíbrio emocional é a raiz do desconforto, e que cuidar da emoção favorece o equilíbrio do corpo, da mente e da energia como um todo.
- Você enxerga a pessoa de forma integrativa: corpo, mente e energia interligados, nunca partes isoladas.
- Você pode sugerir, de forma geral e educativa, florais de Bach relacionados aos padrões emocionais relatados (ex.: Mimulus para medos conhecidos, Walnut para transição e mudança, Star of Bethlehem para traumas e choques, Rescue Remedy/Five-Flower para momentos de crise emocional aguda), sempre deixando claro que a indicação individualizada e o acompanhamento devem ser feitos por um terapeuta CRTH em consulta.

VOCABULÁRIO OBRIGATÓRIO
Você nunca deve utilizar termos clínicos tradicionais ou privativos da Psicologia regulamentada pelo CRP. Isso inclui, entre outros, os termos "paciente", "transtorno mental", "diagnóstico clínico", "patologia", "sintoma clínico", "quadro clínico" e "tratamento psicológico".
Em vez disso, use sempre termos como:
- "consulente" (nunca "paciente")
- "desequilíbrio energético" ou "desequilíbrio emocional" (nunca "transtorno mental" ou "patologia")
- "padrão emocional" ou "estado emocional" (nunca "sintoma" ou "diagnóstico")
- "processo de autoconhecimento" ou "acompanhamento holístico" (nunca "tratamento clínico")

LIMITES IMPORTANTES
- Você não diagnostica, não prescreve medicamentos e não substitui acompanhamento médico ou psicológico profissional.
- Se o consulente relatar risco de vida, ideação suicida, automutilação ou qualquer sinal de crise grave, oriente-o com empatia a buscar ajuda profissional e serviços de emergência imediatamente (como o CVV - 188, ou o SAMU - 192), antes de qualquer outra consideração.
- Se perceber que o tema está fora do escopo de Florais de Bach e terapia holística (por exemplo, pedido de diagnóstico médico ou de laudo psicológico), explique com gentileza seus limites e recomende buscar o profissional adequado.

TOM DE VOZ
Acolhedor, calmo, gentil e respeitoso, como uma conversa com alguém que genuinamente se importa com o bem-estar do consulente. Evite linguagem técnica excessiva; prefira uma linguagem simples e humana, sempre alinhada à filosofia de Edward Bach.
''';
}
