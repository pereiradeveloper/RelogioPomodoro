import 'package:flutter/material.dart';
import 'package:pomodoro_app/model/pomodoro_status.dart';

const pomodoroTotalTime = 5;
const shortBreakTime = 3;
const longBreakTime = 6;
const pomodoriPerSet = 4;

const Map<PomodoroStatus, String> statusDescription = {
  PomodoroStatus.runingPomodoro: "Pomodoro está ativo,hora de estar focado",
  PomodoroStatus.pausedPomodoro: "Pronto para estar focado?",
  PomodoroStatus.runningShortBreak: "Tempo curto,hora de relaxar",
  PomodoroStatus.pausedShortBreak: "Vamos fazer uma pequena pausa?",
  PomodoroStatus.runningLongBreak: "Longa pausa em andamento,hora de relaxar",
  PomodoroStatus.pausedLongBreak: "Vamos fazer uma longa pausa?",
  PomodoroStatus.setFinished:
      "Parabéns, você merece uma longa pausa,pronto para começar?",
};

const Map<PomodoroStatus, MaterialColor> statusColor = {
  PomodoroStatus.runingPomodoro: Colors.green,
  PomodoroStatus.pausedPomodoro: Colors.orange,
  PomodoroStatus.runningShortBreak: Colors.red,
  PomodoroStatus.pausedShortBreak: Colors.orange,
  PomodoroStatus.runningLongBreak: Colors.red,
  PomodoroStatus.pausedLongBreak: Colors.orange,
  PomodoroStatus.setFinished: Colors.orange,
};
