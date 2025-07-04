import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: CounterPage(),
    );
  }
}

class CounterPage extends StatefulWidget {
  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage>
    with TickerProviderStateMixin {
  int _count = 0;
  late AnimationController _jumpController;
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _confettiController;
  late Animation<double> _jumpAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;
  
  List<String> hearts = ['❤️', '💕', '💖', '💗', '💓', '💝', '💘', '💞', '💟', '♥️', '🧡', '💛', '💚', '💙', '💜', '🤍', '🖤', '💔'];
  String currentHeart = '❤️';
  
  @override
  void initState() {
    super.initState();
    
    // Jump animation cho động vật
    _jumpController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _jumpAnimation = Tween<double>(
      begin: 0.0,
      end: -50.0,
    ).animate(CurvedAnimation(
      parent: _jumpController,
      curve: Curves.bounceOut,
    ));
    
    // Rotation animation cho số đếm
    _rotationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.elasticOut,
    ));
    
    // Pulse animation cho button
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    // Confetti animation
    _confettiController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _pulseController.repeat(reverse: true);
  }
  
  @override
  void dispose() {
    _jumpController.dispose();
    _rotationController.dispose();
    _pulseController.dispose();
    _confettiController.dispose();
    super.dispose();
  }
  
  void _increment() {
    setState(() {
      _count++;
      // Đổi trái tim ngẫu nhiên
      currentHeart = hearts[math.Random().nextInt(hearts.length)];
    });
    
    // Trigger animations
    _jumpController.forward().then((_) {
      _jumpController.reverse();
    });
    
    _rotationController.forward().then((_) {
      _rotationController.reset();
    });
    
    // Hiệu ứng đặc biệt cho các mốc số
    if (_count % 10 == 0) {
      _showCelebration();
    }
  }
  
  void _showCelebration() {
    _confettiController.forward().then((_) {
      _confettiController.reset();
    });
    
    // Hiển thị dialog chúc mừng
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Text('💕 Tình yêu tràn đầy dành cho Diễn ! 💕'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Bạn đã trao $_count trái tim tình yêu cho Diễn!'),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < 5; i++)
                  TweenAnimationBuilder<double>(
                    duration: Duration(milliseconds: 200 * (i + 1)),
                    tween: Tween(begin: 0.0, end: 1.0),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Text('💖', style: TextStyle(fontSize: 24)),
                      );
                    },
                  ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Tiếp tục yêu Diễn 💕'),
          ),
        ],
      ),
    );
  }
  
  void _reset() {
    setState(() {
      _count = 0;
      currentHeart = '❤️';
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Text('💕 Đã reset về 0 trái tim'),
            Spacer(),
            Text('💖'),
          ],
        ),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  
  Color _getBackgroundColor() {
    // Đổi màu nền theo chủ đề tình yêu
    List<Color> colors = [
      Colors.pink.shade50,
      Colors.red.shade50,
      Colors.purple.shade50,
      Colors.orange.shade50,
      Colors.deepOrange.shade50,
      Colors.pinkAccent.shade100,
    ];
    return colors[_count % colors.length];
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _getBackgroundColor(),
      appBar: AppBar(
        title: Text('💕 Ứng dụng đếm trái tim tình yêu dành cho Diễn'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _reset,
            tooltip: 'Reset về 0',
          ),
        ],
      ),
      body: Stack(
        children: [
          // Confetti overlay
          AnimatedBuilder(
            animation: _confettiController,
            builder: (context, child) {
              return _count % 10 == 0 && _confettiController.isAnimating
                  ? CustomPaint(
                      painter: ConfettiPainter(_confettiController.value),
                      size: Size.infinite,
                    )
                  : Container();
            },
          ),
          
          // Main content
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Trái tim nhảy
                  AnimatedBuilder(
                    animation: _jumpAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _jumpAnimation.value),
                        child: TweenAnimationBuilder<double>(
                          duration: Duration(milliseconds: 200),
                          tween: Tween(begin: 0.0, end: 1.0),
                          builder: (context, value, child) {
                            return Transform.scale(
                              scale: 0.8 + (0.4 * value),
                              child: Text(
                                currentHeart,
                                style: TextStyle(fontSize: 80),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  
                  SizedBox(height: 30),
                  
                  Text(
                    'Bạn đã yêu Diễn:',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Số đếm với rotation animation
                  AnimatedBuilder(
                    animation: _rotationAnimation,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _rotationAnimation.value,
                        child: AnimatedSwitcher(
                          duration: Duration(milliseconds: 300),
                          transitionBuilder: (child, animation) =>
                              ScaleTransition(scale: animation, child: child),
                          child: Container(
                            key: ValueKey<int>(_count),
                            padding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.pink.shade400,
                                  Colors.red.shade400,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Text(
                              '$_count',
                              style: TextStyle(
                                fontSize: 60,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  
                  SizedBox(height: 15),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'trái tim',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(width: 10),
                      if (_count > 0)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.pink.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _count >= 100 ? 'Yêu Diễn cuồng nhiệt! 💕' :
                            _count >= 50 ? 'Yêu Diễn sâu sắc! 💖' :
                            _count >= 20 ? 'Yêu thương Diễn ! 💗' :
                            _count >= 10 ? 'Yêu Diễn nhiều! 💓' : 'Yêu quá! 💘',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.pink.shade800,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  
                  SizedBox(height: 40),
                  
                  // Progress bar
                  Container(
                    width: double.infinity,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: FractionallySizedBox(
                      widthFactor: (_count % 10) / 10,
                      alignment: Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.pink, Colors.red],
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 8),
                  
                  Text(
                    'Tiến độ tới mốc tiếp theo: ${_count % 10}/10',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: FloatingActionButton.extended(
              onPressed: _increment,
              label: Text(
                'Yêu anh',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              icon: Icon(Icons.favorite, size: 24),
              backgroundColor: Colors.pink,
              elevation: 8,
            ),
          );
        },
      ),
    );
  }
}

// Custom painter cho hiệu ứng confetti
class ConfettiPainter extends CustomPainter {
  final double animationValue;
  
  ConfettiPainter(this.animationValue);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final random = math.Random(42); // Seed cố định để có animation nhất quán
    
    for (int i = 0; i < 50; i++) {
      final x = random.nextDouble() * size.width;
      final y = size.height * (1 - animationValue) + random.nextDouble() * 100;
      
      paint.color = [
        Colors.pink,
        Colors.red,
        Colors.purple,
        Colors.orange,
        Colors.deepOrange,
        Colors.pinkAccent,
      ][i % 6];
      
      canvas.drawCircle(
        Offset(x, y),
        2 + random.nextDouble() * 3,
        paint,
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}