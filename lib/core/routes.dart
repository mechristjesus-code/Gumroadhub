import 'package:go_router/go_router.dart';
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/products_screen.dart';
import '../screens/create_product_screen.dart';
import '../screens/analytics_screen.dart';
import '../screens/licenses_screen.dart';
import '../screens/ebook_creator_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/products',
      builder: (context, state) => const ProductsScreen(),
    ),
    GoRoute(
      path: '/create-product',
      builder: (context, state) => const CreateProductScreen(),
    ),
    GoRoute(
      path: '/analytics',
      builder: (context, state) => const AnalyticsScreen(),
    ),
    GoRoute(
      path: '/licenses',
      builder: (context, state) => const LicensesScreen(),
    ),
    GoRoute(
      path: '/ebook-creator',
      builder: (context, state) => const EbookCreatorScreen(),
    ),
  ],
);
