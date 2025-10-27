import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/features/customer/bloc/cart/cart_bloc.dart';
import 'package:myapp/features/customer/bloc/cart/cart_event.dart';
import 'package:myapp/features/customer/bloc/product/product_bloc.dart';
import 'package:myapp/core/constants/colors.dart';
import 'package:myapp/features/customer/bloc/product/product_event.dart';
import 'package:myapp/routes/route_generator.dart';
import 'firebase_options.dart'; 

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProductBloc()..add(LoadProducts())),
        BlocProvider(create: (context) => CartBloc()..add(LoadCart())),
      ],
      child: MaterialApp(
        title: 'Butchee',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.background,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.freshGreen, 
            primary: AppColors.primaryRed,
            secondary: AppColors.freshGreen,
            error: AppColors.error,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: AppColors.textPrimary,
            centerTitle: true,
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: AppColors.textPrimary),
            bodyMedium: TextStyle(color: AppColors.textSecondary),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.freshGreen,
              foregroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: AppColors.lightGray,
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.freshGreen),
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.neutralGray),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
