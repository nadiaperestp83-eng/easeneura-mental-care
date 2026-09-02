import 'package:flutter/material.dart';
import 'package:ease_neura/data/floral_repository.dart';
import 'package:ease_neura/models/floral_model.dart';
import 'package:ease_neura/widgets/floral_card.dart';

/// Tela principal do guia de consulta rápida dos Florais de Bach.
///
/// 100% offline: filtra a lista mockada de [FloralRepository] em memória.
class FloralGuideScreen extends StatefulWidget {
  const FloralGuideScreen({Key? key}) : super(key: key);

  @override
  State<FloralGuideScreen> createState() => _FloralGuideScreenState();
}

class _FloralGuideScreenState extends State<FloralGuideScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _termoBusca = '';
  String? _grupoSelecionado; // null = "Todos"

  static const List<String> _categorias = [
    GruposFlorais.depressao,
    GruposFlorais.tristeza,
    GruposFlorais.vazio,
    GruposFlorais.solidao,
    GruposFlorais.odio,
    GruposFlorais.doresNoCorpo,
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<FloralModel> get _resultados {
    final termo = _normalizar(_termoBusca.trim());
    return FloralRepository.florais.where((floral) {
      final passaCategoria = _grupoSelecionado == null || floral.grupo == _grupoSelecionado;
      final passaBusca = termo.isEmpty || floral.textoBusca.contains(termo);
      return passaCategoria && passaBusca;
    }).toList();
  }

  String _normalizar(String texto) {
    const comAcento = 'áàâãäéèêëíìîïóòôõöúùûüçÁÀÂÃÄÉÈÊËÍÌÎÏÓÒÔÕÖÚÙÛÜÇ';
    const semAcento = 'aaaaaeeeeiiiiooooouuuucAAAAAEEEEIIIIOOOOOUUUUC';
    var resultado = texto.toLowerCase();
    for (var i = 0; i < comAcento.length; i++) {
      resultado = resultado.replaceAll(comAcento[i], semAcento[i].toLowerCase());
    }
    return resultado;
  }

  void _alternarCategoria(String categoria) {
    setState(() {
      _grupoSelecionado = _grupoSelecionado == categoria ? null : categoria;
    });
  }

  // Mesmo padrão de AppBar usado em history_screen.dart e
  // mood_tracker_screen.dart: rótulo "Menu" pequeno e cinza + título em
  // negrito, alinhados à direita.
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      flexibleSpace: const Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: EdgeInsets.only(right: 20, bottom: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Menu',
                style: TextStyle(
                  color: Color(0xFF979797),
                  fontSize: 11,
                  fontFamily: 'Nunito-Regular',
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Guia de Florais',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Nunito-Bold',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final resultados = _resultados;

    return Scaffold(
      backgroundColor: FloralColors.background,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: _SearchBar(
              controller: _searchController,
              onChanged: (valor) => setState(() => _termoBusca = valor),
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categorias.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final categoria = _categorias[index];
                final selecionada = _grupoSelecionado == categoria;
                return _CategoriaChip(
                  texto: categoria,
                  selecionada: selecionada,
                  onTap: () => _alternarCategoria(categoria),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: resultados.isEmpty
                ? const _EstadoVazio()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: resultados.length,
                    itemBuilder: (context, index) => FloralCard(floral: resultados[index]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _SearchBar({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    // Mesmo componente visual da SearchBar da Home (home_screen.dart):
    // fundo branco, borda cinza 1px, cantos totalmente arredondados.
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: const Color(0xFF6D6D6D), width: 1),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(fontSize: 14, fontFamily: 'Nunito-Regular', color: FloralColors.ink),
        decoration: InputDecoration(
          hintText: 'Busque por um sentimento: vazio, luto, raiva…',
          hintStyle: const TextStyle(
            color: Color(0xFF6D6D6D),
            fontFamily: 'Nunito',
            fontWeight: FontWeight.bold,
            fontSize: 13.5,
          ),
          prefixIcon: const Icon(Icons.search, color: Color(0xFF6D6D6D), size: 20),
          suffixIcon: controller.text.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFF6D6D6D), size: 18),
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        ),
      ),
    );
  }
}

class _CategoriaChip extends StatelessWidget {
  final String texto;
  final bool selecionada;
  final VoidCallback onTap;

  const _CategoriaChip({required this.texto, required this.selecionada, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selecionada ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black, width: 1),
        ),
        alignment: Alignment.center,
        child: Text(
          texto,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            color: selecionada ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

class _EstadoVazio extends StatelessWidget {
  const _EstadoVazio();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.spa_outlined, size: 36, color: FloralColors.muted),
            SizedBox(height: 12),
            Text(
              'Nenhum floral encontrado para essa busca.',
              textAlign: TextAlign.center,
              style: TextStyle(color: FloralColors.muted, fontFamily: 'Nunito-Regular', fontSize: 13.5),
            ),
          ],
        ),
      ),
    );
  }
}
