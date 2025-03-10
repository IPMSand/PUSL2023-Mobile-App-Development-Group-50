import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

// To-Do List Screen
class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoState();
}

class _TodoState extends State<TodoScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("To Do List"),
          backgroundColor: Colors.greenAccent,
        ),
        body: _todoBody(),
      ),
    );
  }

// to do body
  Widget _todoBody() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // ttitle
          _topTitle(),
          // img
          _todoImg(),

          // progress
          _progressDetails(),
          // list
          _todoList(),
          // button
          _todoCreateButton(),
        ],
      ),
    );
  }

  _topTitle() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Text(
          'TO DO',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),),
      ),
    );
  }

  _todoImg() {
    return Center(
      child: Image.asset(
        'assets/img11.png',
        width: 220,
      ),
    );
  }

  _progressDetails() {
    return Container(
          margin: EdgeInsets.only(left: 4, right: 4),
          height: 80,
            padding: EdgeInsets.all(1.0), // Padding inside the Container
            decoration: BoxDecoration(
               // Background color
               color: const Color.fromARGB(255, 58, 173, 102),
               borderRadius: BorderRadius.circular(12.0), // Rounded corners radius
            ),
          
          
      child: Column(
        children: [
          //title
          Text(
            'Today Progress',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontWeight:FontWeight.bold),),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
           crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '15 Tasks',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),),
              Column(
                children: [
                  Text(
                    'Progress here',
                    style: TextStyle(
                    fontWeight: FontWeight.w700,
                )
                  ),
                   // progress bar
                    LinearPercentIndicator(
                        width: 70.0,
                        lineHeight: 14.0,
                        percent: 0.3, // here the %
                        backgroundColor: Colors.grey,
                        progressColor: Colors.blue,
                    ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  _todoList() {
    return Text('ffff');
  }

  _todoCreateButton() {
    return Text('ffffffffff');
  }
}