import 'package:flutter/material.dart';
import 'package:ease_neura/screens/floral_guide_screen.dart';
import 'package:ease_neura/widget_home/message_screen.dart';
import 'package:ease_neura/widget_home/profile_screen.dart';

/// Tela raiz do app depois do login.
///
/// Estrutura:
/// - `_HomeTab`  -> conteúdo da Home (saudação, data, carrossel estilo iOS).
/// - `IndexedStack` -> mantém as 4 abas (Home, Florais, Mensagens, Perfil)
///   vivas ao mesmo tempo, então trocar de aba não reconstrói nem perde o
///   estado de nenhuma delas (sem "piscadas" na tela).
/// - Navbar flutuante em formato de pílula, sempre visível por cima do
///   conteúdo (fica num `Stack`, não em `bottomNavigationBar`), então ela
///   nunca some ao trocar de aba.
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // `late final` + criado uma única vez em initState: garante que os widgets
  // das abas nunca sejam recriados quando a HomePage der rebuild (ex: ao
  // trocar de aba e chamar setState), preservando o estado interno de cada
  // uma dentro do IndexedStack.
  late final List<Widget> _tabs;

  static const List<_NavItemData> _navItems = [
    _NavItemData(icon: Icons.home_rounded, label: 'Home'),
    _NavItemData(icon: Icons.spa_rounded, label: 'Florais'),
    _NavItemData(icon: Icons.chat_bubble_rounded, label: 'Mensagens'),
    _NavItemData(icon: Icons.person_rounded, label: 'Perfil'),
  ];

  @override
  void initState() {
    super.initState();
    _tabs = const [
      _HomeTab(),
      FloralGuideScreen(),
      MessageScreen(),
      ProfileScreen(),
    ];
  }

  void _onNavTap(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      // extendBody: o conteúdo das abas pode desenhar por trás da área da
      // navbar flutuante, reforçando o efeito "pill" sobreposto.
      extendBody: true,
      body: Stack(
        children: [
          // As 4 abas ficam todas construídas o tempo todo; só a visível é
          // exibida. Isso é o que evita reconstrução/perda de estado.
          IndexedStack(
            index: _selectedIndex,
            children: _tabs,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _PillNavBar(
              items: _navItems,
              selectedIndex: _selectedIndex,
              onTap: _onNavTap,
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItemData {
  final IconData icon;
  final String label;
  const _NavItemData({required this.icon, required this.label});
}

/// Barra de navegação flutuante em formato de pílula (estilo "floating pill").
///
/// Fica sempre visível (não é `bottomNavigationBar`, então nunca é
/// substituída ou some ao trocar de aba) e destaca o item ativo com uma
/// cápsula preta que desliza suavemente entre as opções.
class _PillNavBar extends StatelessWidget {
  final List<_NavItemData> items;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _PillNavBar({
    required this.items,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.only(bottom: 16),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 32),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.92),
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(items.length, (index) {
            final bool isSelected = index == selectedIndex;
            return _PillNavItem(
              data: items[index],
              isSelected: isSelected,
              onTap: () => onTap(index),
            );
          }),
        ),
      ),
    );
  }
}

class _PillNavItem extends StatelessWidget {
  final _NavItemData data;
  final bool isSelected;
  final VoidCallback onTap;

  const _PillNavItem({
    required this.data,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 18 : 12,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              data.icon,
              size: 22,
              color: isSelected ? Colors.black : Colors.white70,
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              child: isSelected
                  ? Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        data.label,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: Colors.black,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Aba Home: saudação, data e carrossel de cards estilo iOS.
// ---------------------------------------------------------------------------

class _HomeTab extends StatefulWidget {
  const _HomeTab({Key? key}) : super(key: key);

  @override
  State<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<_HomeTab> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        // Padding extra embaixo pra nenhum conteúdo ficar escondido atrás
        // da navbar flutuante (por causa do extendBody: true na Home).
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: _HomeHeader(),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 28),
          ),
          SliverToBoxAdapter(
            child: _AppleStyleCarousel(cards: _homeInfoCards),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 140),
          ),
        ],
      ),
    );
  }
}

/// Saudação + data atual formatada em português.
class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Olá, Terapeuta',
          style: TextStyle(
            fontFamily: 'Nunito-Bold',
            fontWeight: FontWeight.bold,
            fontSize: 26,
            color: Colors.black,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          _formatarDataAtual(DateTime.now()),
          style: TextStyle(
            fontFamily: 'Nunito-Regular',
            fontSize: 15,
            color: Colors.black.withOpacity(0.5),
            letterSpacing: -0.1,
          ),
        ),
      ],
    );
  }
}

const List<String> _diasDaSemanaPt = [
  'Domingo',
  'Segunda-feira',
  'Terça-feira',
  'Quarta-feira',
  'Quinta-feira',
  'Sexta-feira',
  'Sábado',
];

const List<String> _mesesPt = [
  'Janeiro',
  'Fevereiro',
  'Março',
  'Abril',
  'Maio',
  'Junho',
  'Julho',
  'Agosto',
  'Setembro',
  'Outubro',
  'Novembro',
  'Dezembro',
];

/// Formata a data como "Quarta-feira, 2 de Setembro de 2026", sem depender
/// do pacote `intl` (não estava nas dependências do projeto).
String _formatarDataAtual(DateTime data) {
  // DateTime.weekday: 1 = segunda ... 7 = domingo. `_diasDaSemanaPt` começa
  // no domingo (índice 0), então fazemos o módulo pra alinhar os dois.
  final diaSemana = _diasDaSemanaPt[data.weekday % 7];
  final mes = _mesesPt[data.month - 1];
  return '$diaSemana, ${data.day} de $mes de ${data.year}';
}

