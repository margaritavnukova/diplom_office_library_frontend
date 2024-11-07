import 'package:flutter/material.dart';

class MainPage extends StatelessWidget{

  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
        ),
        body: Builder(
          builder: (context) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final String? result = 
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => 
                          const Page1(title: "blue"),
                        )
                      );
                    }, 
                    child: const Text("To page 1")
                  ),

                  ElevatedButton(
                    onPressed: () async {
                      final String? result = 
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => 
                          const Page2(title: "green"),
                        )
                      );
                    }, 
                    child: const Text("To page 2")
                  )
                ],
              ),
            );
          }
        )
      ),
    );
  }
}

class Page1 extends StatelessWidget{

  const Page1({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          children: [
            Text("Page 1 - $title"),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop("resulting");
              },
              child: const Text("Return"),
            )
          ],
        )
      )
    );
  }
}


class Page2 extends StatelessWidget{

  const Page2({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          children: [
            Text("Page 2 - $title"),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop("resulting");
              },
              child: const Text("Return"),
            )
          ],
        )
      )
    );
  }
}