import 'package:YoNunca/src/models/app_user.dart';

class AppUserEvent {
  final AppUser user;
  final UserEventType event;

  AppUserEvent({this.event, this.user});
}

enum UserEventType {
  kDisconnected,
  kConnected,
  kUpdated,
  kDeleting,
}
