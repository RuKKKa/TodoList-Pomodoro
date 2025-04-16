import 'package:flutter/material.dart';
import '../../model/task.dart';
import '../../model/timer_setting.dart';

class AppState extends ChangeNotifier {
  final List<Task> _tasks = [];
  TimerSettings _settings = TimerSettings();
  bool _isRunning = false;
  Task? _currentTask;
  int _workCycleCount = 1;
  int _pomodoroCount = 1;

  int _workMinutes = 25;
  int _breakMinutes = 5;
  int _longBreakMinutes = 15;

  List<Task> get tasks => List.unmodifiable(_tasks);
  TimerSettings get settings => _settings;
  bool get isRunning => _isRunning;
  Task? get currentTask => _currentTask;
  int get workMinutes => _workMinutes;
  int get breakMinutes => _breakMinutes;
  int get longBreakMinutes => _longBreakMinutes;
  int get workCycleCount => _workCycleCount;
  int get pomodoroCount => _pomodoroCount;

  void addTask(String title) {
    _tasks.add(Task(title: title));
    notifyListeners();
  }

  void toggleTask(int index) {
    _tasks[index].isDone = !_tasks[index].isDone;
    notifyListeners();
  }

  void removeTask(int index) {
    _tasks.removeAt(index);
    notifyListeners();
  }

  void updateTimerSettings(int work, int breakTime) {
    _settings = TimerSettings(workMinutes: work, breakMinutes: breakTime);
    notifyListeners();
  }

  void selectTask(Task? task) {
    _currentTask = task;
    notifyListeners();
  }

  void setWorkMinutes(int minutes) {
    _workMinutes = minutes;
    notifyListeners();
  }

  void setBreakMinutes(int minutes) {
    _breakMinutes = minutes;
    notifyListeners();
  }

  void setLongBreakMinutes(int minutes) {
    _longBreakMinutes = minutes;
    notifyListeners();
  }
  
  void setWorkCyclecount(int count){
    _workCycleCount = count;
    notifyListeners();
  }

  void setPomodoroCount(int count){
    _pomodoroCount = count;
    notifyListeners();
  }

}