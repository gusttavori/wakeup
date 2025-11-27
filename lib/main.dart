import 'package:flutter/material.dart'; // Mudança principal de import
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_theme.dart';
import 'screens/alarm_screen/alarm_screen.dart';
import 'screens/stopwatch_screen.dart';
import 'screens/task_screen/task_screen.dart';
import 'screens/timer_screen.dart';

void main() {
  runApp(const WakeUpApp());
}

class WakeUpApp extends StatelessWidget {
  const WakeUpApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp( // Substituído CupertinoApp por MaterialApp
      title: 'WakeUp',
      debugShowCheckedModeBanner: false,
      // Delegates funcionam para ambos, mantivemos
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate, // Mantido para compatibilidade interna
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
        Locale('en', 'US'),
      ],
      // Adaptação do Tema para Material Design 3
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        // primaryColor é menos usado no Material 3, preferimos colorScheme
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryBlue,
          background: AppColors.backgroundLight,
          surface: AppColors.surfaceLight,
        ),
        scaffoldBackgroundColor: AppColors.backgroundLight,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.surfaceLight,
          surfaceTintColor: Colors.transparent, // Remove tint do scroll
        ),
        // Mapeando os estilos de texto
        textTheme: TextTheme(
          bodyMedium: AppTextStyles.body,
          titleLarge: AppTextStyles.navTitle,
          headlineMedium: AppTextStyles.largeTitle,
        ),
      ),
      home: const MainTabScaffold(),
    );
  }
}

// Convertemos para StatefulWidget para gerenciar o 'currentIndex' da barra
class MainTabScaffold extends StatefulWidget {
  const MainTabScaffold({Key? key}) : super(key: key);

  @override
  State<MainTabScaffold> createState() => _MainTabScaffoldState();
}

class _MainTabScaffoldState extends State<MainTabScaffold> {
  int _selectedIndex = 0; // Estado que controla qual aba está ativa

  // Lista das telas (mesma ordem dos ícones)
  final List<Widget> _screens = const [
    AlarmScreen(),
    StopwatchScreen(),
    TimerScreen(),
    TaskScreen(),
  ];

  // Função para atualizar o estado quando clicar na aba
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack preserva o estado das telas (ex: cronômetro rodando)
      // assim como o CupertinoTabScaffold fazia.
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        // NavigationBar é o componente mais moderno do Material 3. 
        // Se preferir o visual antigo, use BottomNavigationBar.
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        backgroundColor: AppColors.surfaceLight,
        indicatorColor: AppColors.primaryBlue.withOpacity(0.2),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.alarm_outlined),
            selectedIcon: Icon(Icons.alarm),
            label: 'Alarmes',
          ),
          NavigationDestination(
            icon: Icon(Icons.timer_outlined),
            selectedIcon: Icon(Icons.timer),
            label: 'Cronômetro', // Mapeado de Stopwatch
          ),
          NavigationDestination(
            icon: Icon(Icons.hourglass_empty),
            selectedIcon: Icon(Icons.hourglass_full),
            label: 'Temporizador', // Mapeado de Timer
          ),
          NavigationDestination(
            icon: Icon(Icons.list),
            selectedIcon: Icon(Icons.list_alt),
            label: 'Tarefas',
          ),
        ],
      ),
    );
  }
}