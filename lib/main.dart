import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_cleanarchiteture/Features/auth/CreateNewPassword/data/datasources/CreateNewPasswordRemoteDatasource.dart';
import 'package:project_cleanarchiteture/Features/auth/CreateNewPassword/data/repositories/CreateNewPasswordRepositoryImple.dart';
import 'package:project_cleanarchiteture/Features/auth/CreateNewPassword/presentation/bloc/create_new_password_bloc.dart';
import 'package:project_cleanarchiteture/Features/auth/ForgetPassword/Data/repositories/ForgetPasswordRepositoryImple.dart';
import 'package:project_cleanarchiteture/Features/auth/ForgetPassword/data/datasources/ForgetPasswordRemoteDatasource.dart';
import 'package:project_cleanarchiteture/Features/auth/ForgetPassword/presentation/bloc/forget_password_bloc.dart';
import 'package:project_cleanarchiteture/Features/auth/Login/Data/datasource/LoginRemoteDatasource.dart';
import 'package:project_cleanarchiteture/Features/auth/Login/Data/repositories/LoginRepositoryImple.dart';
import 'package:project_cleanarchiteture/Features/auth/Login/Presentation/bloc/login_bloc.dart';
import 'package:project_cleanarchiteture/Features/auth/Logout/Data/datasources/LogoutRemoteDatasource.dart';
import 'package:project_cleanarchiteture/Features/auth/Logout/Data/repositories/LogoutRepositoryImple.dart';
import 'package:project_cleanarchiteture/Features/auth/Logout/Presentation/bloc/logout_bloc.dart';
import 'package:project_cleanarchiteture/Features/auth/OTP/data/repositories/OtpRepositoryImple.dart';
import 'package:project_cleanarchiteture/Features/auth/OTP/presentation/bloc/otp_bloc.dart';
import 'package:project_cleanarchiteture/Features/auth/Otp/data/datasources/OtpRemoteDatasource.dart';
import 'package:project_cleanarchiteture/Features/auth/Signup/Data/datasources/SignupRemoteDatasource.dart';
import 'package:project_cleanarchiteture/Features/auth/Signup/Data/repositories/SignupRepositoryImple.dart';
import 'package:project_cleanarchiteture/Features/auth/Signup/Presentation/bloc/signup_bloc.dart';
import 'package:project_cleanarchiteture/Features/pagination/bloc/all_users_bloc.dart';
import 'package:project_cleanarchiteture/Features/pagination/repo/get_all_user_repository.dart';
import 'package:project_cleanarchiteture/Utils/Routing.dart';

class SimpleBlocDelegate extends FlowDelegate {
  @override
  void onTransition(Transition transition) {
    print(transition.toString());
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    // TODO: implement paintChildren
  }

  @override
  bool shouldRepaint(covariant FlowDelegate oldDelegate) {
    // TODO: implement shouldRepaint
    throw UnimplementedError();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  // await di.init();

  // getit.registerSingleton<LoginRemoteDatasource>(LoginRemoteDatasourceImpl());

  // getit.registerSingleton<LoginRepository>(
  //     LoginRepositoryImple(remotedatasources: getit<LoginRemoteDatasource>()));

  // final bloc = LoginBloc(loginRepo: LoginRepository());

  //  BlocSupervisor().delegate = SimpleBlocDelegate();
  runApp(Login());
}

class Login extends StatelessWidget {
  Login({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // BlocProvider<LoginBloc>(create: (context) => di.sl<LoginBloc>()),
        BlocProvider(
          create: (context) => LoginBloc(
            loginRepo: LoginRepositoryImple(
              remotedatasources: LoginRemoteDatasourceImpl(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => SignupBloc(
            signupRepo: SignupRepositoryImple(
              remotedatasources: SignupRemoteDatasourceImpl(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => ForgetPasswordBloc(  
            forgetPasswordRepo: ForgetPasswordRepositoryImple(
              remotedatasources: ForgetPasswordRemoteDatasourceImpl(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => OtpBloc(
            otpRepo: OtpRepositoryImple(
              remotedatasources: OtpRemoteDatasourceImpl(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => CreateNewPasswordBloc(
            createNewPasswordRepo: CreateNewPasswordRepositoryImple(
              remotedatasources: CreateNewPasswordRemoteDatasourceImpl(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => LogoutBloc(
            logoutRepo: LogoutRepositoryImple(
              remotedatasources: LogoutRemoteDatasourceImpl(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => AllUsersBloc(
            getAllUsersRepo: GetAllUsersRepository(),
          ),
        ),

        // BlocProvider(
        //   create: (_) => UserBloc(
        //     roleLovRepo: RoleLovRepository(),
        //     userLovRepo: UserLovRepository(),
        //   )
        //     ..add(LoadRoleLovEvent())
        //     ..add(LoadUserLovEvent()),
        //   child: const User(),
        // ),
      ],
      child: MaterialApp.router(
        // MaterialApp(
        routerConfig: routes,
        title: 'Authentication',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 73, 59, 95),
          ),
          useMaterial3: true,
        ),
        // home: SignInView(),
      ),
    );
  }
}

// class App extends StatefulWidget {
//   App({Key? key, required this.loginRepository}) : super(key: key);
//   final LoginRepository loginRepository;
//   @override
//   State<App> createState() => _AppState();
// }

// class _AppState extends State<App> {
//   LoginRepository get loginRepository => widget.loginRepository;
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider<AuthenticationBloc>(
//       bloc: authenticationBloc,
//       create: (BuildContext context) {  },
//       child: MaterialApp(
//         home: BlocBuilder<AuthenticationEvent, AuthenticationState>(
//           bloc: authenticationBloc,
//           builder: (BuildContext context, AuthenticationState state) {
//             if (state is AuthenticationUninitialized) {
//               return SplashPage();
//             }
//             if (state is AuthenticationAuthenticated) {
//               return HomePage();
//             }
//             if (state is AuthenticationUnauthenticated) {
//               return LoginPage(loginRepository: loginRepository);
//             }
//             if (state is AuthenticationLoading) {
//               return LoadingIndicator();
//             }
//           },
//         ),
//       ),
//     );
//   }
// }


