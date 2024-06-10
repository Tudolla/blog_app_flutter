import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract interface class ConnectionCheck {
  Future<bool> get isConnected;
}

class ConnectionCheckImpl implements ConnectionCheck {
  final InternetConnection internetConnection;
  ConnectionCheckImpl(this.internetConnection);
  @override
  // TODO: implement isConnected
  Future<bool> get isConnected async =>
      await internetConnection.hasInternetAccess;
}
