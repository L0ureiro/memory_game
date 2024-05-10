import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Game',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MemoryGame(),
    );
  }
}

class MemoryGame extends StatefulWidget {
  const MemoryGame({super.key});

  @override
  _MemoryGameState createState() => _MemoryGameState();
}

class _MemoryGameState extends State<MemoryGame> {
  late List<Color> cardColors;
  late List<bool> revealed;
  int matchesFound = 0;
  int? lastRevealedIndex;

  @override
  void initState() {
    super.initState();
    initializeGame();
  }

  void initializeGame() {
    List<Color> shuffledColors = List<Color>.generate(8, (index) => Colors.primaries[Random().nextInt(Colors.primaries.length)]);
    cardColors = [...shuffledColors, ...shuffledColors]..shuffle();
    revealed = List<bool>.filled(16, false);
    matchesFound = 0;
    lastRevealedIndex = null;
  }

  void revealCard(int index) {
    if (revealed[index] || lastRevealedIndex == index) {
      return;
    }
    
    setState(() {
      revealed[index] = true;

      if (lastRevealedIndex == null) {
        lastRevealedIndex = index;
      } else {
        if (cardColors[lastRevealedIndex!] == cardColors[index]) {
          matchesFound += 1;
          lastRevealedIndex = null;
        } else {
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              revealed[lastRevealedIndex!] = false;
              revealed[index] = false;
              lastRevealedIndex = null;
            });
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Memory Game')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Matches Found: $matchesFound', style: const TextStyle(fontSize: 24)),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              itemCount: 16,
              itemBuilder: (context, index) {
                return Card(
                  color: revealed[index] ? cardColors[index] : Colors.grey,
                  child: InkWell(
                    onTap: () => revealCard(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
