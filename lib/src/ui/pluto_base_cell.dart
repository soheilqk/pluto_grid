import 'package:custom_rounded_rectangle_border/custom_rounded_rectangle_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pluto_grid/pluto_grid.dart';

class PlutoBaseCell extends PlutoStatefulWidget {
  final PlutoGridStateManager stateManager;
  final PlutoCell cell;
  final double width;
  final double height;
  final PlutoColumn column;
  final int rowIdx;
  final bool isLast;
  final bool isFirst;
  final Color headerColor;
  final Color rowColor;
  final Color dividerColor;
  final double rowRadius;
  final Function onCheck;
  final void Function(Key key) onRowClick;
  final PlutoRow row;

  PlutoBaseCell({
    Key key,
    this.stateManager,
    this.cell,
    this.width,
    this.height,
    this.column,
    this.rowIdx,
    this.isLast,
    this.isFirst,
    this.rowColor,
    this.headerColor,
    this.dividerColor,
    this.rowRadius,
    this.onCheck,
    this.onRowClick,
    this.row,
  }) : super(key: key);

  @override
  _PlutoBaseCellState createState() => _PlutoBaseCellState();
}

abstract class _PlutoBaseCellStateWithChangeKeepAlive
    extends PlutoStateWithChangeKeepAlive<PlutoBaseCell> {
  dynamic cellValue;

  bool isCurrentCell;

  bool isEditing;

  PlutoGridSelectingMode selectingMode;

  bool isSelectedCell;

  bool hasFocus;

  @override
  void onChange() {
    resetState((update) {
      cellValue = update<dynamic>(cellValue, widget.cell.value);

      isCurrentCell = update<bool>(
        isCurrentCell,
        widget.stateManager.isCurrentCell(widget.cell),
      );

      isEditing = update<bool>(isEditing, widget.stateManager.isEditing);

      selectingMode = update<PlutoGridSelectingMode>(
        selectingMode,
        widget.stateManager.selectingMode,
      );

      isSelectedCell = update<bool>(
        isSelectedCell,
        widget.stateManager.isSelectedCell(
          widget.cell,
          widget.column,
          widget.rowIdx,
        ),
      );

      hasFocus = update<bool>(
        hasFocus,
        isCurrentCell && widget.stateManager.hasFocus,
      );

      if (widget.stateManager.mode.isNormal) {
        setKeepAlive(isCurrentCell);
      }
    });
  }
}

class _PlutoBaseCellState extends _PlutoBaseCellStateWithChangeKeepAlive {
  void _addGestureEvent(PlutoGridGestureType gestureType, Offset offset) {
    widget.stateManager.eventManager.addEvent(
      PlutoGridCellGestureEvent(
        gestureType: gestureType,
        offset: offset,
        cell: widget.cell,
        column: widget.column,
        rowIdx: widget.rowIdx,
      ),
    );
  }

  void _handleOnTapUp(TapUpDetails details) {
    _addGestureEvent(PlutoGridGestureType.onTapUp, details.globalPosition);
  }

  void _handleOnLongPressStart(LongPressStartDetails details) {
    _addGestureEvent(
        PlutoGridGestureType.onLongPressStart, details.globalPosition);
  }

