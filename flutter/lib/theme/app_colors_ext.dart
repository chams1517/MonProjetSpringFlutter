import 'package:flutter/material.dart';

@immutable
class AppColorsExt extends ThemeExtension<AppColorsExt> {
  final Color etatStock;
  final Color etatAffecte;
  final Color etatPanne;
  final Color etatReparation;
  final Color etatRepare;
  final Color etatHorsService;

  const AppColorsExt({
    required this.etatStock,
    required this.etatAffecte,
    required this.etatPanne,
    required this.etatReparation,
    required this.etatRepare,
    required this.etatHorsService,
  });

  static const light = AppColorsExt(
    etatStock: Color(0xFF6B7078),
    etatAffecte: Color(0xFF0F9D6C),
    etatPanne: Color(0xFFC13F39),
    etatReparation: Color(0xFFB4780F),
    etatRepare: Color(0xFF0F9D6C),
    etatHorsService: Color(0xFF9A9D9F),
  );

  static const dark = AppColorsExt(
    etatStock: Color(0xFF7A7F86),
    etatAffecte: Color(0xFF3DDC97),
    etatPanne: Color(0xFFE2554E),
    etatReparation: Color(0xFFE8A33D),
    etatRepare: Color(0xFF3DDC97),
    etatHorsService: Color(0xFF585C61),
  );

  @override
  AppColorsExt copyWith({
    Color? etatStock,
    Color? etatAffecte,
    Color? etatPanne,
    Color? etatReparation,
    Color? etatRepare,
    Color? etatHorsService,
  }) {
    return AppColorsExt(
      etatStock: etatStock ?? this.etatStock,
      etatAffecte: etatAffecte ?? this.etatAffecte,
      etatPanne: etatPanne ?? this.etatPanne,
      etatReparation: etatReparation ?? this.etatReparation,
      etatRepare: etatRepare ?? this.etatRepare,
      etatHorsService: etatHorsService ?? this.etatHorsService,
    );
  }

  @override
  AppColorsExt lerp(ThemeExtension<AppColorsExt>? other, double t) {
    if (other is! AppColorsExt) return this;
    return AppColorsExt(
      etatStock: Color.lerp(etatStock, other.etatStock, t)!,
      etatAffecte: Color.lerp(etatAffecte, other.etatAffecte, t)!,
      etatPanne: Color.lerp(etatPanne, other.etatPanne, t)!,
      etatReparation: Color.lerp(etatReparation, other.etatReparation, t)!,
      etatRepare: Color.lerp(etatRepare, other.etatRepare, t)!,
      etatHorsService: Color.lerp(etatHorsService, other.etatHorsService, t)!,
    );
  }
}


extension AppColorsExtGetter on BuildContext {
  AppColorsExt get appColors => Theme.of(this).extension<AppColorsExt>()!;
}