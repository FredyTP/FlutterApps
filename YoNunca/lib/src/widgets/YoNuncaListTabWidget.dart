import 'package:YoNunca/src/app_state.dart';
import 'package:YoNunca/src/bloc/bloc_provider.dart';
import 'package:YoNunca/src/models/frase_model.dart';
import 'package:YoNunca/src/widgets/YoNuncaListTile.dart';
import 'package:flutter/material.dart';

class YoNuncaListTabWidget extends StatefulWidget {
  final String uid;
  final bool canEdit;
  YoNuncaListTabWidget({Key key, this.uid, this.canEdit = false}) : super(key: key);

  @override
  _YoNuncaListTabWidgetState createState() => _YoNuncaListTabWidgetState();
}

class _YoNuncaListTabWidgetState extends State<YoNuncaListTabWidget> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = AppStateContainer.of(context).blocProvider;
    return Expanded(
      child: Container(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: TabBar(
                controller: _tabController,
                tabs: [
                  FlatButton.icon(
                      onPressed: null,
                      icon: Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
                      label: Text("Aceptadas")),
                  FlatButton.icon(
                      onPressed: null,
                      icon: Icon(
                        Icons.timelapse,
                        color: Colors.yellow,
                      ),
                      label: Text("Pendientes"))
                ],
              ),
            ),
            Expanded(
              flex: 12,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _yoNuncaListPage(context: context, pending: false, bloc: bloc, uid: widget.uid),
                  _yoNuncaListPage(context: context, pending: true, bloc: bloc, uid: widget.uid),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _yoNuncaListPage({BuildContext context, bool pending, BlocProvider bloc, String uid}) {
    return Container(
      padding: EdgeInsets.all(5),
      child: StreamBuilder(
        stream: bloc.fraseBloc.getUserFrasesStream(uid: uid, pending: pending),
        builder: (context, AsyncSnapshot<List<FraseModel>> snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          } else {
            final list = snapshot.data;
            if (list.length == 0) {
              return Center(child: Text("No hay ningun Yo Nunca"));
            }
            return ListView.separated(
              separatorBuilder: (context, index) {
                return Divider(
                  indent: 100,
                  endIndent: 100,
                  height: 1,
                );
              },
              itemCount: list.length,
              itemBuilder: (context, index) {
                final frase = list[index];
                return YoNuncaListTile(
                  yoNunca: frase,
                  canEdit: widget.canEdit,
                );
              },
            );
          }
        },
      ),
    );
  }
}