  void _handleOnLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    _addGestureEvent(
        PlutoGridGestureType.onLongPressMoveUpdate, details.globalPosition);
  }

  void _handleOnLongPressEnd(LongPressEndDetails details) {
    _addGestureEvent(
        PlutoGridGestureType.onLongPressEnd, details.globalPosition);
  }

  BorderSide borderSide = const BorderSide(width: 1, color: Color(0xff028a99));
  BorderSide noneBorder = const BorderSide(color: Colors.transparent, width: 0);

  @override
  Widget build(BuildContext context) {
    super.build(context);

    var checkedHasBorder = widget.stateManager.configuration.checkedHasBorder;
    var modeSelect = widget.stateManager.mode == PlutoGridMode.select;
    var rowIsSelected = widget.stateManager.isSelectedRow(widget.row.key);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          if (widget.onRowClick != null) {
            widget.onRowClick(widget.row.key);
          }
          if(widget.stateManager.mode== PlutoGridMode.select){
            widget.stateManager.clearCurrentSelectingRows();
            widget.stateManager.toggleSelectingRow(widget.rowIdx);
            //widget.stateManager.notifyListeners();
            setState(() {});
          }
        },
        //behavior: HitTestBehavior.translucent,
        //onTapUp: _handleOnTapUp,
        //onLongPressStart: _handleOnLongPressStart,
        //onLongPressMoveUpdate: _handleOnLongPressMoveUpdate,
        //onLongPressEnd: _handleOnLongPressEnd,
        child: Container(
          decoration: ShapeDecoration(
            color: widget.rowColor,
            shape: CustomRoundedRectangleBorder(
              borderRadius: (widget.rowRadius != null && widget.rowRadius > 0)
                  ? (widget.column.enableRowChecked || widget.isFirst)
                  ? BorderRadius.only(
                topRight: Radius.circular(widget.rowRadius),
                bottomRight: Radius.circular(widget.rowRadius),
              )
                  : widget.isLast
                  ? BorderRadius.only(
                topLeft: Radius.circular(widget.rowRadius),
                bottomLeft: Radius.circular(widget.rowRadius),
              )
                  : BorderRadius.zero
                  : BorderRadius.zero,
              leftSide: modeSelect? rowIsSelected? widget.isLast
                  ? borderSide
                  : noneBorder:noneBorder : (widget.row.checked && checkedHasBorder)
                  ? widget.isLast
                  ? borderSide
                  : noneBorder
                  : noneBorder,
              topSide:  modeSelect? rowIsSelected? borderSide:noneBorder : (widget.row.checked && checkedHasBorder) ? borderSide : noneBorder,
              bottomSide:  modeSelect? rowIsSelected? borderSide:noneBorder : (widget.row.checked && checkedHasBorder) ? borderSide : noneBorder,
              rightSide:  modeSelect? rowIsSelected? widget.isFirst
                  ? borderSide
                  : noneBorder:noneBorder : (widget.row.checked && checkedHasBorder)
                  ? widget.isFirst
                  ? borderSide
                  : noneBorder
                  : noneBorder,
              topRightCornerSide: modeSelect? rowIsSelected? borderSide:noneBorder :  (widget.row.checked && checkedHasBorder)
                  ? widget.isFirst
                  ? borderSide
                  : borderSide
                  : noneBorder,
              bottomRightCornerSide:  modeSelect? rowIsSelected? borderSide:noneBorder : (widget.row.checked && checkedHasBorder)
                  ? widget.isFirst
                  ? borderSide
                  : borderSide
                  : noneBorder,
              topLeftCornerSide: modeSelect? rowIsSelected? borderSide:noneBorder :  (widget.row.checked && checkedHasBorder)
                  ? widget.isLast
                  ? borderSide
                  : borderSide
                  : noneBorder,
              bottomLeftCornerSide: modeSelect? rowIsSelected? borderSide:noneBorder :  (widget.row.checked && checkedHasBorder)
                  ? widget.isLast
                  ? borderSide
                  : borderSide
                  : noneBorder,
            ),
          ),
          child: _CellContainer(
            readOnly: widget.column.type.readOnly,
            width: widget.width,
            height: widget.height,
            hasFocus: widget.stateManager.hasFocus,
            isCurrentCell: isCurrentCell,
            isEditing: isEditing,
            selectingMode: selectingMode,
            isSelectedCell: isSelectedCell,
            configuration: widget.stateManager.configuration,
            child: _BuildCell(
              rowColor: widget.rowColor,
              headerColor: widget.headerColor,
              dividerColor: widget.dividerColor,
              rowRadius: widget.rowRadius,
              isLast: widget.isLast,
              isFirst: widget.isFirst,
              stateManager: widget.stateManager,
              rowIdx: widget.rowIdx,
              column: widget.column,
              cell: widget.cell,
              isCurrentCell: isCurrentCell,
              isEditing: isEditing,
              onCheck: widget.onCheck,
              row: widget.row,
            ),
          ),
        ),
      ),
    );
  }
}

