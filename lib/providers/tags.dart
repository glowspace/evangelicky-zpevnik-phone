import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zpevnik/models/objectbox.g.dart';
import 'package:zpevnik/models/tag.dart';
import 'package:zpevnik/providers/playlists.dart';
import 'package:zpevnik/providers/song_lyrics.dart';
import 'package:zpevnik/providers/songbooks.dart';
import 'package:zpevnik/providers/utils.dart';

part 'tags.g.dart';

@riverpod
List<Tag> tags(TagsRef ref, TagType tagType) {
  switch (tagType) {
    case TagType.songbook:
      final songbooks = ref.watch(songbooksProvider);

      int id = -1000;
      return [for (final songbook in songbooks) Tag(id: id--, name: songbook.name, dbType: tagType.rawValue)];
    case TagType.playlist:
      final playlists = [ref.read(favoritePlaylistProvider)] + ref.watch(playlistsProvider);

      int id = -2000;
      return [for (final playlist in playlists) Tag(id: id--, name: playlist.name, dbType: tagType.rawValue)];
    case TagType.language:
      final languageCounts = <String, int>{};

      for (final songLyric in ref.read(songLyricsProvider)) {
        languageCounts[songLyric.langDescription] = (languageCounts[songLyric.langDescription] ?? 0) + 1;
      }

      final languages = languageCounts.keys.sorted((a, b) => languageCounts[b]!.compareTo(languageCounts[a]!));

      int id = -1;

      return [for (final language in languages) Tag(id: id--, name: language, dbType: tagType.rawValue)];
    default:
      final tags = queryStore(ref, condition: Tag_.dbType.equals(tagType.rawValue));

      return tags;
  }
}

@riverpod
class SelectedTagsByType extends _$SelectedTagsByType {
  @override
  Set<Tag> build(TagType tagType) => {};

  void toggleSelection(Tag tagToToggle) {
    if (state.contains(tagToToggle)) {
      state = {
        for (final tag in state)
          if (tag != tagToToggle) tag
      };
    } else {
      state = {tagToToggle, ...state};
    }
  }
}

@riverpod
Set<Tag> selectedTags(SelectedTagsRef ref) {
  return {for (final tagType in supportedTagTypes) ...ref.watch(selectedTagsByTypeProvider(tagType))};
}
