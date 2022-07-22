import 'dart:math';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/pixel.dart';

class MainScreen extends StatefulWidget {
  final int size;

  const MainScreen({Key? key, required this.size}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  FocusNode focusNode = FocusNode();
  bool _isFinishMove = true;
  final _random = Random();
  final Map<int, Color> colorList = {
    2: Color(0xFFEEE4DA),
    4: Color(0xFFEEE1C9),
    8: Color(0xFFF2B179),
    16: Color(0xFFF59563),
    32: Color(0xFFF67C60),
    64: Color(0xFFF65E3B),
    128: Color(0xFFEDCF73),
    256: Color(0xFFEDCC62),
    512: Color(0xFFEDC850),
    1024: Color(0xFFEDC53F),
    2048: Color(0xFFEDC22D)
  };

  List<List<int>> currentItems = [
    [4, 0, 4, 2],
    [0, 0, 0, 2],
    [0, 0, 0, 2],
    [0, 0, 0, 2]
  ];

  List<List<int>> beforeItems = [];
  List<List<int>> afterItems = [];

  @override
  Widget build(BuildContext context) {
    var _screenSize = MediaQuery.of(context).size;

    FocusScope.of(context).requestFocus(focusNode);

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: (_screenSize.width > _screenSize.height)
              ? _screenSize.height
              : _screenSize.width,
          height: (_screenSize.width > _screenSize.height)
              ? _screenSize.height
              : _screenSize.width,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity == null) return;
                _isFinishMove = false;
                if (details.primaryVelocity! > 0) {
                  _goRight();
                } else {
                  _goLeft();
                }
              },
              onVerticalDragEnd: (details) {
                if (details.primaryVelocity == null) return;
                _isFinishMove = false;
                if (details.primaryVelocity! > 0) {
                  _goDown();
                } else {
                  _goUp();
                }
              },
              child: RawKeyboardListener(
                autofocus: true,
                focusNode: focusNode,
                onKey: (RawKeyEvent event) {
                  _isFinishMove = false;
                  if (event.repeat && _isFinishMove) {
                    EasyDebounce.debounce(
                        'delay-key',
                        const Duration(milliseconds: 500),
                        () => _onKeyPress(event.data.logicalKey));
                  } else {
                    _onKeyPress(event.data.logicalKey);
                  }
                },
                child: _buildGrid(context, widget.size, widget.size),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _onKeyPress(LogicalKeyboardKey logicalKeyboardKey) {
    if (logicalKeyboardKey == LogicalKeyboardKey.arrowDown) {
      _goDown();
    }
    if (logicalKeyboardKey == LogicalKeyboardKey.arrowLeft) {
      _goLeft();
    }
    if (logicalKeyboardKey == LogicalKeyboardKey.arrowRight) {
      _goRight();
    }
    if (logicalKeyboardKey == LogicalKeyboardKey.arrowUp) {
      _goUp();
    }
  }

  _goDown() {
    print('DOWN');
    List<List<int>> newList = [];
    for (var j = 0; j < widget.size; j++) {
      List<int> list = [];
      for (var i = widget.size - 1; i >= 0; i--) {
        list.add(currentItems[i][j]);
      }
      newList.add(list);
    }

    List<List<int>> transformedItems = [];
    for (var i = 0; i < widget.size; i++) {
      transformedItems.add(_getTransformedList(newList[i]));
    }

    List<List<int>>? rearrangeItems = [];
    for (var i = widget.size - 1; i >= 0; i--) {
      List<int> list = [];
      for (var j = 0; j < widget.size; j++) {
        list.add(transformedItems[j][i]);
      }
      rearrangeItems.add(list);
    }
    rearrangeItems = addNewNumber(rearrangeItems);

    if (rearrangeItems == null) {
      return;
    } else {
      setState(() {
        currentItems = rearrangeItems!;
        _isFinishMove = true;
      });
    }
  }

  _goUp() {
    print('UP');
    List<List<int>> newList = [];
    for (var j = 0; j < widget.size; j++) {
      List<int> list = [];
      for (var i = 0; i < widget.size; i++) {
        list.add(currentItems[i][j]);
      }
      newList.add(list);
    }

    List<List<int>> transformedItems = [];
    for (var i = 0; i < widget.size; i++) {
      transformedItems.add(_getTransformedList(newList[i]));
    }

    List<List<int>>? rearrangeItems = [];
    for (var i = 0; i < widget.size; i++) {
      List<int> list = [];
      for (var j = 0; j < widget.size; j++) {
        list.add(transformedItems[j][i]);
      }
      rearrangeItems.add(list);
    }

    rearrangeItems = addNewNumber(rearrangeItems);

    if (rearrangeItems == null) {
      return;
    } else {
      setState(() {
        currentItems = rearrangeItems!;
        _isFinishMove = true;
      });
    }
  }

  _goLeft() {
    print('LEFT');
    List<List<int>>? transformedItems = [];
    for (var i = 0; i < widget.size; i++) {
      transformedItems.add(_getTransformedList(currentItems[i]));
    }
    transformedItems = addNewNumber(transformedItems);

    if (transformedItems == null) {
      return;
    } else {
      setState(() {
        currentItems = transformedItems!;
        _isFinishMove = true;
      });
    }
  }

  _goRight() {
    print('RIGHT');
    List<List<int>>? transformedItems = [];
    for (var i = 0; i < widget.size; i++) {
      transformedItems.add(
          _getTransformedList(currentItems[i].reversed.toList())
              .reversed
              .toList());
    }
    transformedItems = addNewNumber(transformedItems);

    if (transformedItems == null) {
      return;
    } else {
      setState(() {
        currentItems = transformedItems!;
        _isFinishMove = true;
      });
    }
  }

  List<int> _getTransformedList(List<int> beforeList) {
    List<int> transformedList = [];
    List<int> transformedIndex = [];

    beforeList.removeWhere((e) => e == 0);

    if (beforeList.isEmpty) return List<int>.generate(widget.size, (_) => 0);

    for (var i = 0; i < beforeList.length; i++) {
      if (!transformedIndex.contains(i)) {
        if (i == beforeList.length - 1 || beforeList[i] != beforeList[i + 1]) {
          transformedList.add(beforeList[i]);
          transformedIndex.add(i);
        } else {
          transformedIndex.addAll([i, i + 1]);
          transformedList.add(2 * beforeList[i]);
        }
      }
    }

    return List<int>.generate(widget.size,
        (i) => (i > transformedList.length - 1) ? 0 : transformedList[i]);
  }

  Widget _buildGrid(BuildContext context, int rowLength, int columnLength) {
    return Column(
      children: [..._buildColumns(context, rowLength, columnLength)],
    );
  }

  _buildColumns(BuildContext context, int rowLength, int columnLength) {
    List<Widget> listColumn = [];
    for (var i = 0; i < columnLength; i++) {
      listColumn.add(Expanded(
          child: Row(
        children: [..._buildRows(context, rowLength, i)],
      )));
    }
    return listColumn;
  }

  _buildRows(BuildContext context, int rowLength, int columnIndex) {
    List<Widget> listRow = [];
    for (var i = 0; i < rowLength; i++) {
      listRow.add(Expanded(
          child: Pixel(
        color: colorList[currentItems[columnIndex][i]],
        child: Text(
          currentItems[columnIndex][i] != 0
              ? currentItems[columnIndex][i].toString()
              : '',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
      )));
    }
    return listRow;
  }

  List<List<int>>? addNewNumber(List<List<int>> items) {
    List<int> x = [];
    List<int> y = [];
    for (var i = 0; i < widget.size; i++) {
      for (var j = 0; j < widget.size; j++) {
        if (items[i][j] == 0) {
          x.add(i);
          y.add(j);
        }
      }
    }

    if (x.isEmpty) {
      return null;
    }

    var _randomIndex = _random.nextInt(x.length);
    items[x[_randomIndex]][y[_randomIndex]] = 2;
    return items;
  }
}
