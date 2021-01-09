import 'package:GymStats/src/model/data/statistics.dart';
import 'package:GymStats/src/pages/stats/graphics_page.dart';
import 'package:GymStats/src/pages/stats/profile_page.dart';
import 'package:GymStats/src/pages/stats/training_stats_page.dart';
import 'package:flutter/material.dart';

class StatsPage extends StatefulWidget {
  StatsPage({Key key}) : super(key: key);
  static final route = "StatsPage";

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("mean");
    print(Statistics.min([1, 1, 1, 1, 2, 3, 3, 3, 4, 5, 6, 7, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8]));
    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil"),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: TabBar(
              controller: _tabController,
              tabs: [
                FlatButton(
                  onPressed: null,
                  child: Icon(
                    Icons.show_chart,
                    color: Colors.black,
                  ),
                ),
                FlatButton(
                  onPressed: null,
                  child: Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                ),
                FlatButton(
                  onPressed: null,
                  child: Icon(
                    Icons.change_history,
                    color: Colors.black,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            flex: 14,
            child: TabBarView(
              controller: _tabController,
              children: [
                GraphicsPage(),
                ProfilePage(),
                TrainingStatsPage(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
