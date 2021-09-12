import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:petitparser/core.dart';
import 'package:petitparser/petitparser.dart';

void main() {
  runApp(DevicePreview(enabled: !kReleaseMode, builder: (context) => MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      title: 'Calculator',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final CustomColor _customColor = CustomColor();

  String values = '';
  double answer = 0.0;
  List _history = [];

  bool valueEndsWithOperator() {
    return values.endsWith("+") ||
        values.endsWith("-") ||
        values.endsWith("x") ||
        values.endsWith("/") ||
        values.endsWith("*");
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _customColor.backgroundColor,
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${answer == 0.0 ? 0 : answer}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  '${values.isEmpty ? '0' : values}',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.normal),
                ),
                Spacer(),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        KeyPadWidget(
                          customColor: _customColor,
                          label: '7',
                          action: () {
                            setState(() {
                              values = values + '7';
                            });
                          },
                        ),
                        KeyPadWidget(
                          customColor: _customColor,
                          label: '8',
                          action: () {
                            setState(() {
                              values = values + '8';
                            });
                          },
                        ),
                        KeyPadWidget(
                          customColor: _customColor,
                          label: '9',
                          action: () {
                            setState(() {
                              values = values + '9';
                            });
                          },
                        ),
                        OperatorKeypadWidget(
                          operator: "+",
                          action: () {
                            setState(() {
                              if (values.isEmpty) return;
                              if (values.isNotEmpty &&
                                  valueEndsWithOperator()) {
                                values =
                                    values.substring(0, values.length - 1) +
                                        "+";
                                print(values);
                              } else {
                                values += "+";
                              }
                            });
                          },
                        )
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        KeyPadWidget(
                          customColor: _customColor,
                          label: '4',
                          action: () {
                            setState(() {
                              values = values + '4';
                            });
                          },
                        ),
                        KeyPadWidget(
                          customColor: _customColor,
                          label: '5',
                          action: () {
                            setState(() {
                              values = values + '5';
                            });
                          },
                        ),
                        KeyPadWidget(
                          customColor: _customColor,
                          label: '6',
                          action: () {
                            setState(() {
                              values = values + '6';
                            });
                          },
                        ),
                        OperatorKeypadWidget(
                          operator: "-",
                          action: () {
                            setState(() {
                              if (values.isEmpty) return;
                              if (values.isNotEmpty &&
                                  valueEndsWithOperator()) {
                                values =
                                    values.substring(0, values.length - 1) +
                                        "-";
                                print(values);
                              } else {
                                values += "-";
                              }
                            });
                          },
                        )
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        KeyPadWidget(
                          customColor: _customColor,
                          label: '1',
                          action: () {
                            setState(() {
                              values = values + '1';
                            });
                          },
                        ),
                        KeyPadWidget(
                          customColor: _customColor,
                          label: '2',
                          action: () {
                            setState(() {
                              values = values + '2';
                            });
                          },
                        ),
                        KeyPadWidget(
                          customColor: _customColor,
                          label: '3',
                          action: () {
                            setState(() {
                              values = values + '3';
                            });
                          },
                        ),
                        OperatorKeypadWidget(
                            operator: "x",
                            action: () {
                              setState(() {
                                if (values.isEmpty) return;
                                if (values.isNotEmpty &&
                                    valueEndsWithOperator()) {
                                  values =
                                      values.substring(0, values.length - 1) +
                                          "x";
                                  print(values);
                                } else {
                                  values += "x";
                                }
                              });
                            })
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        KeyPadWidget(
                          customColor: _customColor,
                          label: '0',
                          action: () {
                            if (values.isNotEmpty) {
                              setState(() {
                                values = values + "0";
                              });
                            }
                          },
                        ),
                        KeyPadWidget(
                          customColor: _customColor,
                          label: '.',
                          action: () {
                            setState(() {
                              if (values.isEmpty) {
                                values = '0.';
                              } else if (valueEndsWithOperator()) {
                                values += "0.";
                              } else if (!values.contains('.')) {
                                values = values + '.';
                              }
                            });
                          },
                        ),
                        KeyPadWidget(
                            customColor: _customColor,
                            label: '=',
                            action: () {
                              print(values);

                              Parser buildParser() {
                                final builder = ExpressionBuilder();
                                builder.group()
                                  ..primitive((pattern('+-').optional() &
                                          digit().plus() &
                                          (char('.') & digit().plus())
                                              .optional() &
                                          (pattern('eE') &
                                                  pattern('+-').optional() &
                                                  digit().plus())
                                              .optional())
                                      .flatten('number expected')
                                      .trim()
                                      .map(num.tryParse))
                                  ..wrapper(char('(').trim(), char(')').trim(),
                                      (left, value, right) => value);
                                builder.group().prefix(
                                    char('-').trim(), (op, num a) => -a);
                                builder.group().right(char('^').trim(),
                                    (num a, op, num b) => pow(a, b));
                                builder.group()
                                  ..left(char('x').trim(),
                                      (num a, op, num b) => a * b)
                                  ..left(char('/').trim(),
                                      (num a, op, num b) => a / b);
                                builder.group()
                                  ..left(char('+').trim(),
                                      (num a, op, num b) => a + b)
                                  ..left(char('-').trim(),
                                      (num a, op, num b) => a - b);
                                return builder.build().end();
                              }

                              final parser = buildParser();

                              final result = parser.parse(values);

                              setState(() {
                                answer = double.parse('${result.value}');
                              });
                              print('parser: $result');
                              _history.add(values);
                              print(values.split(RegExp('[^+-x//]+')));
                            }),
                        OperatorKeypadWidget(
                          operator: "/",
                          action: () {
                            setState(() {
                              if (values.isEmpty) return;
                              if (values.isNotEmpty &&
                                  valueEndsWithOperator()) {
                                values =
                                    values.substring(0, values.length - 1) +
                                        "/";
                                print(values);
                              } else {
                                values += "/";
                              }
                            });
                          },
                        )
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              if (values.isNotEmpty)
                                values = values.substring(0, values.length - 1);
                            });
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 60, vertical: 20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            backgroundColor: Colors.orange,
                          ),
                          child: Text(
                            "DEL",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 24,
                        ),
                        TextButton(
                            onPressed: () {
                              setState(() {
                                answer = 0.0;
                                values = "";
                              });
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              backgroundColor: Colors.cyan,
                            ),
                            child: Text(
                              "AC",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                            ))
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OperatorKeypadWidget extends StatelessWidget {
  const OperatorKeypadWidget(
      {Key? key, required String operator, required Function action})
      : this.operator = operator,
        this.action = action,
        super(key: key);

  final String operator;
  final Function action;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(15),
          backgroundColor: Colors.blue,
          shape: CircleBorder(),
        ),
        onPressed: () => action(),
        child: Text(
          operator,
          style: TextStyle(color: Colors.white, fontSize: 23),
        ));
  }
}

class KeyPadWidget extends StatelessWidget {
  const KeyPadWidget(
      {Key? key,
      required CustomColor customColor,
      required String label,
      required Function action})
      : _customColor = customColor,
        text = label,
        this.action = action,
        super(key: key);

  final CustomColor _customColor;
  final String text;
  final Function action;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(
            padding: const EdgeInsets.all(15),
            backgroundColor:
                text == '=' ? Colors.cyan : _customColor.keyPadColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20))),
        onPressed: () => action(),
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 23),
        ));
  }
}

class CustomColor {
  final Color backgroundColor = Color.fromRGBO(30, 38, 53, 1);
  final Color keyPadColor = Color.fromRGBO(40, 50, 73, 1);
}
