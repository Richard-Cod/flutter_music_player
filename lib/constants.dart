import 'package:flutter/material.dart';
import 'package:richardmusic/model/DeezerR.dart';

const Color kBgColor = Color(0xFF272942);

const Color kSecondBgColor = Color(0xFF2e324d);

const Color kPrimaryTextColor = Color(0xFFcecddb);
const Color kSecondaryTextColor = Color(0xFF8d93b5);

format(Duration d) => d.toString().split('.').first.padLeft(8, "0");

class Song {
  var singer;
  var url;
  var title;
  var length;

  var currentPosition = 0.0;

  NetworkImage image;

  Song({this.singer, this.url, this.title, this.length, this.image});

  Song.fromData(Data data) {
    var minutes = data.duration % 10;
    var secondes = ((minutes.toDouble() / 100.0) - minutes.toDouble()) * 100;

    singer = data.artist.name;
    url = data.preview;
    title = data.title;
    image = NetworkImage(data.album.coverBig);
    length = 9999.0;
  }
}
