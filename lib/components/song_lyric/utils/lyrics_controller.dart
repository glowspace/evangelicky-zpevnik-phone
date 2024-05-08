import 'package:flutter/material.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/components/song_lyric/utils/parser.dart';

final _styleRE = RegExp(r'\<style[^\<]*\<\/style\>');
final _heightRE = RegExp(r'height="([\d\.]+)mm"');
final _widthRE = RegExp(r'width="([\d\.]+)"');

class LyricsController {
  final SongLyric songLyric;
  final SongLyricsParser parser;

  final BuildContext context;

  LyricsController(this.songLyric, this.context) : parser = SongLyricsParser(songLyric);

  double? _musicNotesWidth;
  String? _musicNotes;

  String get title => songLyric.name;

  bool get hasMusicNotes => songLyric.musicNotes != null;

  double get musicNotesWidth => _musicNotesWidth ?? 0;

  String get musicNotes {
    if (_musicNotes != null) return _musicNotes!;

    _musicNotes = (songLyric.musicNotes ?? '')
        .replaceAll(_styleRE, '')
        .replaceAll(_heightRE, '')
        .replaceFirstMapped(_widthRE, (match) {
      _musicNotesWidth = double.tryParse(match.group(1) ?? '');

      return '';
    });

    return _musicNotes!;
  }
}
