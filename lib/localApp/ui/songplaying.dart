import 'dart:async';

import 'package:flutter/material.dart';

import 'package:richardmusic/constants.dart';

import 'package:assets_audio_player/assets_audio_player.dart';

class SongPlaying extends StatefulWidget {
  @override
  _SongPlayingState createState() => _SongPlayingState();
}

Timer _everySecond;

class Song {
  var singer;
  var url;
  var title;
  var length;

  var currentPosition = 0.0;

  NetworkImage image;

  Song({this.singer, this.url, this.title, this.length, this.image});
}

class _SongPlayingState extends State<SongPlaying> {
  bool _songPlaying = false;
  Song _song;

  final _assetsAudioPlayer = AssetsAudioPlayer();
  final List<StreamSubscription> _subscriptions = [];

  void _playSong() {
    setState(() {
      _songPlaying = true;
      print("Le son a démarré ");
    });
    _assetsAudioPlayer.play();
  }

  void _pauseSong() {
    setState(() {
      _songPlaying = false;
      print("Le son a été coupé");
      _assetsAudioPlayer.pause();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _song = Song(
      singer: "Damso",
      url: "assets/music/damso.mp3",
      title: "Feu de bois",
      length: 6000.0,
      image: NetworkImage(
          "https://images.genius.com/964251431db5dd72e987532c10e1bb04.1000x1000x1.jpg"),
    );

    _assetsAudioPlayer.open(
      Audio(_song.url),
    );

    _subscriptions.add(_assetsAudioPlayer.playlistFinished.listen((data) {
      print("finished : $data");
      if (data) {
        setState(() {
          _song.currentPosition = 0.0;
          _pauseSong();
        });
      }
      ;
    }));
    _subscriptions.add(_assetsAudioPlayer.onReadyToPlay.listen((audio) {
      print("onRedayToPlay : $audio");
      _playSong();

      _song.length = _assetsAudioPlayer
          .current.value.audio.duration.inMilliseconds
          .toDouble();
    }));

    _everySecond = Timer.periodic(Duration(seconds: 1), (Timer t) {
      //print(assetsAudioPlayer.isPlaying.value);
      setState(() {
        print(
            "${_assetsAudioPlayer.currentPosition.value.inMilliseconds} ${_song.length}");

        if (_assetsAudioPlayer.isPlaying.value) {
          _song.currentPosition = _assetsAudioPlayer
              .currentPosition.value.inMilliseconds
              .toDouble();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: kBgColor,
        appBar: AppBar(
          backgroundColor: kBgColor,
          title: Text("Richard Music Player"),
          actions: <Widget>[
            AppBarActions(
              icon: Icon(
                Icons.shuffle,
                color: kSecondaryTextColor,
              ),
            ),
            AppBarActions(
              icon: Icon(
                Icons.favorite_border,
                color: kSecondaryTextColor,
              ),
            ),
            AppBarActions(
              icon: Icon(
                Icons.more_vert,
                color: kSecondaryTextColor,
              ),
            )
          ],
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.42,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: _song.image,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),
                child: Text(
                  "${_song.title}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                "${_song.singer}",
                style: TextStyle(
                  color: kSecondaryTextColor,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      "${format(_assetsAudioPlayer.currentPosition.value)}",
                      style: TextStyle(color: kPrimaryTextColor),
                    ),
                    Expanded(
                      child: Slider(
                        min: 0.0,
                        max: _song.length,
                        value: _song.currentPosition,
                        label: "Music",
                        activeColor: Colors.red,
                        inactiveColor: Colors.white,
                        onChanged: (value) {
                          setState(() {
                            _song.currentPosition = value;
                            _assetsAudioPlayer
                                .seek(Duration(milliseconds: value.toInt()));
                            print(value);
                          });
                        },
                      ),
                    ),
                    Text(
                      "${_assetsAudioPlayer.current.value == null ? '...' : format(_assetsAudioPlayer.current.value.audio.duration)}",
                      style: TextStyle(color: kPrimaryTextColor),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
//                    Builder(
//                      builder: (context) => MusicActionButton(
//                        icon: Icons.file_download,
//                        onTap: () {
//                          Scaffold.of(context).showSnackBar(SnackBar(
//                            elevation: 20.0,
//                            content: Text('Téléchargement démarré...'),
//                            duration: Duration(seconds: 3),
//                          ));
//
//                        },
//                      ),
//                    ),
                    Builder(
                      builder: (context) => MusicActionButton(
                        icon: Icons.fast_rewind,
                        onTap: () {
                          Scaffold.of(context).showSnackBar(SnackBar(
                            elevation: 20.0,
                            content: Text('Arriere de 20 sec'),
                            duration: Duration(seconds: 3),
                          ));
                          _assetsAudioPlayer
                              .seekBy(Duration(milliseconds: -20 * 1000));
                        },
                      ),
                    ),
                    InkWell(
                      onTap: _songPlaying ? _pauseSong : _playSong,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40.0),
                            gradient: LinearGradient(
                              colors: <Color>[
                                Color(0xFFa256f1),
                                Color(0xFF8462f4),
                                Color(0xFF42A5F5),
                              ],
                            )),
                        child: Icon(
                          _songPlaying
                              ? Icons.pause
                              : Icons.play_circle_outline,
                          color: Colors.white,
                          size: 70.0,
                        ),
                      ),
                    ),
                    Builder(
                      builder: (context) => MusicActionButton(
                        icon: Icons.fast_forward,
                        onTap: () {
                          Scaffold.of(context).showSnackBar(SnackBar(
                            elevation: 20.0,
                            content: Text('Avance de 20 sec ...'),
                            duration: Duration(seconds: 3),
                          ));

                          _assetsAudioPlayer
                              .seekBy(Duration(milliseconds: 20 * 1000));
                        },
                      ),
                    ),
//                    Builder(
//                      builder: (context) => MusicActionButton(
//                        icon: Icons.more,
//                        onTap: () {
//                          Scaffold.of(context).showSnackBar(SnackBar(
//                            elevation: 20.0,
//                            content: Text('Vous écoutez Escape From LA !'),
//                            duration: Duration(seconds: 3),
//                          ));
//                        },
//                      ),
//                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MusicActionButton extends StatelessWidget {
  final IconData icon;
  final Function onTap;

  const MusicActionButton({
    Key key,
    this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Icon(
        icon,
        color: kSecondaryTextColor,
        size: 40.0,
      ),
    );
  }
}

class AppBarActions extends StatelessWidget {
  final Icon icon;

  const AppBarActions({
    Key key,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: icon,
    );
  }
}
