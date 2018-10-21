# passcode

A Flutter widget for entering a passcode.

![alt text](https://github.com/deven98/passcode/blob/master/screenshot_1.png)

This widget allows you to customise number of characters, background and border colors and obscure text.

![alt text](https://github.com/deven98/passcode/blob/master/screenshot_2.png)

## Example

    import 'package:flutter/material.dart';
    import 'package:passcode/passcode.dart';

    void main() => runApp(MyApp());

    class MyApp extends StatelessWidget {
      @override
      Widget build(BuildContext context) {
        return MaterialApp(
          home: Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  PasscodeTextField(
                    onTextChanged: (passcode) {
                      print(passcode);
                    },
                    totalCharacters: 4,
                    borderColor: Colors.black,
                    passcodeType: PasscodeType.number,
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }

## Getting Started

For help getting started with Flutter, view our online [documentation](https://flutter.io/).

For help on editing package code, view the [documentation](https://flutter.io/developing-packages/).
