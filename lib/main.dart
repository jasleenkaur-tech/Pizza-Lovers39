import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'models/cart_provider.dart';
import 'models/order_provider.dart';
import 'models/auth_provider.dart';
import 'models/ui_provider.dart';
import 'screens/home_screen.dart';
import 'screens/pizza_screen.dart';
import 'screens/combos_screen.dart';
import 'screens/offers_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/admin_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'utils/app_theme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UiProvider()),
      ],
      child: const PizzaLovers39App(),
    ),
  );
}

class PizzaLovers39App extends StatelessWidget {
  const PizzaLovers39App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pizza Lovers 39',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (auth.isLoggedIn) {
      return const MainNavScreen();
    } else {
      return const WelcomeScreen();
    }
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String? _googleError;

  Future<void> _handleGoogleSignIn() async {
    setState(() => _googleError = null);
    final err = await context.read<AuthProvider>().signInWithGoogle();
    if (!mounted) return;
    if (err != null) {
      setState(() { _googleError = err; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(children: [
            Container(
              width: 100, height: 100,
              decoration: BoxDecoration(
                color: AppTheme.primary, borderRadius: BorderRadius.circular(26),
                boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.4), blurRadius: 24, offset: const Offset(0, 10))]
              ),
              child: const Center(child: Text('🍕', style: TextStyle(fontSize: 54)))
            ),
            const SizedBox(height: 20),
            const Text('Pizza Lovers 39',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppTheme.primary, letterSpacing: 0.5)),
            const SizedBox(height: 6),
            const Text('Authentic Pizzas & More 🔥',
                style: TextStyle(color: AppTheme.textGrey, fontSize: 15)),
            const SizedBox(height: 44),

            _feat('🍕', 'Fresh hand-crafted pizzas'),
            const SizedBox(height: 12),
            _feat('🚀', 'Fast doorstep delivery'),
            const SizedBox(height: 12),
            _feat('🎁', 'Wed & Fri Buy 1 Get 1 FREE'),
            const SizedBox(height: 12),
            _feat('💯', 'Free delivery on orders ₹500+'),
            const SizedBox(height: 48),

            if (_googleError != null) ...[
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8)),
                child: Text(_googleError!, style: const TextStyle(color: Colors.red, fontSize: 12), textAlign: TextAlign.center),
              ),
              const SizedBox(height: 16),
            ],

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: isLoading ? null : _handleGoogleSignIn,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(color: Colors.grey.shade300, width: 1.5),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: isLoading
                    ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: AppTheme.primary))
                    : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Image.asset(
                          'assets/images/google_logo.png',
                          height: 24,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.login, color: Colors.blue),
                        ),
                        const SizedBox(width: 12),
                        const Text('Continue with Google',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF3C4043))),
                      ]),
              ),
            ),

            const SizedBox(height: 16),
            const Text('OR', style: TextStyle(color: AppTheme.textGrey, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            SizedBox(width: double.infinity, child: ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignupScreen())),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Create Account', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)))),
            const SizedBox(height: 14),

            SizedBox(width: double.infinity, child: OutlinedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  side: const BorderSide(color: AppTheme.primary, width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))
                ),
                child: const Text('I already have an account',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.primary)))),

            const SizedBox(height: 32),
            Text('© 2025 Pizza Lovers 39', style: TextStyle(color: Colors.grey.shade400, fontSize: 11)),
          ]),
        ),
      ),
    );
  }

  Widget _feat(String emoji, String text) => Row(children: [
    Container(width: 44, height: 44,
        decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
        child: Center(child: Text(emoji, style: const TextStyle(fontSize: 22)))),
    const SizedBox(width: 14),
    Text(text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.textDark)),
  ]);
}

// ═══════════════════════════════════════════════════════════════
//  MAIN NAV SCREEN
// ═══════════════════════════════════════════════════════════════
class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});
  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  static const _screens = [HomeScreen(), PizzaScreen(), CombosScreen(), OffersScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final ui = context.watch<UiProvider>();
    
    return Consumer<CartProvider>(builder: (context, cart, _) {
      return Scaffold(
        body: IndexedStack(index: ui.currentTab, children: _screens),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: ui.currentTab,
          onTap: (i) => ui.setTab(i),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.local_pizza_outlined), activeIcon: Icon(Icons.local_pizza), label: 'Pizza'),
            BottomNavigationBarItem(icon: Icon(Icons.lunch_dining_outlined), activeIcon: Icon(Icons.lunch_dining), label: 'Combos'),
            BottomNavigationBarItem(icon: Icon(Icons.local_offer_outlined), activeIcon: Icon(Icons.local_offer), label: 'Offers'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), activeIcon: Icon(Icons.person_rounded), label: 'Profile'),
          ],
        ),
        floatingActionButton: cart.itemCount > 0 && ui.currentTab != 0
            ? FloatingActionButton.extended(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
            backgroundColor: AppTheme.primary,
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            label: Text('${cart.itemCount} · ₹${cart.subtotal.toStringAsFixed(0)}',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)))
            : null,
        drawer: Drawer(child: SafeArea(child: Column(children: [
          Container(width: double.infinity, padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(gradient: LinearGradient(colors: [AppTheme.primary, Color(0xFFCC4400)], begin: Alignment.topLeft, end: Alignment.bottomRight)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('🍕', style: TextStyle(fontSize: 40)),
                const SizedBox(height: 8),
                const Text('Pizza Lovers 39', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
                Text('Hello, ${auth.displayName}', style: const TextStyle(color: Colors.white70, fontSize: 13)),
              ])),
          const SizedBox(height: 12),
          ListTile(leading: const Icon(Icons.home_outlined, color: AppTheme.primary), title: const Text('Home'), onTap: () { Navigator.pop(context); ui.setTab(0); }),
          ListTile(leading: const Icon(Icons.shopping_cart_outlined, color: AppTheme.primary), title: const Text('My Cart'), onTap: () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())); }),
          const Divider(),
          if (auth.isAdmin)
            ListTile(leading: const Icon(Icons.admin_panel_settings, color: AppTheme.primary), title: const Text('Admin Panel'), onTap: () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminDashboard())); }),
          ListTile(leading: const Icon(Icons.logout_rounded, color: Colors.red), title: const Text('Logout', style: TextStyle(color: Colors.red)), onTap: () async {
                Navigator.pop(context);
                await context.read<AuthProvider>().logout();
              }),
          const Spacer(),
          Padding(padding: const EdgeInsets.all(16), child: Text('© 2025 Pizza Lovers 39', style: TextStyle(color: Colors.grey.shade400, fontSize: 11))),
        ]))),
      );
    });
  }
}
