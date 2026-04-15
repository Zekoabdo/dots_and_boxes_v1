import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(const DotsAndBoxesApp());
}

class DotsAndBoxesApp extends StatelessWidget {
  const DotsAndBoxesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dots & Boxes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: Brightness.light,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationController.forward();

    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLogo(),
                    const SizedBox(height: 24),
                    const Text(
                      'Dots & Boxes',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF6C63FF),
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Connect · Claim · Conquer',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 48),
                    const CircularProgressIndicator(
                      color: Color(0xFF6C63FF),
                      strokeWidth: 2,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return SizedBox(
      width: 120,
      height: 120,
      child: CustomPaint(
        painter: LogoPainter(),
      ),
    );
  }
}

class LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final dotPaint = Paint()
      ..color = const Color(0xFF6C63FF)
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = const Color(0xFF6C63FF)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final boxPaint = Paint()
      ..color = const Color(0xFF6C63FF).withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final cellSize = size.width / 2;

    canvas.drawRect(
      Rect.fromLTWH(cellSize * 0.1, cellSize * 0.1, cellSize * 0.8, cellSize * 0.8),
      boxPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(cellSize * 1.1, cellSize * 1.1, cellSize * 0.8, cellSize * 0.8),
      boxPaint,
    );

    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        final x = col * cellSize;
        final y = row * cellSize;
        if (col < 2) {
          canvas.drawLine(Offset(x, y), Offset(x + cellSize, y), linePaint);
        }
        if (row < 2) {
          canvas.drawLine(Offset(x, y), Offset(x, y + cellSize), linePaint);
        }
        canvas.drawCircle(Offset(x, y), 6, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 160,
                height: 160,
                child: CustomPaint(painter: LogoPainter()),
              ),
              const SizedBox(height: 20),
              const Text(
                'Dots & Boxes',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF6C63FF),
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'The Classic Strategy Game',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 60),
              _buildMenuButton(
                context,
                label: 'PLAY',
                icon: Icons.play_arrow_rounded,
                isPrimary: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const GameScreen()),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildMenuButton(
                context,
                label: 'SETTINGS',
                icon: Icons.settings_rounded,
                isPrimary: false,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(
      BuildContext context, {
        required String label,
        required IconData icon,
        required bool isPrimary,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 220,
        height: 60,
        decoration: BoxDecoration(
          color: isPrimary ? const Color(0xFF6C63FF) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: const Color(0xFF6C63FF),
            width: 2,
          ),
          boxShadow: isPrimary
              ? [
            BoxShadow(
              color: const Color(0xFF6C63FF).withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            )
          ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isPrimary ? Colors.white : const Color(0xFF6C63FF),
              size: 24,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isPrimary ? Colors.white : const Color(0xFF6C63FF),
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppSettings {
  static double volume = 0.7;
  static Color player1Color = const Color(0xFF6C63FF);
  static Color player2Color = const Color(0xFFFF6584);
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static const int rows = 4;
  static const int cols = 3;
  int currentPlayer = 1;
  List<int> scores = [0, 0];
  late List<List<bool>> horizontalLines;
  late List<List<bool>> verticalLines;
  late List<List<int>> boxOwner;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    horizontalLines = List.generate(rows + 1, (_) => List.generate(cols, (_) => false));
    verticalLines = List.generate(rows, (_) => List.generate(cols + 1, (_) => false));
    boxOwner = List.generate(rows, (_) => List.generate(cols, (_) => 0));
    scores = [0, 0];
    currentPlayer = 1;
  }

  bool _checkBox(int row, int col) {
    return horizontalLines[row][col] &&
        horizontalLines[row + 1][col] &&
        verticalLines[row][col] &&
        verticalLines[row][col + 1];
  }

  void _tapHorizontalLine(int row, int col) {
    if (horizontalLines[row][col]) return;
    setState(() {
      horizontalLines[row][col] = true;
      bool scored = false;
      if (row > 0 && _checkBox(row - 1, col) && boxOwner[row - 1][col] == 0) {
        boxOwner[row - 1][col] = currentPlayer;
        scores[currentPlayer - 1]++;
        scored = true;
      }
      if (row < rows && _checkBox(row, col) && boxOwner[row][col] == 0) {
        boxOwner[row][col] = currentPlayer;
        scores[currentPlayer - 1]++;
        scored = true;
      }
      if (!scored) currentPlayer = currentPlayer == 1 ? 2 : 1;
      _checkGameOver();
    });
  }

  void _tapVerticalLine(int row, int col) {
    if (verticalLines[row][col]) return;
    setState(() {
      verticalLines[row][col] = true;
      bool scored = false;
      if (col > 0 && _checkBox(row, col - 1) && boxOwner[row][col - 1] == 0) {
        boxOwner[row][col - 1] = currentPlayer;
        scores[currentPlayer - 1]++;
        scored = true;
      }
      if (col < cols && _checkBox(row, col) && boxOwner[row][col] == 0) {
        boxOwner[row][col] = currentPlayer;
        scores[currentPlayer - 1]++;
        scored = true;
      }
      if (!scored) currentPlayer = currentPlayer == 1 ? 2 : 1;
      _checkGameOver();
    });
  }

  void _checkGameOver() {
    if (scores[0] + scores[1] == rows * cols) {
      Future.delayed(const Duration(milliseconds: 300), () => _showGameOverDialog());
    }
  }

  void _showGameOverDialog() {
    String winner = scores[0] > scores[1] ? 'Player 1 Wins! 🎉' : scores[1] > scores[0] ? 'Player 2 Wins! 🎉' : "It's a Tie! 🤝";
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Game Over!', textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(winner, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildScoreChip('P1', scores[0], AppSettings.player1Color),
                _buildScoreChip('P2', scores[1], AppSettings.player2Color),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () { Navigator.pop(context); setState(() => _initGame()); }, child: const Text('Play Again')),
          TextButton(onPressed: () { Navigator.pop(context); Navigator.pop(context); }, child: const Text('Home')),
        ],
      ),
    );
  }

  Widget _buildScoreChip(String player, int score, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color, width: 2),
      ),
      child: Column(
        children: [
          Text(player, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          Text('$score', style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildPlayerScore(1),
            const SizedBox(width: 20),
            const Text('D&B', style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF6C63FF), fontSize: 18)),
            const SizedBox(width: 20),
            _buildPlayerScore(2),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.settings_rounded, color: Color(0xFF6C63FF)), onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
          }),
        ],
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, color: Color(0xFF6C63FF)), onPressed: () => Navigator.pop(context)),
      ),
      body: Column(
        children: [
          _buildTurnIndicator(),
          Expanded(child: Center(child: Padding(padding: const EdgeInsets.all(20), child: _buildGameBoard()))),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton.icon(
              onPressed: () => setState(() => _initGame()),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('New Game'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerScore(int player) {
    final isActive = currentPlayer == player;
    final color = player == 1 ? AppSettings.player1Color : AppSettings.player2Color;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? color.withOpacity(0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        border: isActive ? Border.all(color: color, width: 2) : null,
      ),
      child: Column(
        children: [
          Text('P$player', style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.bold)),
          Text('${scores[player - 1]}', style: TextStyle(fontSize: 22, color: color, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  Widget _buildTurnIndicator() {
    final color = currentPlayer == 1 ? AppSettings.player1Color : AppSettings.player2Color;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
      child: Text("Player $currentPlayer's Turn", style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }

  Widget _buildGameBoard() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cellSize = min(constraints.maxWidth / cols, constraints.maxHeight / rows);
        return SizedBox(
          width: cellSize * cols,
          height: cellSize * rows,
          child: Stack(
            children: [
              ..._buildBoxes(cellSize),
              ..._buildHorizontalLines(cellSize),
              ..._buildVerticalLines(cellSize),
              ..._buildDots(cellSize),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildBoxes(double cellSize) {
    final boxes = <Widget>[];
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        if (boxOwner[row][col] != 0) {
          final color = boxOwner[row][col] == 1 ? AppSettings.player1Color : AppSettings.player2Color;
          boxes.add(Positioned(
            left: col * cellSize,
            top: row * cellSize,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              width: cellSize,
              height: cellSize,
              color: color.withOpacity(0.3),
              child: Center(child: Text('P${boxOwner[row][col]}', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: cellSize * 0.2))),
            ),
          ));
        }
      }
    }
    return boxes;
  }

  List<Widget> _buildHorizontalLines(double cellSize) {
    final lines = <Widget>[];
    for (int row = 0; row <= rows; row++) {
      for (int col = 0; col < cols; col++) {
        final isDrawn = horizontalLines[row][col];
        lines.add(Positioned(
          left: col * cellSize,
          top: row * cellSize - 10,
          child: GestureDetector(
            onTap: () => _tapHorizontalLine(row, col),
            child: Container(
              width: cellSize,
              height: 20,
              color: Colors.transparent,
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: isDrawn ? 6 : 3,
                  decoration: BoxDecoration(
                    color: isDrawn ? (currentPlayer == 1 ? AppSettings.player1Color : AppSettings.player2Color) : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
        ));
      }
    }
    return lines;
  }

  List<Widget> _buildVerticalLines(double cellSize) {
    final lines = <Widget>[];
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col <= cols; col++) {
        final isDrawn = verticalLines[row][col];
        lines.add(Positioned(
          left: col * cellSize - 10,
          top: row * cellSize,
          child: GestureDetector(
            onTap: () => _tapVerticalLine(row, col),
            child: Container(
              width: 20,
              height: cellSize,
              color: Colors.transparent,
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: isDrawn ? 6 : 3,
                  decoration: BoxDecoration(
                    color: isDrawn ? (currentPlayer == 1 ? AppSettings.player1Color : AppSettings.player2Color) : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
        ));
      }
    }
    return lines;
  }

  List<Widget> _buildDots(double cellSize) {
    final dots = <Widget>[];
    for (int row = 0; row <= rows; row++) {
      for (int col = 0; col <= cols; col++) {
        dots.add(Positioned(
          left: col * cellSize - 5,
          top: row * cellSize - 5,
          child: Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFF2D3436), shape: BoxShape.circle)),
        ));
      }
    }
    return dots;
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(context)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text("Game Sounds", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Slider(
            value: AppSettings.volume,
            onChanged: (val) => setState(() => AppSettings.volume = val),
            activeColor: const Color(0xFF6C63FF),
          ),
          const Divider(height: 40),
          const Text("Player 1 Color", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildColorPicker(1),
          const SizedBox(height: 30),
          const Text("Player 2 Color", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildColorPicker(2),
        ],
      ),
    );
  }

  Widget _buildColorPicker(int player) {
    List<Color> colors = [Colors.purple, Colors.blue, Colors.red, Colors.orange, Colors.green];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: colors.map((color) {
        bool isSelected = (player == 1 ? AppSettings.player1Color : AppSettings.player2Color) == color;
        return GestureDetector(
          onTap: () => setState(() {
            if (player == 1) AppSettings.player1Color = color; else AppSettings.player2Color = color;
          }),
          child: Container(
            width: 50, height: 50,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: isSelected ? Border.all(color: Colors.black, width: 3) : null,
            ),
          ),
        );
      }).toList(),
    );
  }
}