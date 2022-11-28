import 'package:calculator/buttons.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(),
        debugShowCheckedModeBanner :false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var userQuestion = '';
  var userAnswer = '';
  bool isFull = false;
  final List<String> buttons = [
    'C',
    'DEL',
    '%',
    '/',
    '7',
    '8',
    '9',
    'x',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    '+',
    '0',
    '.',
    'ANS',
    '=',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[300],
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                      padding: EdgeInsets.all(20),
                      alignment: Alignment.centerLeft,
                      child: Text(userQuestion, style: TextStyle( fontSize: 20),)),
                  Container(
                      padding: EdgeInsets.all(20),
                      alignment: Alignment.centerRight,
                      child: Text(userAnswer, style: TextStyle( fontSize: 20),)),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              child: GridView.builder(
                  itemCount: buttons.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4),
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      //clear all button
                      return MyButton(
                        buttonTapped: (){
                          setState(() {
                            userQuestion = '';
                            userAnswer = '';
                          });
                        },
                        buttonText: buttons[index],
                        color: Colors.red[700],
                        textcolor: Colors.white,
                      );
                      //delete button
                    } else if (index == 1) {
                      return MyButton(
                        buttonTapped: (){
                          setState(() {
                            userQuestion = userQuestion.substring(0, userQuestion.length - 1);
                          });
                        },
                        buttonText: buttons[index],
                        color: Colors.red[500],
                        textcolor: Colors.white,
                      );
                    // equal button
                    } else if (index == buttons.length-1) {
                      return MyButton(
                        buttonTapped: (){
                            setState(() {
                              equalPressed();
                            });
                        },
                        buttonText: buttons[index],
                        color: Colors.green[900],
                        textcolor: Colors.white,
                      );

                    }
                    //rest of buttons
                    else {
                      return MyButton(
                        buttonTapped: () {

                          setState(() {
                            if (userAnswer == ''){
                            setState(() {
                              userQuestion += buttons[index];
                            });
                            }
                            else if (userAnswer != ''){
                              userQuestion = userAnswer;
                              userAnswer = '';
                              setState(() {
                                userQuestion += buttons[index];
                              });
                            }

                          });
                        },
                        buttonText: buttons[index],
                        color: isOperator(buttons[index])
                            ? Colors.green[900]
                            : Colors.green[100],
                        textcolor: isOperator(buttons[index])
                            ? Colors.white
                            : Colors.green[900],
                      );
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }

  bool isOperator(String x) {
    if (x == '%' || x == '+' || x == 'x' || x == '-' || x == '/' || x == '=') {
      return true;
    }
    return false;
  }
  
  void equalPressed(){
    String finalQuestion = userQuestion;
    finalQuestion = finalQuestion.replaceAll('x', '*');

    Parser p = Parser();
    Expression exp = p.parse(finalQuestion);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);

    userAnswer = eval.toString();
  }


}

