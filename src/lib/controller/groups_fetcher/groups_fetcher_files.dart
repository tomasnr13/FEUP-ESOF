import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:uni/controller/groups_fetcher/groups_fetcher.dart';
import 'package:uni/model/entities/group.dart';
import 'package:uni/model/app_state.dart';
import 'package:redux/redux.dart';

/// Class for fetching the user's groups from local files.
class GroupsFetcherFiles extends GroupsFetcher {
  /// Fetches the user's groups from local files.
  @override
  Future<List<Group>> getGroups(Store<AppState> store) async {
    final storePath = (await getApplicationDocumentsDirectory()).path;

    final path =
        '$storePath/${store.state.content['session'].studentNumber}/groups.json';
    final file = File(path);

    if (!await file.exists()) {
      await file.create(recursive: true);
      await file.writeAsString(jsonEncode({'groups': []}));
      return [];
    }

    final groupsJson = await file.readAsString();

    final List<dynamic> groupsMap = jsonDecode(groupsJson)['groups'];

    final List<Group> groups = [];

    for (dynamic group in groupsMap) {
      groups.add(Group.fromJson(group));
    }

    return groups;
  }

  @override
  Future<void> setGroups(Store<AppState> store, List<Group> groups) async {
    final List<Map<String, dynamic>> groupsMap = [];

    for (Group group in groups) {
      groupsMap.add(group.toMap());
    }

    final storePath = (await getApplicationDocumentsDirectory()).path;

    final path =
        '$storePath/${store.state.content['session'].studentNumber}/groups.json';
    final file = File(path);


    await file.writeAsString(jsonEncode({'groups': groupsMap}));
  }
}
