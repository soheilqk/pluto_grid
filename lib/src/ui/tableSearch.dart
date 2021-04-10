import 'package:flutter/material.dart';

class TableSearch extends StatefulWidget {
  //
  final double width;
  final void Function() onSearchClick;
  final TextEditingController controller;

  TableSearch({
    @required this.width,
    @required this.onSearchClick,
    @required this.controller,
  });

  @override
  _TableSearchState createState() => _TableSearchState();
}

class _TableSearchState extends State<TableSearch> {
  //
  var showClearButton = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      if(mounted){
        if (widget.controller.text.isNotEmpty) {
          setState(() {
            showClearButton = true;
          });
        } else {
          setState(() {
            showClearButton = false;
          });
        }
      }
    });
  }
  @override
  bool get mounted => super.mounted;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0x7Fffffff),
      width: widget.width,
      height: 40,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 40,
            width: 18,
            child: showClearButton
                ? IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 18,
                    ),
                    onPressed: () {
                      widget.controller.clear();
                    },
                  )
                : Container(),
          ),
          Expanded(
              child: TextFormField(
            controller: widget.controller,
            textAlignVertical: TextAlignVertical.center,
            decoration: const InputDecoration(border: InputBorder.none),
          )),
          InkWell(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Image.asset(
                'assets/images/icons/search.png',
                width: 18,
                height: 18,
              ),
            ),
            onTap: widget.onSearchClick,
          ),
        ],
      ),
    );
  }
}
