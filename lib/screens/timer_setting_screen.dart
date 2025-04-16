import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../provider/app_state.dart';

class TimerSettingScreen extends StatelessWidget {
  const TimerSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    double workTime = appState.workMinutes.toDouble();
    double breakTime = appState.breakMinutes.toDouble();
    double longBreakTime = appState.longBreakMinutes.toDouble();
    double workCycleCount = appState.workCycleCount.toDouble();
    double pomodoroCount = appState.pomodoroCount.toDouble();

    return Scaffold(
      appBar: AppBar(title: const Text('タイマー設定'),backgroundColor: Theme.of(context).colorScheme.inversePrimary,),
      body: SingleChildScrollView(child: 
      Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '作業時間（分）',
              style: TextStyle(fontSize: 16),
            ),
            Slider(
              value: workTime,
              min: 1,
              max: 60,
              divisions: 10,
              label: '${workTime.round()}分',
              onChanged: (value) {
                appState.setWorkMinutes(value.round());
              },
            ),
            Text('${appState.workMinutes} 分'),
            const SizedBox(height: 24),
            const Text(
              '休憩時間（分）',
              style: TextStyle(fontSize: 16),
            ),
            Slider(
              value: breakTime,
              min: 1,
              max: 30,
              divisions: 29,
              label: '${breakTime.round()}分',
              onChanged: (value) {
                appState.setBreakMinutes(value.round());
              },
            ),
            Text('${appState.breakMinutes} 分'),
            const SizedBox(height: 24),
            const Text(
              '長めの休憩時間（分）',
              style: TextStyle(fontSize: 16),
            ),
            Slider(
              value: longBreakTime,
              min: 1,
              max: 30,
              divisions: 29,
              label: '${longBreakTime.round()}分',
              onChanged: (value) {
                appState.setLongBreakMinutes(value.round());
              },
            ),
            Text('${appState.longBreakMinutes} 分'),
            const SizedBox(height: 24),
            const Text(
              '1セットの回数',
              style: TextStyle(fontSize: 16),
            ),
            Slider(
              value: workCycleCount,
              min: 1,
              max: 10,
              divisions: 10,
              label: '${workCycleCount.round()}回',
              onChanged: (value) {
                appState.setWorkCyclecount(value.round());
              },
            ),
            Text('${appState.workCycleCount} 回'),
            const SizedBox(height: 24),
            const Text(
              'セット数',
              style: TextStyle(fontSize: 16),
            ),
            Slider(
              value: pomodoroCount,
              min: 1,
              max: 10,
              divisions: 9,
              label: '${pomodoroCount.round()}回',
              onChanged: (value) {
                appState.setPomodoroCount(value.round());
              },
            ),
            Text('${appState.pomodoroCount} 回'),
          ],
        ),
      ),),
    );
  }
}