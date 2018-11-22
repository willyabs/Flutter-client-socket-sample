import 'package:client_socket_sample/Connector.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'client socket test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'client socket test'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          Text(
            'Connection status: $connected',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            'Enter the server IP:',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Container(
            margin: const EdgeInsets.all(13.0),
            child: TextField(
              controller: myController,
            ),
          ),
          Container(
            margin: const EdgeInsets.all(13.0),
            child: RaisedButton(
                onPressed: () {
                  print("click: connect");
                  connect();
                },
                child: Text("connect to server")),
          ),
          Container(
            margin: const EdgeInsets.all(13.0),
            child: RaisedButton(
                onPressed: () {
                  print("click: send");
                  sendData();
                },
                child: Text("send data to server")),
          ),
          Container(
            margin: const EdgeInsets.all(13.0),
            child: RaisedButton(
                onPressed: () {
                  print("click: disconnect");
                  disconnect();
                },
                child: Text("disconnect")),
          ),
        ],
      ),
    );
  }

  bool connected = false;
  Connector connector;

  void connect() {
    connector = Connector(myController.text);
    connector.connect().then((v) {
      print("connnected:$v");
      setState(() {
        connected = v;
      });
    });
  }

  void sendData() {
    if (connected && connector != null) {
      connector.sendMessage(List.filled(1000, 1));
    }
  }

  void disconnect() {
    if (connector != null) {
      connector.disconnect();
      connector = null;
      connected = false;
    }
  }
}
