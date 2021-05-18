import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/home/jobs/empty_content.dart';

//type definition
typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemBuilder<T> extends StatelessWidget {
  const ListItemBuilder(
      {Key key, @required this.snapshot, @required this.itemBuilder})
      : super(key: key);
  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final List<T> items = snapshot.data;

      if (items.isNotEmpty) {
        return _buildList(items);
      }
    } else if (snapshot.hasError) {
      return EmptyContent(
        title: 'Something went wrong',
        message: "Can't load items right now",
      );
    } else {
      return CircularProgressIndicator();
    }
    return Center(
      child: EmptyContent(),
    );
  }

  Widget _buildList(List<T> items) {
    return ListView.separated(
        //for large number of items
        separatorBuilder: (context, index) => Divider(
              height: 0.5,
            ),
        itemCount: items.length + 2,
        itemBuilder: (context, index) {
          //TRICK TO HAVE DIVIDER
          if (index == 0 || index == items.length + 1) {
            return Container();
          }
          return itemBuilder(context, items[index - 1]);
        });
  }
}
