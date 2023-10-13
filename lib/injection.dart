// import 'package:get_it/get_it.dart';
// import 'package:project_cleanarchiteture/Features/Login/Data/datasource/LoginRemoteDatasource.dart';
// import 'package:project_cleanarchiteture/Features/Login/Data/repositories/LoginRepositoryImple.dart';
// import 'package:project_cleanarchiteture/Features/Login/Domain/repositories/LoginRepository.dart';
// import 'package:project_cleanarchiteture/Features/Login/Domain/usecases/userlogin.dart';
// import 'package:project_cleanarchiteture/Features/Login/Presentation/bloc/login_bloc.dart';

// final sl = GetIt.instance;

// Future<void> init() async {
//   // NEWS:

//   // Data

//   // DataSources
//   sl.registerLazySingleton<LoginRemoteDatasource>(
//       () => LoginRemoteDatasourceImpl(graphQLClient: sl()));

//   // Repositories
//   sl.registerLazySingleton<LoginRepository>(
//       () => LoginRepositoryImple(remotedatasources: sl()));

//   // Domain

//   // Usecases
//   sl.registerLazySingleton(() => userloginUsecase(repository: sl()));

//   // Presentation

//   // BLoC
//   sl.registerFactory(() => LoginBloc(loginRepo: sl()));
// }