class _CellContainer extends StatelessWidget {
  final bool readOnly;
  final Widget child;
  final double width;
  final double height;
  final bool hasFocus;
  final bool isCurrentCell;
  final bool isEditing;
  final PlutoGridSelectingMode selectingMode;
  final bool isSelectedCell;
  final PlutoGridConfiguration configuration;

  _CellContainer({
    this.readOnly,
    this.child,
    this.width,
    this.height,
    this.hasFocus,
    this.isCurrentCell,
    this.isEditing,
    this.selectingMode,
    this.isSelectedCell,
    this.configuration,
  });

  Color _currentCellColor() {
    if (!hasFocus) {
      return null;
    }

    if (!isEditing) {
      return selectingMode.isRow ? configuration.activatedColor : null;
    }

    return readOnly == true
        ? configuration.cellColorInReadOnlyState
        : configuration.cellColorInEditState;
  }

  BoxDecoration _boxDecoration() {
    if (isCurrentCell) {
      return BoxDecoration(
        color: _currentCellColor(),
        border: configuration.activatedBorderColor != null
            ? Border.all(
                color: configuration.activatedBorderColor,
                width: 1,
              )
            : null,
      );
    } else if (isSelectedCell) {
      return BoxDecoration(
        color: configuration.activatedColor,
        border: configuration.activatedBorderColor != null
            ? Border.all(
                color: configuration.activatedBorderColor,
                width: 1,
              )
            : null,
      );
    } else {
      return configuration.enableColumnBorder
          ? BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: configuration.borderColor,
                  width: 1.0,
                ),
              ),
            )
          : const BoxDecoration();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: _boxDecoration(),
      child: Container(
        //padding: const EdgeInsets.symmetric( horizontal: PlutoGridSettings.cellPadding),
        child: Container(
          clipBehavior: Clip.hardEdge,
          height: height,
          alignment: Alignment.centerLeft,
          decoration: const BoxDecoration(),
          child: child,
        ),
      ),
    );
  }
}

class _BuildCell extends StatelessWidget {
  final PlutoGridStateManager stateManager;
  final int rowIdx;
  final PlutoColumn column;
  final PlutoCell cell;
  final bool isCurrentCell;
  final bool isEditing;
  final bool isLast;
  final bool isFirst;
  final Color headerColor;
  final Color rowColor;
  final Color dividerColor;
  final double rowRadius;
  final Function onCheck;
  final PlutoRow row;

  const _BuildCell({
    Key key,
    this.stateManager,
    this.rowIdx,
    this.column,
    this.cell,
    this.isCurrentCell,
    this.isEditing,
    this.isLast,
    this.isFirst,
    this.rowColor,
    this.headerColor,
    this.dividerColor,
    this.rowRadius,
    this.onCheck,
    this.row,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isCurrentCell && isEditing && column.enableEditingMode == true) {
      if (column.type.isSelect) {
        return PlutoSelectCell(
          stateManager: stateManager,
          cell: cell,
          column: column,
        );
      } else if (column.type.isNumber) {
        return PlutoNumberCell(
          stateManager: stateManager,
          cell: cell,
          column: column,
        );
      } else if (column.type.isDate) {
        return PlutoDateCell(
          stateManager: stateManager,
          cell: cell,
          column: column,
        );
      } else if (column.type.isTime) {
        return PlutoTimeCell(
          stateManager: stateManager,
          cell: cell,
          column: column,
        );
      } else if (column.type.isText) {
        return PlutoTextCell(
          stateManager: stateManager,
          cell: cell,
          column: column,
        );
      }
    }

    return PlutoDefaultCell(
      stateManager: stateManager,
      cell: cell,
      column: column,
      rowIdx: rowIdx,
      isLast: isLast,
      isFirst: isFirst,
      rowColor: rowColor,
      headerColor: headerColor,
      dividerColor: dividerColor,
      rowRadius: rowRadius,
      onCheck: onCheck,
      row: row,
    );
  }
}

enum CellEditingStatus {
  init,
  changed,
  updated,
}

extension CellEditingStatusExtension on CellEditingStatus {
  bool get isChanged {
    return CellEditingStatus.changed == this;
  }
}
