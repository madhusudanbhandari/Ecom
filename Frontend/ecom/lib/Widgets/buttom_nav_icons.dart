import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Providers/cart_provider.dart';

final activeTabProvider = StateProvider<String>((ref) => 'home');

//final cartCountProvider = StateProvider<int>((ref) => 0);

final cartCountProvider = Provider<int>((ref) {
  final cart = ref.watch(cartProvider);

  return cart.fold(0, (sum, item) => sum + item.quantity);
});

class ButtomNavBar extends ConsumerWidget {
  const ButtomNavBar({super.key});

  static const _tabs = [
    _TabData('home', Icons.home_outlined, 'Home'),
    _TabData('search', Icons.search_outlined, 'Search'),
    _TabData('bag', Icons.shopping_bag_outlined, 'Bag'),
    _TabData('profile', Icons.person_outline, 'Profile'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(activeTabProvider);

    return SizedBox(
      height: 100,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            left: 16,
            right: 16,
            bottom: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _NavButton(tab: _tabs[0], active: active),
                  _NavButton(tab: _tabs[1], active: active),
                  const SizedBox(width: 48),
                  _NavButton(tab: _tabs[2], active: active),
                  _NavButton(tab: _tabs[3], active: active),
                ],
              ),
            ),
          ),
          Positioned(top: 0, child: _CartButton(active: active)),
        ],
      ),
    );
  }
}

class _TabData {
  final String id;
  final IconData icon;
  final String label;
  const _TabData(this.id, this.icon, this.label);
}

class _NavButton extends ConsumerWidget {
  final _TabData tab;
  final String active;
  const _NavButton({required this.tab, required this.active});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isActive = active == tab.id;

    return GestureDetector(
      onTap: () => ref.read(activeTabProvider.notifier).state = tab.id,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 40,
        height: 40,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              tab.icon,
              size: 24,
              color: isActive ? Colors.black : Colors.grey,
            ),
            const SizedBox(height: 4),
            if (isActive)
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CartButton extends ConsumerWidget {
  final String active;
  const _CartButton({required this.active});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isActive = active == 'cart';
    final cartCount = ref.watch(cartCountProvider);

    return GestureDetector(
      onTap: () => ref.read(activeTabProvider.notifier).state = 'cart',
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isActive ? Colors.blue.shade600 : Colors.blue.shade400,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.blue,
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.shopping_cart_outlined,
              color: Colors.white,
              size: 26,
            ),
          ),

          if (cartCount > 0)
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                decoration: const BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),

                child: Center(
                  child: Text(
                    '$cartCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
