import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

class PlutoBodyColumns extends PlutoStatefulWidget {
  final PlutoGridStateManager stateManager;

  final Color headerColor;
  final Color rowColor;
  final Color dividerColor;
  final double headerRadius;
  final Color descendingIconColor;
  final Color ascendingIconColor;
  final double columnHeight;

  PlutoBodyColumns(
    this.stateManager, {
    this.rowColor,
    this.headerColor,
    this.dividerColor,
    this.headerRadius,
    this.columnHeight,
    this.ascendingIconColor,
    this.descendingIconColor,
  });

  @override
  _PlutoBodyColumnsState createState() => _PlutoBodyColumnsState();
}

abstract class _PlutoBodyColumnsStateWithChange
    extends PlutoStateWithChange<PlutoBodyColumns> {
  List<PlutoColumn> columns;

  double width;

  @override
  void onChange() {
    resetState((update) {
      columns = update<List<PlutoColumn>>(
        columns,
        _getColumns(),
        compare: listEquals,
      );

      width = update<double>(width, _getWidth());
    });
  }

  List<PlutoColumn> _getColumns() {
    return widget.stateManager.showFrozenColumn
        ? widget.stateManager.bodyColumns
        : widget.stateManager.columns;
  }

  double _getWidth() {
    return widget.stateManager.showFrozenColumn
        ? widget.stateManager.bodyColumnsWidth
        : widget.stateManager.columnsWidth;
  }
}

class _PlutoBodyColumnsState extends _PlutoBodyColumnsStateWithChange {
  ScrollController scroll;

  @override
  void dispose() {
    scroll.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    scroll = widget.stateManager.scroll.horizontal.addAndGet();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Row(
        children: columns.map((element) {
          var i = columns.indexOf(element);
          var child = PlutoBaseColumn(
            rowColor: widget.rowColor,
            headerColor: widget.headerColor,
            dividerColor: widget.dividerColor,
            headerRadius: widget.headerRadius,
            stateManager: widget.stateManager,
            column: columns[i],
            first: i == 0,
            last: i == columns.length - 1,
            ascendingIconColor: widget.ascendingIconColor,
            descendingIconColor: widget.descendingIconColor,
            columnHeight: widget.columnHeight,
          );
          if (element.field == 'rowNumber') {
            return child;
          } else {
            return Expanded(
              flex: element.flex,
              child: child,
            );
          }
        }).toList(),
      ),

      // ListView.builder(
      //   controller: scroll,
      //   scrollDirection: Axis.horizontal,
      //   physics: const NeverScrollableScrollPhysics(),
      //   itemCount: columns.length,
      //   itemBuilder: (ctx, i) {
      //     return PlutoBaseColumn(
      //       rowColor: widget.rowColor,
      //       headerColor: widget.headerColor,
      //       dividerColor: widget.dividerColor,
      //       headerRadius: widget.headerRadius,
      //       stateManager: widget.stateManager,
      //       column: columns[i],
      //       first: i == 0,
      //       last: i == columns.length - 1,
      //       ascendingIconColor: widget.ascendingIconColor,
      //       descendingIconColor: widget.descendingIconColor,
      //     );
      //   },
      // ),
    );
  }
}
