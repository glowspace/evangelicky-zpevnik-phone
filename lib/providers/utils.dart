import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:objectbox/internal.dart';
import 'package:objectbox/objectbox.dart';
import 'package:zpevnik/models/author.dart';
import 'package:zpevnik/models/external.dart';
import 'package:zpevnik/models/model.dart';
import 'package:zpevnik/models/song.dart';
import 'package:zpevnik/models/song_lyric.dart';
import 'package:zpevnik/models/songbook.dart';
import 'package:zpevnik/models/songbook_record.dart';
import 'package:zpevnik/models/tag.dart';
import 'package:zpevnik/models/utils.dart';
import 'package:zpevnik/providers/app_dependencies.dart';

Future<void> parseAndStoreData(Store store, Map<String, dynamic> json) async {
  final authors = readJsonList(json[Author.fieldKey], mapper: Author.fromJson);
  final songs = readJsonList(json[Song.fieldKey], mapper: Song.fromJson);
  final songbooks = readJsonList(json[Songbook.fieldKey], mapper: Songbook.fromJson);
  final tags = readJsonList(json[Tag.fieldKey], mapper: Tag.fromJson);

  await Future.wait([
    store.box<Author>().putManyAsync(authors),
    store.box<Song>().putManyAsync(songs),
    store.box<Songbook>().putManyAsync(songbooks),
    store.box<Tag>().putManyAsync(tags),
  ]);
}

Future<List<SongLyric>> storeSongLyrics(Store store, List<SongLyric> songLyrics) async {
  final externals = <External>[];
  final songbookRecords = <SongbookRecord>[];

  for (final songLyric in songLyrics) {
    externals.addAll(songLyric.externals);
    songbookRecords.addAll(songLyric.songbookRecords);
  }

  final songLyricIds = await store.box<SongLyric>().putManyAsync(songLyrics);

  await Future.wait([
    store.box<External>().putManyAsync(externals),
    store.box<SongbookRecord>().putManyAsync(songbookRecords),
  ]);

  // retrieve the updated song lyrics with correctly setup relations
  return (await store.box<SongLyric>().getManyAsync(songLyricIds)).cast();
}

int nextId<T extends Identifiable, D>(Ref ref, QueryProperty<T, D> idProperty) {
  final box = ref.read(appDependenciesProvider.select((appDependencies) => appDependencies.store)).box<T>();
  final queryBuilder = box.query()..order(idProperty, flags: Order.descending);
  final query = queryBuilder.build();
  final lastId = query.findFirst()?.id ?? 0;

  query.close();

  return lastId + 1;
}

List<T> queryStore<T, D>(
  Ref ref, {
  Condition<T>? condition,
  QueryProperty<T, D>? orderBy,
  int orderFlags = 0,
}) {
  final box = ref.read(appDependenciesProvider.select((appDependencies) => appDependencies.store)).box<T>();
  final queryBuilder = box.query(condition);

  if (orderBy != null) queryBuilder.order(orderBy, flags: orderFlags);

  final query = queryBuilder.build();
  final data = query.find();

  query.close();

  return data;
}
