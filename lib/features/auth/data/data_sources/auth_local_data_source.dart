import 'package:injectable/injectable.dart';

abstract class AuthLocalDataSource {}

@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {}
