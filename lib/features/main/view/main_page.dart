import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/secure_storage_service.dart';
import '../../../core/services/router_service.dart';
import '../../../core/services/logger_service.dart';
import '../../../shared/widgets/custom_bottom_navigation.dart';
import '../../home/view/home_page.dart';
import '../../profile/view/profile_page.dart';
import '../../profile/cubit/profile_cubit.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  late ProfileCubit _profileCubit;
  late List<Widget> _pages;

  void _goToHomePage() {
    setState(() {
      _currentIndex = 0;
    });
  }

  @override
  void initState() {
    super.initState();
    _profileCubit = ProfileCubit(ApiService());

    _pages = [
      HomePage(
        onFavoriteChanged: () {
          LoggerService.debug('Favorite changed, refreshing profile favorites');
          // Favori değiştiğinde profili yenile
          _profileCubit.refreshFavorites();
        },
      ),
      ProfilePage(
        key: const ValueKey('profile_page'),
        onBackPressed: _goToHomePage,
      ),
    ];
  }

  @override
  void dispose() {
    _profileCubit.close();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    // Back button'a basınca logout yap
    await SecureStorageService.clearAll();
    if (mounted) {
      context.go(AppRouter.login);
    }
    return false; // Normal back navigation'ı engelle
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          await _onWillPop();
        }
      },
      child: BlocProvider.value(
        value: _profileCubit,
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: IndexedStack(index: _currentIndex, children: _pages),
          bottomNavigationBar: CustomBottomNavigation(
            selectedIndex: _currentIndex,
            onItemTapped: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
