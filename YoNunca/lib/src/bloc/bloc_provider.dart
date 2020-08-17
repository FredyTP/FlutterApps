import 'package:YoNunca/src/bloc/admin_management_bloc.dart';
import 'package:YoNunca/src/bloc/app_user_bloc.dart';
import 'package:YoNunca/src/bloc/chat_bloc.dart';
import 'package:YoNunca/src/bloc/frase_bloc.dart';
import 'package:YoNunca/src/bloc/friends_bloc.dart';

class BlocProvider {
  AppUserBloc appUserBloc;
  FraseBloc fraseBloc;
  AdminManagementBloc adminBloc;
  FriendsBloc friendsBloc;
  ChatBloc chatBloc;
  void init() {
    //
    appUserBloc = AppUserBloc();
    appUserBloc.init();

    fraseBloc = FraseBloc();

    adminBloc = AdminManagementBloc();

    friendsBloc = FriendsBloc();

    chatBloc = ChatBloc();
  }
}
