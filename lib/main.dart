import 'package:app_tourist_destination/pages/ChatListScreen.dart';
import 'package:app_tourist_destination/pages/Dialog/LoginDialog.dart';
import 'package:app_tourist_destination/pages/ProfileScreen.dart';
import 'package:app_tourist_destination/pages/TravelHomeScreen.dart';
import 'package:app_tourist_destination/pages/WishlistScreen.dart';
import 'package:app_tourist_destination/providers/NavigationProvider.dart';
import 'package:app_tourist_destination/providers/ThemeProvider.dart';
import 'package:app_tourist_destination/providers/WishlistProvider.dart';
import 'package:app_tourist_destination/seeds/database.dart';
import 'package:app_tourist_destination/services/auth.service.dart';
import 'package:app_tourist_destination/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized(); // Required for Firebase initialization
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // seed data
  DatabaseSeeder.runAllSeeds();

  // run facebook sdk
  // await runFacebookSDK();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NavigationProvider()),
        ChangeNotifierProvider(create: (context) => WishlistProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

// Future<void> runFacebookSDK() async {
//   if (kIsWeb) {
//     // initialize the facebook javascript SDK
//     const appId = "23985844671017367";
//     await FacebookAuth.i.webAndDesktopInitialize(
//       appId: appId,
//       cookie: true,
//       xfbml: true,
//       version: "v15.0",
//     );
//   }
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode:
              themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: MainScreen(),
        );
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  AuthService _authService = AuthService();

  final List<Widget> _screens = [
    TravelHomePage(),
    WishlistScreen(),
    ChatListScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // Sử dụng Consumer để lắng nghe thay đổi từ NavigationProvider
    return Consumer<NavigationProvider>(
      builder: (context, navigationProvider, child) {
        return Scaffold(
          // Hiển thị màn hình tương ứng với tab được chọn
          body: _screens[navigationProvider.selectedIndex],
          bottomNavigationBar: BottomNavBar(
            currentIndex: navigationProvider.selectedIndex,
            onTap:
                (index) => {
                  if (index > 0 && _authService.currentUser == null)
                    {showLoginDialog(context)}
                  else
                    {navigationProvider.setIndex(index)},
                },
          ),
        );
      },
    );
  }
}

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({Key? key, this.currentIndex = 0, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor:
          Theme.of(context).bottomNavigationBarTheme.backgroundColor,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          label: 'Yêu thích',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline_outlined),
          label: 'Tin nhắn',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Hồ sơ',
        ),
      ],
    );
  }
}
