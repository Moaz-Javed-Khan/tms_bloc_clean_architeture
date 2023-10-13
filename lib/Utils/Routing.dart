import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project_cleanarchiteture/Features/CRUD/screen/user.dart';
import 'package:project_cleanarchiteture/Features/auth/CreateNewPassword/presentation/screens/CreateNewPasswordScreen.dart';
import 'package:project_cleanarchiteture/Features/auth/ForgetPassword/presentation/screens/ForgetPasswordScreen.dart';
import 'package:project_cleanarchiteture/Features/auth/Login/Presentation/screens/HomeScreen.dart';
import 'package:project_cleanarchiteture/Features/auth/Login/Presentation/screens/LoginScreen.dart';
import 'package:project_cleanarchiteture/Features/auth/OTP/presentation/pages/OtpScreen.dart';
import 'package:project_cleanarchiteture/Features/auth/Signup/Presentation/screens/SignupScreen.dart';
import 'package:project_cleanarchiteture/Features/pagination/view/AllUsersScreen.dart';
import 'package:project_cleanarchiteture/SplashScreen.dart';

const String SPLASH = "/splash";
const String SIGNIN = "/signin";
const String SIGNUP = "/signup";
const String FORGET_PASSWORD = "/forgetPassword";
const String OTP = "/otp";
const String CREATE_NEW_PASSWORD = "/createNewPassword";
const String HOME = "/home";

const String USER = "/user";
const String Get_All_User = "/getAllUser";

// class Routes {

final GoRouter routes = GoRouter(
  routes: [
    GoRoute(
      path: "/",
      builder: (BuildContext context, GoRouterState state) {
        return const SplashView();
      },
    ),
    GoRoute(
      path: USER,
      builder: (BuildContext context, GoRouterState state) {
        return const User();
        // return const UserPage();
      },
    ),
    GoRoute(
      path: SIGNIN,
      pageBuilder: ((context, state) {
        return CustomTransitionPage(
          transitionDuration: const Duration(seconds: 2),
          key: state.pageKey,
          child: SignInView(),
          transitionsBuilder: ((context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity:
                  CurveTween(curve: Curves.easeInOutCirc).animate(animation),
              child: child,
            );
          }),
        );
      }),
    ),
    GoRoute(
      path: SIGNUP,
      pageBuilder: ((context, state) {
        return CustomTransitionPage(
          transitionDuration: const Duration(seconds: 1),
          key: state.pageKey,
          child: SignUpView(),
          transitionsBuilder: ((context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          }),
        );
      }),
    ),
    GoRoute(
      path: FORGET_PASSWORD,
      // builder: (BuildContext context, GoRouterState state) {
      //   return ForgetPasswordView();
      // },
      pageBuilder: ((context, state) {
        return CustomTransitionPage(
          transitionDuration: const Duration(seconds: 1),
          key: state.pageKey,
          child: ForgetPasswordView(),
          transitionsBuilder: ((context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          }),
        );
      }),
    ),
    GoRoute(
      path: OTP,
      builder: (BuildContext context, GoRouterState state) {
        return OtpView(
          email: state.extra.toString(),
        );
      },
    ),
    GoRoute(
      path: '$CREATE_NEW_PASSWORD/:email/:otp',
      name: 'newPass',
      builder: (BuildContext context, GoRouterState state) {
        return CreateNewPasswordView(
          email: state.pathParameters['email']!,
          otp: state.pathParameters['otp']!,
        );
      },
    ),
    GoRoute(
      path: HOME,
      // builder: (BuildContext context, GoRouterState state) {
      //   return const HomeScreen();
      // },
      pageBuilder: ((context, state) {
        return CustomTransitionPage(
          transitionDuration: const Duration(seconds: 1),
          key: state.pageKey,
          child: const HomeScreen(),
          transitionsBuilder: ((context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          }),
        );
      }),
    ),
    GoRoute(
      path: Get_All_User,
      builder: (BuildContext context, GoRouterState state) {
        return AllUsersScreen();
      },
    ),
  ],
);
// }
