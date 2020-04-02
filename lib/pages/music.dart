import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:audioplayer/audioplayer.dart';

enum PlayerState { stopped, playing, paused }

class MuiscPage extends StatefulWidget {
  @override
  _MuiscPageState createState() => _MuiscPageState();
}

class _MuiscPageState extends State<MuiscPage>
    with SingleTickerProviderStateMixin {
  Duration duration;
  Duration position;

  String localFilePath;
  bool isMuted = false;

  AudioPlayer audioPlayer;

  StreamSubscription _positionSubscription;
  StreamSubscription _audioPlayerStateSubscription;
  PlayerState playerState = PlayerState.stopped;

  Animation<double> scaleAnimate;
  AnimationController scaleAnimateController;
  bool scaleAnimateStop;

  get isPlaying => playerState == PlayerState.playing;
  get isPaused => playerState == PlayerState.paused;

  get durationText =>
      duration != null ? duration.toString().split('.').first : '';
  get positionText =>
      position != null ? position.toString().split('.').first : '';

  @override
  void initState() {
    super.initState();

    initAudioPlayer();
    initScaleAnimate();
  }

  @override
  void dispose() {
    _positionSubscription.cancel();
    _audioPlayerStateSubscription.cancel();
    audioPlayer.stop();
    super.dispose();
  }

  void initScaleAnimate() {
    scaleAnimateController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
      value: 0,
    )..addStatusListener((AnimationStatus status) {
        if (scaleAnimateStop) {
          scaleAnimateController?.stop();
          scaleAnimateController?.reverse();
          return;
        }
        if (status == AnimationStatus.dismissed) {
          scaleAnimateController?.forward();
        } else if (status == AnimationStatus.completed) {
          scaleAnimateController?.reverse();
        }
      });

    scaleAnimate = Tween<double>(begin: 1, end: 1.1).animate(
      CurvedAnimation(
        parent: scaleAnimateController,
        curve: Curves.slowMiddle,
      ),
    );
  }

  void runScaleAnimate() {
    scaleAnimateStop = false;

    if (scaleAnimate == null) {
      initScaleAnimate();
    }

    scaleAnimateController?.forward();
  }

  void stopScaleAnimate() {
    scaleAnimateStop = true;
  }

  void initAudioPlayer() {
    audioPlayer = new AudioPlayer();

    _positionSubscription = audioPlayer.onAudioPositionChanged
        .listen((p) => setState(() => position = p));

    _audioPlayerStateSubscription =
        audioPlayer.onPlayerStateChanged.listen((state) {
      if (state == AudioPlayerState.PLAYING) {
        setState(() => duration = audioPlayer.duration);
      } else if (state == AudioPlayerState.STOPPED) {
        setState(() {
          playerState = PlayerState.stopped;
          position = duration;
        });
      }
    }, onError: (msg) {
      setState(() {
        playerState = PlayerState.stopped;
        duration = new Duration(seconds: 0);
        position = new Duration(seconds: 0);
      });
    });
  }

  Future play() async {
    runScaleAnimate();

    await audioPlayer?.play(
        'https://img.app.meitudata.com/meipaih5/h5/2018/new-spring-flag/fonts/music.7d2d236a.mp3');
    setState(() {
      playerState = PlayerState.playing;
    });
  }

  // Future _playLocal() async {
  //   await audioPlayer.play(localFilePath, isLocal: true);
  //   setState(() => playerState = PlayerState.playing);
  // }

  Future pause() async {
    stopScaleAnimate();
    await audioPlayer.pause();
    setState(() => playerState = PlayerState.paused);
  }

  Future stop() async {
    stopScaleAnimate();
    await audioPlayer.stop();
    setState(() {
      playerState = PlayerState.stopped;
      position = new Duration();
    });
  }

  Future mute(bool muted) async {
    await audioPlayer.mute(muted);
    setState(() {
      isMuted = muted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: new Container(
          padding:
              new EdgeInsets.only(top: 80, left: 20, right: 20, bottom: 20),
          child: new Column(mainAxisSize: MainAxisSize.min, children: [
            new Padding(
                padding: new EdgeInsets.all(12.0),
                child: new Stack(children: [
                  // SizedBox(
                  //   width: 150,
                  //   height: 150,
                  //   child: new CircularProgressIndicator(
                  //     strokeWidth: 2,
                  //     value: 1.0,
                  //     valueColor: new AlwaysStoppedAnimation(Colors.blue),
                  //   ),
                  // ),
                  ScaleTransition(
                    scale: scaleAnimate,
                    child: SizedBox(
                      width: 200,
                      height: 200,
                      child: new CircularProgressIndicator(
                        strokeWidth: 2,
                        value: position != null && position.inMilliseconds > 0
                            ? (position?.inMilliseconds?.toDouble() ?? 0.0) /
                                (duration?.inMilliseconds?.toDouble() ?? 0.0)
                            : 0.0,
                        valueColor: new AlwaysStoppedAnimation(Colors.yellow),
                        backgroundColor: Colors.yellow,
                      ),
                    ),
                  ),
                  Container(
                      width: 196,
                      height: 196,
                      margin: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[300],
                        image: DecorationImage(
                          image: NetworkImage(
                              'https://mvimg10.meitudata.com/5e82e7a403a5ewgw0fx4dv7873.jpg!thumb320'),
                        ),
                      ))
                ])),
            SizedBox(
              height: 80,
            ),
            new Row(mainAxisSize: MainAxisSize.min, children: [
              new IconButton(
                  onPressed: isPlaying ? null : () => play(),
                  iconSize: 40.0,
                  icon: new Icon(Icons.play_arrow),
                  color: Colors.blue),
              new IconButton(
                  onPressed: isPlaying ? () => pause() : null,
                  iconSize: 40.0,
                  icon: new Icon(Icons.pause),
                  color: Colors.blue),
              new IconButton(
                  onPressed: isPlaying || isPaused ? () => stop() : null,
                  iconSize: 40.0,
                  icon: new Icon(Icons.stop),
                  color: Colors.blue),
            ]),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                new Text(
                  position != null
                      ? "${positionText ?? ''}"
                      : duration != null ? durationText : '',
                  style: new TextStyle(fontSize: 14.0),
                ),
                SizedBox(
                  width: MediaQueryData.fromWindow(window).size.width * 0.6,
                  child: new Slider(
                    inactiveColor: Colors.grey,
                    activeColor: Colors.redAccent,
                    value: position?.inMilliseconds?.toDouble() ?? 0.0,
                    onChanged: (double value) =>
                        audioPlayer.seek((value / 1000).roundToDouble()),
                    min: 0.0,
                    max: duration.inMilliseconds.toDouble(),
                  ),
                ),
                new Text(
                  position != null
                      ? "${durationText ?? ''}"
                      : duration != null ? durationText : '',
                  style: new TextStyle(fontSize: 14.0),
                ),
              ],
            )
          ])),
    );
  }
}
