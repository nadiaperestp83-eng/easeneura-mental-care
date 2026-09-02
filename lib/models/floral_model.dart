/// Modelo de dados de um Floral de Bach.
///
/// Representa uma "colinha" de consulta rápida: nome do floral, o grupo
/// emocional ao qual pertence, a descrição da dor/sintoma que ele endereça
/// e uma lista de palavras-chave usadas pela busca instantânea.
class FloralModel {
  /// Nome do floral (ex: "Mustard", "Sweet Chestnut").
  final String nome;

  /// Grupo/categoria emocional principal (ex: "Solidão", "Ódio/Raiva").
  /// Usado tanto como rótulo visual quanto como filtro dos chips de topo.
  final String grupo;

  /// Descrição direta ao ponto do estado emocional/sintoma que o floral
  /// endereça. Pensada para leitura rápida durante um atendimento.
  final String sintomas;

  /// Palavras-chave do dia a dia (não-técnicas) que uma pessoa usaria para
  /// descrever o que está sentindo. Alimentam a busca por texto livre.
  final List<String> palavrasChave;

  const FloralModel({
    required this.nome,
    required this.grupo,
    required this.sintomas,
    required this.palavrasChave,
  });

  /// Concatena todos os campos pesquisáveis em um único texto normalizado
  /// (minúsculo, sem acentuação simples) para facilitar o "match" da busca.
  String get textoBusca {
    final base = '$nome $grupo $sintomas ${palavrasChave.join(' ')}';
    return _normalizar(base);
  }

  static String _normalizar(String texto) {
    const comAcento = 'áàâãäéèêëíìîïóòôõöúùûüçÁÀÂÃÄÉÈÊËÍÌÎÏÓÒÔÕÖÚÙÛÜÇ';
    const semAcento = 'aaaaaeeeeiiiiooooouuuucAAAAAEEEEIIIIOOOOOUUUUC';
    var resultado = texto.toLowerCase();
    for (var i = 0; i < comAcento.length; i++) {
      resultado = resultado.replaceAll(comAcento[i], semAcento[i].toLowerCase());
    }
    return resultado;
  }
}
