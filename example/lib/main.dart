import 'package:example/gen/alternate_icons.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alternate_icon/flutter_alternate_icon.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Alternate Icon Sample.'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            child: const Text('default'),
            onTap: () async {
              try {
                await FlutterAlternateIcon.setAlternateIcon(null);
              } catch (e) {}
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final icon = AlternateIcons.values[index];
              return InkWell(
                child: Text(icon.name),
                onTap: () async {
                  try {
                    await FlutterAlternateIcon.setAlternateIcon(icon.name);
                  } catch (e) {}
                },
              );
            },
            itemCount: AlternateIcons.values.length,
          ),
        ],
      ),
    );
  }
}
