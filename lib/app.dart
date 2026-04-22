import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/theme.dart';
import 'features/home/cubit/home_cubit.dart';
import 'features/home/screens/home_screen.dart';

class GymTrackerApp extends StatelessWidget {
  const GymTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeCubit>(create: (context) => HomeCubit()),
      ],
      child: MaterialApp(
        title: 'Gym Tracker',
        debugShowCheckedModeBanner: false,
        theme: appThemeDark(),
        home: const HomeScreen(),
        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          );
        },
      ),
    );
  }
}
