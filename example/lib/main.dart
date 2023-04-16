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
  List<String> alternateIconNames = [];

  @override
  void initState() {
    super.initState();
    FlutterAlternateIcon.getAlternateIconNames().then((value) {
      setState(() {
        alternateIconNames = value;
      });
    });
  }

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
              final iconName = alternateIconNames[index];
              return InkWell(
                child: Text(iconName),
                onTap: () async {
                  try {
                    await FlutterAlternateIcon.setAlternateIcon(iconName);
                  } catch (e) {}
                },
              );
            },
            itemCount: alternateIconNames.length,
          ),
        ],
      ),
    );
  }
}
