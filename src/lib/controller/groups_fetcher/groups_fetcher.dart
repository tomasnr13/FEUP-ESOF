import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/group.dart';
import 'package:redux/redux.dart';

/// Class for fetching the user's groups.
abstract class GroupsFetcher {
  // Returns the user's groups.
  Future<List<Group>> getGroups(Store<AppState> store);
  // Adds a user's group.
  Future<void> setGroups(Store<AppState> store, List<Group> groups);
}
