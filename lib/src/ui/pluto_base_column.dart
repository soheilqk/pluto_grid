import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

class PlutoBaseColumn extends PlutoStatefulWidget {
  final PlutoGridStateManager stateManager;
  final PlutoColumn column;
  final bool first;
  final bool last;

  PlutoBaseColumn({this.stateManager, this.column, this.first, this.last}) : super(key: column.key);

  @override
  _PlutoBaseColumnState createState() => _PlutoBaseColumnState();
}

abstract class _PlutoBaseColumnStateWithChange extends PlutoStateWithChange<PlutoBaseColumn> {
  bool showColumnFilter;

  @override
  void onChange() {
    resetState((update) {
      showColumnFilter = update<bool>(
        showColumnFilter,
        widget.stateManager.showColumnFilter,
      );
    });
  }
}

class _PlutoBaseColumnState extends _PlutoBaseColumnStateWithChange {
  @override
  Widget get showFilter {
    final child = PlutoColumnFilter(
      stateManager: widget.stateManager,
      column: widget.column,
    );
    if (showColumnFilter) {
      if (widget.first) {
        return Container(
            margin: EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
                color: Colors.grey[100]),
            child: child);
      } else if (widget.last) {
        return Container(
            margin: EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
                color: Colors.grey[100]),
            child: child);
      } else if (widget.first == false && widget.last == false) {
        return Container(margin: EdgeInsets.symmetric(vertical: 4), color: Colors.grey[100], child: child);
      }
    } else {
      return Container();
    }
  }

  Widget build(BuildContext context) {
    var child = PlutoColumnTitle(
      stateManager: widget.stateManager,
      column: widget.column,
    );
    return Column(
      children: [
        if (widget.first)
          Container(
              // decoration: BoxDecoration(
              //   borderRadius: const BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
              //   color: Colors.grey[200],
              // ),
              child: child),
        if (widget.last)
          Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                  color: Colors.amber),
              child: child),
        if (widget.first == false && widget.last == false)
          Container(
              //color: Colors.grey[200],
              child: child),
        showFilter,
      ],
    );
  }
}
