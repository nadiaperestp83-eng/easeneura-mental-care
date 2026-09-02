/// Constantes de layout compartilhadas entre as telas que vivem dentro do
/// `IndexedStack` de [HomePage] (Home, Florais, Mensagens, Perfil).
///
/// A navbar em formato de pílula é desenhada sobre o conteúdo (dentro de um
/// `Stack`, com `Scaffold.extendBody: true`), então nenhuma das abas ganha
/// um `bottomNavigationBar` "de verdade" que reserve espaço automaticamente.
/// Por isso cada tela precisa aplicar manualmente esse espaçamento inferior
/// ao seu conteúdo rolável (ou ao seu campo de digitação fixo) para garantir
/// que nada fique escondido atrás da pílula.

/// Altura aproximada da pílula em si (padding interno + conteúdo dos ícones).
const double kPillNavBarHeight = 62.0;

/// Distância mínima que a `SafeArea` da pílula reserva entre ela e a borda
/// inferior da tela (ver `_PillNavBar` em `home_screen.dart`).
const double kPillNavBarBottomInset = 16.0;

/// Espaço total que o conteúdo de qualquer aba deve reservar na parte de
/// baixo para nunca ficar coberto pela pílula, já incluindo uma folga extra
/// de respiro visual entre o conteúdo e a navbar.
const double kPillNavBarClearance =
    kPillNavBarHeight + kPillNavBarBottomInset + 22.0;
