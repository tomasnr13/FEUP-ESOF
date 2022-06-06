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
    print("Getting groups...");

    final storePath = (await getApplicationDocumentsDirectory()).path;
    final path = '$storePath/${store.state
        .content['session'].studentNumber}/groups.json';
    final file = File(path);

    print("Path: $path");

    if (!await file.exists()) {
      await file.create(recursive: true);
      await file.writeAsString(jsonEncode({'groups':[]}));
      return [];
    }

    final groupsJson = await file.readAsString();

    print("File: $groupsJson");

    final List<Map<String, dynamic>> groupsMap =
    jsonDecode(groupsJson)['groups'];

    final List<Group> groups = [];

    for (Map<String, dynamic> group in groupsMap) {
      groups.add(Group.fromJson(group));
    }

    print("Groups got");

    return groups;
  }

  @override
  Future<void> setGroups(Store<AppState> store, List<Group> groups) async {
    print("Setting groups");
    final List<Map<String, dynamic>> groupsMap = [];

    for (Group group in groups) {
      groupsMap.add(group.toMap());
    }

    final storePath = await getApplicationDocumentsDirectory();
    final path = '$storePath/${store.state
        .content['session'].studentNumber}/groups.json';
    final file = File(path);

    Map<String, dynamic> result = {'groups': groupsMap};

    await file.writeAsString(jsonEncode(result));

    print("Groups set");
  }
}
