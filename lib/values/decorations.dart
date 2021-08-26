part of 'values.dart';

class Decorations {

  static const BoxDecoration primaryButtonDecoration = BoxDecoration(
    color: AppColors.secondaryElement,
    boxShadow: [
      Shadows.secondaryShadow,
    ],
    borderRadius: BorderRadius.all(Radius.circular(Sizes.RADIUS_8)),
  );

  static const BoxDecoration categoryButtonDecoration = BoxDecoration(
      gradient: Gradients.secondaryGradient2,
      boxShadow: [
        Shadows.secondaryShadow,
      ],
    borderRadius: BorderRadius.all(
      Radius.circular(Sizes.RADIUS_8),
    )
  );



  static const BoxDecoration horizontalBarDecoration = BoxDecoration(
    color: Color.fromARGB(255, 248, 249, 255),
  );
}
