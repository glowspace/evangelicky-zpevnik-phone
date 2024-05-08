import 'package:flutter/material.dart';
import 'package:zpevnik/components/bottom_sheet_section.dart';
import 'package:zpevnik/constants.dart';
import 'package:zpevnik/models/song_lyric.dart';

class SongLyricInfo extends StatelessWidget {
  final SongLyric songLyric;

  const SongLyricInfo({super.key, required this.songLyric});

  @override
  Widget build(BuildContext context) {
    return BottomSheetSection(
      title: 'O písni',
      children: [
        Padding(
          padding: const EdgeInsets.all(kDefaultPadding / 2),
          child: Text(songLyric.hymnology),
        ),
      ],
    );
  }
}
