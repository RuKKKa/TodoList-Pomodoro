import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model/task.dart';
import 'provider/app_state.dart';
import 'screens/timer_setting_screen.dart';
import 'screens/todo_list_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const MyApp(),
    ),
  );}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const MyHomePage(title: 'TODOリスト＆ポモドーロタイマー'),
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
    final appState = Provider.of<AppState>(context);
    final currentTask = appState.currentTask;
    final tasks = appState.tasks;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.timer_outlined),
                  SizedBox(width: 5,),
                  Text('タイマー設定'),
                ],
              ),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context,MaterialPageRoute(builder: (context) => TimerSettingScreen()));
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.list),
                    SizedBox(width: 5,),
                    Text('目標設定'),
                ],
              ),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context,MaterialPageRoute(builder: (context) => TodoListScreen()));
              },
            ),
            
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Text(
              '習慣化するクセをつけよう！',
            ),
            SizedBox(height: 10,),
            const TimerWidget(),
            Spacer(),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32,vertical: 20),
          child:  DropdownButton<Task>(
            isExpanded: true,
            hint: const Text('タスクを選択'),
            value: currentTask,
            borderRadius: BorderRadius.circular(10),
            items: tasks.map((task) {
              return DropdownMenuItem(
                value: task,
                child: Padding(
                  padding: EdgeInsets.all(10),child:Text(task.title),
                ),
              );
            }
          ).toList(),
            onChanged: (Task? selected) {
            appState.selectTask(tasks.firstWhere((t) => t == selected),
          );
        },
      ),
      ),
    ])
    )
  );}
}

class TimerWidget extends StatefulWidget {
  const TimerWidget({super.key});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  Timer? _timer;
  int _secondsLeft = 0;
  bool _isRunning = false;
  bool _isWorkTime = true;
  int _cycleCount = 0;
  int _pomodoroCount = 0;
  int _breakMinutes = 0;

  late AppState appState;
  late VoidCallback appStateListener;

  @override
  void initState() {
    super.initState();
    appStateListener = () {
      if (!_isRunning) {
        setState(() {
          _secondsLeft = appState.workMinutes * 60;
        });
      }
    };
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appState = Provider.of<AppState>(context);
    _secondsLeft = appState.workMinutes * 60;
    appState.addListener(appStateListener);
  }

  @override
  void dispose() {
    _timer?.cancel();
    appState.removeListener(appStateListener);
    super.dispose();
  }

  void _startTimer() {
    if (_isRunning) return;

    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 0) {
        timer.cancel();
        setState(() {
          _isRunning = false;
        });

        if (appState.pomodoroCount == _pomodoroCount) {
          _showCompletedDialog();
          _resetTimer();
        } else {
          if (_isWorkTime) {
            _showSwitchDialog('作業終了！', '少し休憩しましょう 🍵');
            _switchToMode();
          } else {
            _showSwitchDialog('休憩終了！', 'また集中タイム！ 💪');
            _switchToMode();
          }
        }
      } else {
        setState(() {
          _secondsLeft--;
        });
      }
    });
  }

  void _switchToMode() {
    _cycleCount++;

    if (appState.workCycleCount == _cycleCount) {
      _pomodoroCount++;
      _breakMinutes = appState.longBreakMinutes;
    } else {
      _breakMinutes = appState.breakMinutes;
    }

    setState(() {
      _isWorkTime = !_isWorkTime;
      _secondsLeft = _isWorkTime ? appState.workMinutes * 60 : _breakMinutes * 60;
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    setState(() {
      final minutes = appState.workMinutes;

      _isWorkTime = true;
      _secondsLeft = appState.workMinutes * 60;
      _isRunning = false;
      _cycleCount = 0;
      _pomodoroCount = 0;
    });
    _timer?.cancel();
  }

  void _showSwitchDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _startTimer(); // 自動再スタート
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showCompletedDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('お疲れさま！'),
        content: const Text('作業時間が終了しました。休憩しましょう！'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetTimer();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _formatTime(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 円形進行状況バー
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 200, height: 200,
              child: CircularProgressIndicator(
              value: _secondsLeft / (_isWorkTime ? appState.workMinutes * 60 : _breakMinutes * 60),
              strokeWidth: 10.0,
              valueColor: AlwaysStoppedAnimation(
                _isWorkTime ? Colors.green : Colors.red,
              ),
            ),
            ),
            // タイマー時間表示
            Text(
              _formatTime(_secondsLeft),
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // 作業状態表示
        Text(
          _isWorkTime ? '作業中' : '休憩中',
          style: TextStyle(fontSize: 24, color: _isWorkTime ? Colors.green : Colors.red),
        ),
        const SizedBox(height: 36),
        // ボタン群
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _isRunning ? null : _startTimer,
              child: const Text('スタート'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                textStyle: const TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: _isRunning ? _stopTimer : null,
              child: const Text('ストップ'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                textStyle: const TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: _resetTimer,
              child: const Text('リセット'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                textStyle: const TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
        const SizedBox(height: 36),

        // 作業サイクルとセット数の表示
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '作業サイクル: ${_cycleCount} / ${appState.workCycleCount}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 16),
            Text(
              'セット数: ${_pomodoroCount} / ${appState.pomodoroCount}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }
}
