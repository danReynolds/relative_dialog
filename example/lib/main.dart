import 'package:flutter/material.dart';
import 'package:relative_dialog/relative_dialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _alignments = [
    Alignment.bottomLeft,
    Alignment.bottomCenter,
    Alignment.bottomRight,
    Alignment.centerLeft,
    Alignment.center,
    Alignment.centerRight,
    Alignment.topLeft,
    Alignment.topCenter,
    Alignment.topRight,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () async {
                if (_alignments.isEmpty) {
                  return showRelativeDialog(
                    context: context,
                    barrierColor: Colors.transparent,
                    builder: (context) {
                      return Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        color: Colors.green,
                        width: 200,
                        height: 200,
                        child: const Text(
                          'Done!',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  );
                }

                final alignment = _alignments.first;
                await showRelativeDialog(
                  context: context,
                  alignment: alignment,
                  barrierColor: Colors.transparent,
                  builder: (context) {
                    return Container(
                      color: Colors.green,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      width: 80,
                      height: 80,
                      child: Text(
                        '$alignment',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    );
                  },
                );
                setState(() {
                  _alignments.removeAt(0);
                });
              },
              child: Text(
                  _alignments.isEmpty ? 'Done' : 'Next: ${_alignments.first}'),
            );
          },
        ),
      ),
    );
  }
}
