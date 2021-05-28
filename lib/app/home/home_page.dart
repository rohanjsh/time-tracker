import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/home/account/account_page.dart';
import 'package:time_tracker_flutter_course/app/home/cupertino_home_scaffold.dart';
import 'package:time_tracker_flutter_course/app/home/entries/entries_page.dart';
import 'package:time_tracker_flutter_course/app/home/jobs/jobs_page.dart';
import 'package:time_tracker_flutter_course/app/home/tab_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.jobs;

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.jobs: GlobalKey<NavigatorState>(),
    TabItem.entries: GlobalKey<NavigatorState>(),
    TabItem.account: GlobalKey<NavigatorState>(),
  }; //separate global key

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.jobs: (_) => JobsPage(),
      TabItem.entries: (context) => EntriesPage.create(context),
      TabItem.account: (_) => AccountPage(),
    };
  }

  void _select(TabItem tabItem) {
    if (tabItem == _currentTab) {
      navigatorKeys[tabItem]
          .currentState
          .popUntil((route) => route.isFirst); //for switching to root tab
    } else {
      setState(
        () => _currentTab = tabItem,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !await navigatorKeys[_currentTab]
          .currentState
          .maybePop(), //android back button implementation
      child: CupertinoHomeScaffold(
        navigatorKeys: navigatorKeys,
        currentTab: _currentTab,
        onSelectedTab: _select,
        widgetBuilders: widgetBuilders,
      ),
    );
  }
}
