import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/login/view/login_page.dart';
import '../../features/auth/register/view/register_page.dart';
import '../../features/main/view/main_page.dart';
import '../../features/splash/view/splash_page.dart';
import '../../features/splash/cubit/splash_cubit.dart';

class AppRouter {
  static const String login = '/login';
  static const String register = '/register';
  static const String main = '/main';
  static const String splash = '/splash';


  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        name: 'splash',
        builder: (context, state) => BlocProvider(
          create: (context) => SplashCubit(),
          child: const SplashPage(),
        ),
      ),
      GoRoute(
        path: login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: register,
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: main,
        name: 'main',
        builder: (context, state) => const MainPage(),
      ),
    ],
  );
}