/// Conteúdo de cada card do carrossel + estilo visual.
class HomeInfoCardData {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final List<Color> gradient;
  final String? imageAsset;

  const HomeInfoCardData({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.gradient,
    this.imageAsset,
  });
}

final List<HomeInfoCardData> _homeInfoCards = [
  const HomeInfoCardData(
    title: 'Como Agem os Florais',
    subtitle: 'Ressonância vibracional',
    description:
        'Os florais atuam pelo princípio da ressonância vibracional: cada '
        'essência carrega um padrão sutil de energia que dialoga com o '
        'campo emocional da pessoa, ajudando a reequilibrar estados como '
        'medo, tristeza ou insegurança — sem agir pela via química, mas '
        'pela via energética e sutil.',
    icon: Icons.spa_rounded,
    gradient: [Color(0xFF3AAFA9), Color(0xFF16697A)],
  ),
  const HomeInfoCardData(
    title: 'Guia de Dosagem',
    subtitle: 'Proporções e frequência',
    description:
        'Frasco de tratamento: geralmente 2 a 4 gotas do(s) floral(is) '
        'escolhido(s) em um frasco de 30 ml com água (mais um conservante, '
        'se necessário). Uso diário: 4 gotas do frasco, 4 vezes ao dia. '
        'Em situações agudas, as gotas podem ser repetidas com mais '
        'frequência, direto na língua ou diluídas em um pouco de água.',
    icon: Icons.water_drop_rounded,
    gradient: [Color(0xFFE08E45), Color(0xFFC96E12)],
  ),
  const HomeInfoCardData(
    title: 'Métodos de Ajuda Holística',
    subtitle: 'Escuta e ancoragem',
    description:
        'Além dos florais, a abordagem holística envolve escuta ativa e '
        'acolhedora, técnicas de ancoragem no presente (respiração, '
        'aterramento) e suporte emocional contínuo — tratando a pessoa de '
        'forma integral, não apenas o sintoma pontual.',
    icon: Icons.self_improvement_rounded,
    gradient: [Color(0xFF7B6FD1), Color(0xFF4C3F91)],
  ),
];

/// Carrossel horizontal estilo Apple: cards com bordas arredondadas
/// elegantes, sombra suave, snapping por página e leve efeito de escala/
/// profundidade nos cards vizinhos enquanto o usuário rola.
class _AppleStyleCarousel extends StatefulWidget {
  final List<HomeInfoCardData> cards;
  const _AppleStyleCarousel({required this.cards});

  @override
  State<_AppleStyleCarousel> createState() => _AppleStyleCarouselState();
}

class _AppleStyleCarouselState extends State<_AppleStyleCarousel> {
  late final PageController _controller;
  double _page = 0;

  static const double _viewportFraction = 0.82;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: _viewportFraction);
    _controller.addListener(() {
      setState(() => _page = _controller.page ?? 0);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openDetails(HomeInfoCardData card) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _CardDetailsSheet(card: card),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      child: PageView.builder(
        controller: _controller,
        // PageView já entrega o efeito de "encaixe" (snapping) nativo do
        // iOS; a física com bounce deixa a rolagem mais fluida/suave.
        physics: const BouncingScrollPhysics(
          parent: PageScrollPhysics(),
        ),
        padEnds: false,
        itemCount: widget.cards.length,
        itemBuilder: (context, index) {
          final double delta = (_page - index).abs().clamp(0.0, 1.0);
          // Card focado fica levemente maior e mais "à frente" — o mesmo
          // efeito de profundidade usado em carrosséis estilo Apple.
          final double scale = 1 - (delta * 0.10);
          final double verticalShift = delta * 12;

          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 24 : 8,
              right: 8,
            ),
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..translate(0.0, verticalShift)
                ..scale(scale),
              child: _HomeInfoCard(
                data: widget.cards[index],
                onTap: () => _openDetails(widget.cards[index]),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HomeInfoCard extends StatelessWidget {
  final HomeInfoCardData data;
  final VoidCallback onTap;

  const _HomeInfoCard({required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Área visual dedicada à imagem/ícone do card. Se `imageAsset`
            // for informado, a imagem é usada; caso contrário, cai num
            // fundo em gradiente com um ícone ilustrativo — assim o card
            // já funciona hoje e aceita imagens reais depois sem mudar
            // a estrutura.
            Expanded(
              flex: 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (data.imageAsset != null)
                    Image.asset(data.imageAsset!, fit: BoxFit.cover)
                  else
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: data.gradient,
                        ),
                      ),
                    ),
                  Positioned(
                    right: 14,
                    bottom: -10,
                    child: Icon(
                      data.icon,
                      size: 72,
                      color: Colors.white.withOpacity(0.22),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    top: 14,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.22),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(data.icon, size: 20, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      data.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Nunito-Bold',
                        fontWeight: FontWeight.bold,
                        fontSize: 15.5,
                        color: Colors.black,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      data.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Nunito-Regular',
                        fontSize: 12.5,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bottom sheet com o conteúdo completo do card, aberta ao tocar nele.
class _CardDetailsSheet extends StatelessWidget {
  final HomeInfoCardData card;
  const _CardDetailsSheet({required this.card});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: card.gradient,
                ),
              ),
              child: Icon(card.icon, color: Colors.white, size: 26),
            ),
            const SizedBox(height: 16),
            Text(
              card.title,
              style: const TextStyle(
                fontFamily: 'Nunito-Bold',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              card.description,
              style: TextStyle(
                fontFamily: 'Nunito-Regular',
                fontSize: 15,
                height: 1.5,
                color: Colors.black.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
