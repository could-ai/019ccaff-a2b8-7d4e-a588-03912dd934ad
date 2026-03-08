import 'package:flutter/material.dart';
import 'package:couldai_user_app/tickets/ticket_screen.dart';
import 'package:couldai_user_app/finance/finance_screen.dart';
import 'package:couldai_user_app/home/home_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema Integrado',
      debugShowCheckedModeBanner: false,
      
      // Configuração de Localização para Data/Moeda
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 2,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/tickets': (context) => const TicketListScreen(),
        '/new-ticket': (context) => const TicketFormScreen(),
        '/finance': (context) => const FinanceHomeScreen(),
        '/finance/new': (context) => const TransactionFormScreen(),
      },
    );
  }
}
