import 'package:flutter/material.dart';
import 'package:ease_neura/models/floral_model.dart';

/// Cores e raios reaproveitados do resto do app: EaseNeura é
/// deliberadamente monocromático (preto/branco/cinza), com bordas pretas
/// sólidas de 1px e cantos de 19px nos cards de conteúdo (mesmo padrão dos
/// widgets "Consultation" e "Threads" da Home). Nada de paleta nova.
class FloralColors {
  static const background = Colors.white;
  static const surface = Colors.white;
  static const ink = Colors.black;
  static const muted = Color(0xFF6D6D6D); // mesmo cinza do SearchBar da Home
  static const border = Colors.black;
  static const cardRadius = 19.0;
}

class FloralCard extends StatelessWidget {
  final FloralModel floral;

  const FloralCard({Key? key, required this.floral}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: FloralColors.surface,
        borderRadius: BorderRadius.circular(FloralColors.cardRadius),
        border: Border.all(color: FloralColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  floral.nome,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Nunito-Bold',
                    color: FloralColors.ink,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _GrupoBadge(grupo: floral.grupo),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            floral.sintomas,
            style: const TextStyle(
              fontSize: 13.5,
              height: 1.45,
              fontFamily: 'Nunito-Regular',
              color: FloralColors.ink,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: floral.palavrasChave.map((tag) => _TagChip(texto: tag)).toList(),
          ),
        ],
      ),
    );
  }
}

class _GrupoBadge extends StatelessWidget {
  final String grupo;

  const _GrupoBadge({required this.grupo});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        grupo,
        style: const TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
          color: Colors.white,
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String texto;

  const _TagChip({required this.texto});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        texto,
        style: const TextStyle(
          fontSize: 11,
          fontFamily: 'Nunito-Regular',
          color: FloralColors.muted,
        ),
      ),
    );
  }
}
