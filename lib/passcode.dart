library passcode;

import 'package:flutter/material.dart';

typedef Null PasscodeChangedCallback(String passcode);
typedef Null BlockTextChangedCallback(String blockText, int blockPosition);

enum PasscodeType {
  number,
  alphaNumeric,
}

class PasscodeTextField extends StatefulWidget {
  final int totalCharacters;
  final PasscodeType passcodeType;
  final PasscodeChangedCallback onTextChanged;
  final Size size;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final bool obscureText;

  PasscodeTextField({
    @required this.totalCharacters,
    this.passcodeType = PasscodeType.alphaNumeric,
    @required this.onTextChanged,
    this.size,
    this.backgroundColor = Colors.white,
    this.borderColor = Colors.transparent,
    this.textColor = Colors.black,
    this.obscureText = false,
  }) : assert(totalCharacters <= 10);

  @override
  _PasscodeTextFieldState createState() => _PasscodeTextFieldState();
}

class _PasscodeTextFieldState extends State<PasscodeTextField> {
  List<FocusNode> focusNodes;
  Map<int, String> passcode = {};

  @override
  void initState() {
    super.initState();
    focusNodes = List.generate(widget.totalCharacters, (int n) {
      return FocusNode();
    });
  }

  @override
  Widget build(BuildContext context) {

    double widthSize = 1.0;
    double heightSize = 1.0;

    if(widget.size != null) {
      widthSize = widget.size.width / widget.totalCharacters;
      heightSize = widget.size.height;
    }

    return Container(
      width: widget.size?.width ?? null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.totalCharacters, (index) {
          return TextFieldBox(
            widget.size != null
                ? (widthSize > heightSize ? heightSize : widthSize)
                : 50.0,
                (blockText, blockPosition) {
              if (blockText == "") {
                if (blockPosition > 0) {
                  FocusScope.of(context)
                      .requestFocus(focusNodes[blockPosition - 1]);
                }
              } else if (blockPosition < focusNodes.length - 1) {
                FocusScope.of(context)
                    .requestFocus(focusNodes[blockPosition + 1]);
              }
              if(blockText == "") {
                passcode[blockPosition] = null;
              } else {
                passcode[blockPosition] = blockText;
              }
              String currentPasscode = "";
              for (int i = 0; i < widget.totalCharacters; i++) {
                currentPasscode += passcode[i];
              }
              widget.onTextChanged(currentPasscode);
            },
            widget.passcodeType,
            index,
            focusNodes[index],
            widget.backgroundColor,
            widget.borderColor,
            widget.totalCharacters,
            widget.textColor,
            widget.obscureText,
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    focusNodes.forEach((node) {
      node.dispose();
    });
  }
}

class TextFieldBox extends StatefulWidget {
  final double size;
  final BlockTextChangedCallback onBlockTextChanged;
  final PasscodeType passcodeType;
  final int boxPosition;
  final FocusNode focusNode;
  final Color backgroundColor;
  final Color borderColor;
  final int totalCharacters;
  final Color textColor;
  final bool obscureText;

  TextFieldBox(
      this.size,
      this.onBlockTextChanged,
      this.passcodeType,
      this.boxPosition,
      this.focusNode,
      this.backgroundColor,
      this.borderColor,
      this.totalCharacters,
      this.textColor,
      this.obscureText,
      );

  @override
  _TextFieldBoxState createState() => _TextFieldBoxState();
}

class _TextFieldBoxState extends State<TextFieldBox> {
  TextEditingController controller;
  String previousText = "";

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.size,
      width: widget.size,
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: widget.borderColor ?? Colors.transparent,
          ),
        ),
        color: widget.backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Center(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: controller,
                    obscureText: widget.obscureText,
                    focusNode: widget.focusNode,
                    style: TextStyle(color: widget.textColor ?? Colors.black, fontSize: widget.size * 0.4),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '',
                      counterStyle: TextStyle(
                        color: Colors.transparent,
                      ),
                    ),
                    keyboardType: _getKeyboardType(widget.passcodeType),
                    onChanged: (value) {
                      if (value == "") {
                        widget.onBlockTextChanged("", widget.boxPosition);
                      } else {
                        controller.text = value[value.length - 1];
                        widget.onBlockTextChanged(
                            value[value.length - 1], widget.boxPosition);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextInputType _getKeyboardType(PasscodeType type) {
    switch (type) {
      case PasscodeType.alphaNumeric:
        return TextInputType.text;
      case PasscodeType.number:
        return TextInputType.number;
      default:
        return TextInputType.text;
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
