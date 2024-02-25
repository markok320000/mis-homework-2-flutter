import 'dart:io';

class StompSocket {
  static var _nextId = 0;

  // final String destination;
  final String hostname;

  late WebSocket _socket;

  StompSocket({this.hostname = "http://192.168.0.11:8080/ws"});

  Future<void> connect() async {
    _socket = await WebSocket.connect(hostname);
    print(_socket);
    _socket.listen(_updateReceived);

    _socket.add(_buildConnectString());
  }

  void disconnect() {
    _socket.add(_buildDisconnectString());
    // actually we should close the socket after we received the response from the server...
    // so this is not perfect...
    //_socket.close();
  }

  void _updateReceived(dynamic data) {
    final lines = data.toString().split('\n');
    if (lines.length != 0) {
      final command = lines[0];

      if (command == "RECEIPT") {
        // typically this message comes after we send the command in the disconnect() method
        _socket.close();
      } else if (command == "CONNECTED") {
        print('Connected successfully to  @ $hostname');
      } else if (command == "MESSAGE") {}
    }
  }

  String _buildConnectString() {
    return 'CONNECT\naccept-version:1.2\nhost:$hostname\n\n\x00';
  }

  String _buildDisconnectString() {
    return 'DISCONNECT\nreceipt:77\n\n\x00';
  }
}
