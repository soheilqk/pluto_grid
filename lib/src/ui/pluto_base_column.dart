import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

class PlutoBaseColumn extends PlutoStatefulWidget {
  final PlutoGridStateManager stateManager;
  final PlutoColumn column;
  final bool first;
  final bool last;
  final Color headerColor;
  final Color rowColor;
  final Color dividerColor;
  final double headerRadius;
  final Color descendingIconColor;
  final Color ascendingIconColor;
  final Function onCheck;

  PlutoBaseColumn({
    this.stateManager,
    this.column,
    this.first,
    this.last,
    this.headerColor,
    this.dividerColor,
    this.rowColor,
    this.headerRadius,
    this.ascendingIconColor,
    this.descendingIconColor,
    this.onCheck,
  }) : super(key: column.key);

  @override
  _PlutoBaseColumnState createState() => _PlutoBaseColumnState();
}

abstract class _PlutoBaseColumnStateWithChange
    extends PlutoStateWithChange<PlutoBaseColumn> {
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
            margin: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5)),
                color: Colors.grey[100]),
            child: child);
      } else if (widget.last) {
        return Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5)),
                color: Colors.grey[100]),
            child: child);
      } else if (widget.first == false && widget.last == false) {
        return Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            color: Colors.grey[100],
            child: child);
      }
    } else {
      return Container();
    }
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        PlutoColumnTitle(
          stateManager: widget.stateManager,
          column: widget.column,
          isLast: widget.last,
          isFirst: widget.first,
          rowColor: widget.rowColor,
          headerColor: widget.headerColor,
          dividerColor: widget.dividerColor,
          headerRadius: widget.headerRadius,
          ascendingIconColor: widget.ascendingIconColor,
          descendingIconColor: widget.descendingIconColor,
          onCheck: widget.onCheck,
        ),
        showFilter,
      ],
    );
  }
}
