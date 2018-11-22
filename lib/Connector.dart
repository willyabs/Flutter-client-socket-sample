import 'dart:io';

class Connector {
  static const bool DEBUG = true;

  SecureSocket _socket;
  String _host;
  static const int PORT = 7777;

  Connector(this._host);

  Future<bool> connect() async {
    try {
      SecurityContext securityContext = SecurityContext();
      _socket = await SecureSocket.connect(
        _host,
        PORT,
        context: securityContext,
        onBadCertificate: _onBadCertificate,
        timeout: Duration(seconds: 10),
      );
    } on SocketException catch (e) {
      print(e.toString());
      return false;
    } on HandshakeException catch (e) {
      print(e.toString());
      return false;
    }

    _socket.setOption(SocketOption.tcpNoDelay, true);

    _socket.listen(_receiveDataFromServer, onError: (error) {
      print(error.toString());
    }, onDone: _socketDisconnected);

    return true;
  }

  bool _onBadCertificate(X509Certificate certificate) {
    return true;
  }

  void _receiveDataFromServer(data) {
    if (DEBUG) print("_receiveDataFromServer");
  }

  void _socketDisconnected() {
    if (DEBUG) print("_socketDisconnected");
    _socket = null;
  }

  void disconnect() {
    if (_socket != null) {
      _socket.destroy();
    }
  }

  void sendMessage(final List<int> bytes) {
    if (bytes != null && bytes.length > 0) {
      if (_socket != null) {
        print("send bytes len: ${bytes.length}");
        _socket.add(bytes);
      }
    }
  }
}
