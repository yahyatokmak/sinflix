import 'dart:ui';
import 'package:flutter/material.dart';

class JetonBottomNavBar extends StatelessWidget {
  final Function()? onPackageSelected;

  const JetonBottomNavBar({super.key, this.onPackageSelected});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        // Top Blur Drop (ortadaki fon)
        Positioned(
          top: -60,
          left: 92,
          child: Container(
            width: 217,
            height: 217,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFE50914),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: const SizedBox.shrink(),
            ),
          ),
        ),

        // Bottom Blur Drop (alt fon)
        Positioned(
          bottom: -84,
          right: 92,
          child: Container(
            width: 217,
            height: 217,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFE50914),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: const SizedBox.shrink(),
            ),
          ),
        ),

        // Asıl içerik
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const Text(
                  'Sınırlı Teklif',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Jeton paketin\'i seçerek bonus,\n kazanın ve yeni bölümlerin kilidini açın!',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Bonus Container
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const RadialGradient(
                      center: Alignment(0.1, 0),
                      radius: 1.3,
                      colors: [
                        Color.fromRGBO(255, 255, 255, 0.1),
                        Color.fromRGBO(255, 255, 255, 0.03),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Alacağınız Bonuslar",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          _BonusItem.asset(
                            assetPath:
                                'assets/images/diamond_icon/Download 1 - Iconly Pro.png',
                            label: 'Premium\nHesap',
                          ),
                          _BonusItem.asset(
                            assetPath:
                                'assets/images/double_heart_icon/Rectangle 39345.png',
                            label: 'Daha\nFazla Eşleşme',
                          ),
                          _BonusItem.asset(
                            assetPath:
                                'assets/images/up_icon/Rectangle 39346.png',
                            label: 'Öne\nÇıkarma',
                          ),
                          _BonusItem.asset(
                            assetPath:
                                'assets/images/heart_icon/Rectangle 39340.png',
                            label: 'Daha\nFazla Beğeni',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Kilidi açmak için bir jeton paketi seçin',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                // Paket Seçimi
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    _PackageCard(
                      percentage: '+10%',
                      original: '200',
                      total: '330',
                      price: '₺99,99',
                    ),
                    _PackageCard(
                      percentage: '+70%',
                      original: '2.000',
                      total: '3.375',
                      price: '₺799,99',
                      isCenter: true,
                    ),
                    _PackageCard(
                      percentage: '+35%',
                      original: '1.000',
                      total: '1.350',
                      price: '₺399,99',
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Tüm Jetonları Gör Butonu
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE50914),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      onPackageSelected?.call();
                    },
                    child: const Text(
                      'Tüm Jetonları Gör',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static Future<void> show(
    BuildContext context, {
    Function()? onPackageSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      isDismissible: true,
      useSafeArea: false,
      transitionAnimationController: AnimationController(
        duration: const Duration(milliseconds: 250),
        vsync: Navigator.of(context),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
        minHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      builder: (context) => RepaintBoundary(
        child: Stack(
          children: [
            // Simplified blur overlay
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  color: Colors.black.withValues(
                    alpha: 0.4,
                  ), // Blur yerine solid
                ),
              ),
            ),
            // Bottom nav bar content
            Align(
              alignment: Alignment.bottomCenter,
              child: RepaintBoundary(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.7,
                    decoration: const BoxDecoration(color: Colors.black),
                    child: JetonBottomNavBar(
                      onPackageSelected: onPackageSelected,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BonusItem extends StatelessWidget {
  final IconData? icon;
  final String? assetPath;
  final String label;

  const _BonusItem({
    this.icon,
    this.assetPath,
    required this.label,
  });

  const _BonusItem.asset({required this.assetPath, required this.label})
    : icon = null;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EllipseIconContainer(icon: icon, assetPath: assetPath),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 11),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class EllipseIconContainer extends StatelessWidget {
  final IconData? icon;
  final String? assetPath;

  const EllipseIconContainer({super.key, this.icon, this.assetPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        color: const Color(0xFF6F060B),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.2),
            blurRadius: 4,
            spreadRadius: 0.5,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: icon != null
          ? Icon(icon!, color: Colors.white, size: 28)
          : Image.asset(assetPath!, width: 28, height: 28),
    );
  }
}

class _PackageCard extends StatelessWidget {
  final String percentage;
  final String original;
  final String total;
  final String price;
  final bool isCenter;

  const _PackageCard({
    required this.percentage,
    required this.original,
    required this.total,
    required this.price,
    this.isCenter = false,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = const RadialGradient(
      center: Alignment(-0.5, -0.8),
      radius: 1.2,
      colors: [Color(0xFF6F060B), Color(0xFFE50914)],
    );

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(24),
          boxShadow: isCenter
              ? [
                  BoxShadow(
                    color: Colors.purple.withValues(alpha: 0.6),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Text(
              percentage,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              original,
              style: const TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Colors.white54,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$total Jeton',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              price,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
            const Text(
              'Başına haftalık',
              style: TextStyle(fontSize: 11, color: Colors.white54),
            ),
          ],
        ),
      ),
    );
  }
}
