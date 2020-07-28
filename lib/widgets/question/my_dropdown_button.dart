import 'package:flutter/material.dart';

class MyDropDownButton extends StatefulWidget {
  final bool isClazzSelect;
  final List<String> dropDownList;
  final Function onSelectItem;
  final Function onChangeLessonList;

  MyDropDownButton(this.dropDownList, this.onSelectItem, this.isClazzSelect,
      {this.onChangeLessonList});

  @override
  _MyDropDownButtonState createState() => _MyDropDownButtonState();
}

class _MyDropDownButtonState extends State<MyDropDownButton> {
  var dropDownValue;

  @override
  void initState() {
    super.initState();
    dropDownValue = widget.dropDownList[0];
    widget.onSelectItem(dropDownValue);
  }

  @override
  void didUpdateWidget(MyDropDownButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isClazzSelect) {
      dropDownValue = widget.dropDownList[widget.dropDownList.indexOf(dropDownValue)];
    } else {
      dropDownValue = widget.dropDownList[0];
    }
    widget.onSelectItem(dropDownValue);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropDownValue,
      icon: Icon(Icons.arrow_drop_down),
      iconSize: 24,
      elevation: 8,
      underline: Container(
        height: 2,
        color: Theme.of(context).accentColor,
      ),
      onChanged: (value) {
        setState(() {
          dropDownValue = value;
          widget.onSelectItem(value);
          if (widget.isClazzSelect) {
            widget.onChangeLessonList(value);
          }
        });
      },
      items: widget.dropDownList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: Theme.of(context).textTheme.bodyText1,),
        );
      }).toList(),
    );
  }
}
