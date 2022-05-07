import 'dart:async';

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pomodoro_app/model/pomodoro_status.dart';
import 'package:pomodoro_app/utils/constants.dart';
import 'package:pomodoro_app/widget/custom_button.dart';
import 'package:pomodoro_app/widget/progress_icons.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

const _btnTextStart = "COMEÇAR POMODORO";
const _btnTextResumePomodoro = "RETOMAR POMODORO";
const _btntextResumeBreak = "RETOMAR PAUSA";
const _btnTextStartShortBreak = "FAZER UMA PEQUENA PAUSA";
const _btnTextStartLongBreak = "FAÇA UMA LONGA PAUSA";
const _btnTextStartNewSet = "INICIAR NOVO CONJUNTO";
const _btnTextPause = "PARAR";
const _btnTextReset = "RESETAR";

class _HomePageState extends State<HomePage> {
  int remainingTime = pomodoroTotalTime;
  String mainBtnText = _btnTextStart;
  PomodoroStatus pomodoroStatus = PomodoroStatus.pausedPomodoro;
  Timer? _timer;
  int pomodoroNum = 0;
  int setNum = 0;

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 10),
              Text(
                "Pomodoro número: $pomodoroNum",
                style: TextStyle(fontSize: 32, color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                "Definir: $setNum",
                style: TextStyle(fontSize: 22, color: Colors.white),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularPercentIndicator(
                      radius: 100.0,
                      lineWidth: 15.0,
                      percent: _getPomdoroPercentage(),
                      circularStrokeCap: CircularStrokeCap.round,
                      center: Text(
                        _secondsToFormatedString(remainingTime),
                        style: TextStyle(fontSize: 40, color: Colors.white),
                      ),
                      progressColor: statusColor[pomodoroStatus],
                    ),
                    SizedBox(height: 10),
                    ProgressIcons(
                      total: pomodoriPerSet,
                      done: pomodoroNum - (setNum * pomodoriPerSet),
                    ),
                    SizedBox(height: 10),
                    Text(
                      statusDescription[pomodoroStatus]!,
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    CustomButton(
                      onTap: _startPomodoroCountdown,
                      text: mainBtnText,
                    ),
                    CustomButton(
                      onTap: () {},
                      text: _btnTextReset,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _secondsToFormatedString(int seconds) {
    int roundedMinutes = seconds ~/ 60;
    int remaingSeconds = seconds - (roundedMinutes * 60);
    String remainingSecondsFormated;

    if (remaingSeconds < 10) {
      remainingSecondsFormated = "0$remaingSeconds";
    } else {
      remainingSecondsFormated = remaingSeconds.toString();
    }
    return "$roundedMinutes:$remainingSecondsFormated";
  }

  _getPomdoroPercentage() {
    int totalTime;
    switch (pomodoroStatus) {
      case PomodoroStatus.runingPomodoro:
        totalTime = pomodoroTotalTime;
        break;
      case PomodoroStatus.pausedPomodoro:
        totalTime = pomodoroTotalTime;
        break;
      case PomodoroStatus.runningShortBreak:
        totalTime = shortBreakTime;
        break;
      case PomodoroStatus.pausedShortBreak:
        totalTime = shortBreakTime;
        break;
      case PomodoroStatus.runningLongBreak:
        totalTime = longBreakTime;
        break;
      case PomodoroStatus.pausedLongBreak:
        totalTime = longBreakTime;
        break;
      case PomodoroStatus.setFinished:
        totalTime = pomodoroTotalTime;
        break;
    }

    double percentage = (totalTime - remainingTime) / totalTime;
    return percentage;
  }

  _mainButtonPressed() {
    switch (pomodoroStatus) {
      case PomodoroStatus.pausedPomodoro:
        _startPomodoroCountdown();
        break;
      case PomodoroStatus.runingPomodoro:
        _pausePomodoroCountDown();
        break;
      case PomodoroStatus.runningShortBreak:
        _pauseShortBreakCountdown();
        break;
      case PomodoroStatus.pausedShortBreak:
        _startShortBreak();
        break;
      case PomodoroStatus.runningLongBreak:
        _pauseLongBreakCountdown();
        break;
      case PomodoroStatus.pausedLongBreak:
        _startLongBreak();
        break;
      case PomodoroStatus.setFinished:
        setNum++;
        _startPomodoroCountdown();
        break;
    }
  }

  _startPomodoroCountdown() {
    pomodoroStatus = PomodoroStatus.runingPomodoro;
    _cancelTimer();
    _timer = Timer.periodic(
        Duration(seconds: 1),
        (timer) => {
              if (remainingTime > 0)
                {
                  setState(() {
                    remainingTime--;
                    mainBtnText = _btnTextPause;
                  }),
                }
              else
                {
                  pomodoroNum++,
                  _cancelTimer(),
                  if (pomodoroNum % pomodoriPerSet == 0)
                    {
                      pomodoroStatus = PomodoroStatus.pausedLongBreak,
                      setState(() {
                        remainingTime = longBreakTime;
                        mainBtnText = _btnTextStartLongBreak;
                      }),
                    }
                  else
                    {
                      pomodoroStatus = PomodoroStatus.pausedShortBreak,
                      setState(() {
                        remainingTime = shortBreakTime;
                        mainBtnText = _btnTextStartShortBreak;
                      }),
                    }
                }
            });
  }

  _startShortBreak() {
    pomodoroStatus = PomodoroStatus.runningShortBreak;
    setState(() {
      mainBtnText = _btnTextPause;
    });
    _cancelTimer();
    _timer = Timer.periodic(
      Duration(seconds: 1),
      ((timer) => {
            if (remainingTime > 0)
              {
                setState(() {
                  remainingTime--;
                }),
              }
            else
              {
                remainingTime - pomodoroTotalTime,
                _cancelTimer(),
                pomodoroStatus = PomodoroStatus.pausedPomodoro,
                setState((() {
                  mainBtnText = _btnTextStart;
                })),
              }
          }),
    );
  }

  _startLongBreak() {
    pomodoroStatus = PomodoroStatus.runningLongBreak;
    setState(() {
      mainBtnText = _btnTextPause;
    });
    _cancelTimer();
    _timer = Timer.periodic(
      Duration(seconds: 1),
      ((timer) => {
            if (remainingTime > 0)
              {
                setState(() {
                  remainingTime--;
                }),
              }
            else
              {
                remainingTime - pomodoroTotalTime,
                _cancelTimer(),
                pomodoroStatus = PomodoroStatus.setFinished,
                setState((() {
                  mainBtnText = _btnTextStartNewSet;
                })),
              }
          }),
    );
  }

  _pausePomodoroCountDown() {
    pomodoroStatus = PomodoroStatus.pausedPomodoro;
    _cancelTimer();
    setState(() {
      mainBtnText = _btnTextResumePomodoro;
    });
  }

  _resetButtonPressed() {
    pomodoroNum = 0;
    setNum = 0;
    _cancelTimer();
    _stopCountdown();
  }

  _stopCountdown() {
    pomodoroStatus = PomodoroStatus.pausedPomodoro;
    setState(() {
      mainBtnText = _btnTextStart;
      remainingTime = pomodoroTotalTime;
    });
  }

  _pauseShortBreakCountdown() {
    pomodoroStatus = PomodoroStatus.pausedShortBreak;
    _pauseBreakCountdown();
  }

  _pauseLongBreakCountdown() {
    pomodoroStatus = PomodoroStatus.pausedLongBreak;
    _pauseBreakCountdown();
  }

  _pauseBreakCountdown() {
    _cancelTimer();
    setState(() {
      mainBtnText = _btntextResumeBreak;
    });
  }

  _cancelTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
  }
}
