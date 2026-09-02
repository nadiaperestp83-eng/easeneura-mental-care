import 'package:ease_neura/models/floral_model.dart';

/// Nomes dos grupos usados nos chips de filtro rápido da tela principal.
/// Mantidos como constantes para evitar strings soltas espalhadas pela UI.
class GruposFlorais {
  static const depressao = 'Depressão';
  static const tristeza = 'Tristeza';
  static const vazio = 'Vazio';
  static const solidao = 'Solidão';
  static const odio = 'Ódio';
  static const doresNoCorpo = 'Dores no Corpo';
}

/// Fonte de dados mockada — 100% offline, sem chamadas de rede.
class FloralRepository {
  static const List<FloralModel> florais = [
    FloralModel(
      nome: 'Mustard',
      grupo: GruposFlorais.depressao,
      sintomas:
          'Tristeza profunda que chega sem motivo aparente, como uma nuvem '
          'escura que cobre tudo de repente e vai embora do mesmo jeito.',
      palavrasChave: ['tristeza sem motivo', 'nuvem escura', 'desânimo', 'melancolia', 'peso no peito'],
    ),
    FloralModel(
      nome: 'Sweet Chestnut',
      grupo: GruposFlorais.depressao,
      sintomas:
          'Angústia extrema, sensação de ter chegado ao limite da própria '
          'capacidade de suportar, como se não houvesse mais saída.',
      palavrasChave: ['angústia', 'sem saída', 'limite', 'desespero profundo', 'não aguento mais'],
    ),
    FloralModel(
      nome: 'Gorse',
      grupo: GruposFlorais.depressao,
      sintomas:
          'Desespero e desistência diante de uma situação vista como sem '
          'solução; a pessoa já não acredita que as coisas possam melhorar.',
      palavrasChave: ['desistência', 'sem esperança', 'desespero', 'já tentei tudo', 'não tem jeito'],
    ),
    FloralModel(
      nome: 'Agrimony',
      grupo: GruposFlorais.tristeza,
      sintomas:
          'Dor escondida atrás de um sorriso; a pessoa evita conflito e '
          'esconde o tormento interior para não incomodar os outros.',
      palavrasChave: ['máscara', 'sorriso forçado', 'tormento interior', 'esconder a dor', 'fingir que está bem'],
    ),
    FloralModel(
      nome: 'Willow',
      grupo: GruposFlorais.tristeza,
      sintomas:
          'Amargura e ressentimento por sentir que a vida foi injusta; '
          'dificuldade em seguir em frente sem culpar as circunstâncias.',
      palavrasChave: ['ressentimento', 'amargura', 'injustiça', 'vitima', 'raiva contida'],
    ),
    FloralModel(
      nome: 'Star of Bethlehem',
      grupo: GruposFlorais.vazio,
      sintomas:
          'Efeitos de um choque ou luto, recente ou antigo, que deixou uma '
          'sensação de vazio e entorpecimento emocional.',
      palavrasChave: ['luto', 'choque', 'vazio', 'entorpecido', 'perda'],
    ),
    FloralModel(
      nome: 'Wild Rose',
      grupo: GruposFlorais.vazio,
      sintomas:
          'Apatia e resignação; a pessoa segue a rotina sem entusiasmo, '
          'como se nada mais importasse de verdade.',
      palavrasChave: ['apatia', 'vazio', 'sem vontade', 'resignação', 'indiferença'],
    ),
    FloralModel(
      nome: 'Water Violet',
      grupo: GruposFlorais.solidao,
      sintomas:
          'Solidão por reserva e orgulho; a pessoa prefere se isolar a '
          'pedir ajuda e mantém distância mesmo quando sofre.',
      palavrasChave: ['isolamento', 'orgulho', 'reservado', 'distante', 'prefiro ficar sozinho'],
    ),
    FloralModel(
      nome: 'Impatiens',
      grupo: GruposFlorais.solidao,
      sintomas:
          'Solidão por impaciência; a pessoa se irrita com a lentidão dos '
          'outros e acaba afastando quem está por perto.',
      palavrasChave: ['impaciência', 'irritação', 'pressa', 'sozinho', 'ninguém acompanha meu ritmo'],
    ),
    FloralModel(
      nome: 'Heather',
      grupo: GruposFlorais.solidao,
      sintomas:
          'Solidão por carência; necessidade constante de companhia e de '
          'falar sobre si mesmo, com dificuldade de ficar em silêncio.',
      palavrasChave: ['carência', 'carente', 'preciso de atenção', 'falar de mim', 'medo de ficar só'],
    ),
    FloralModel(
      nome: 'Holly',
      grupo: GruposFlorais.odio,
      sintomas:
          'Raiva, ciúme e hostilidade que surgem sem razão clara, muitas '
          'vezes escondendo uma dor ou insegurança por trás.',
      palavrasChave: ['raiva', 'odio', 'ciúme', 'hostilidade', 'inveja'],
    ),
    FloralModel(
      nome: 'Vervain',
      grupo: GruposFlorais.doresNoCorpo,
      sintomas:
          'Tensão nervosa por excesso de esforço e convicção; a pessoa se '
          'entrega demais até o corpo cobrar a conta em forma de esgotamento.',
      palavrasChave: ['tensão', 'esgotamento', 'excesso de esforço', 'estresse', 'não sei parar'],
    ),
    FloralModel(
      nome: 'Olive',
      grupo: GruposFlorais.doresNoCorpo,
      sintomas:
          'Exaustão física e mental profunda, após esforço prolongado, sem '
          'energia nem para as tarefas mais simples do dia.',
      palavrasChave: ['exaustão', 'cansaço extremo', 'sem energia', 'esgotamento físico', 'fadiga'],
    ),
    FloralModel(
      nome: 'Oak',
      grupo: GruposFlorais.doresNoCorpo,
      sintomas:
          'Luta além dos próprios limites por senso de dever; a pessoa '
          'continua se esforçando mesmo exausta, sem se permitir parar.',
      palavrasChave: ['excesso de responsabilidade', 'não posso parar', 'cansaço acumulado', 'força mesmo exausto'],
    ),
    FloralModel(
      nome: 'Rock Water',
      grupo: GruposFlorais.doresNoCorpo,
      sintomas:
          'Rigidez autoimposta; corpo tenso por exigir demais de si mesmo, '
          'seguindo padrões e regras rígidas sem flexibilidade.',
      palavrasChave: ['rigidez', 'tensão muscular', 'autoexigência', 'perfeccionismo', 'corpo tenso'],
    ),
  ];
}
