import 'package:domestic_violence/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:domestic_violence/main.dart';

class TicTacToe extends StatefulWidget {
  @override
  _TicTacToeState createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {
  final Color primaryColor=Color(0xff18203d);
  final Color secondaryColor = Color(0xff232c51);
  final Color logoGreen=Color(0xff25bcbb);

  bool oTurn=true; //first turn is o
  List<String> displayXO=['','','','','','','','',''];
  var myTextStyle=TextStyle(color:Colors.white,fontSize: 20);
  int xScore=0;
  int oScore=0;
  int filledBox=0;
  int consecutiveTaps=0;
  int lastTap=DateTime.now().millisecondsSinceEpoch;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:primaryColor ,
        title:Text('TicTacToe'),
      ),
      backgroundColor: secondaryColor,

      body:Container(
        margin:EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Expanded(
              child:Container(
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('PlayerX', style:myTextStyle,),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(xScore.toString(), style:myTextStyle,),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('PlayerO',style:myTextStyle,),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(oScore.toString(), style:myTextStyle,),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

              ),
            ),
            Expanded(
              flex:3,
              child: GridView.builder(
                  itemCount: 9,
                  gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                  itemBuilder: (BuildContext context,int index) {
                    return GestureDetector(
                      onTap: () {
                        _tapped(index);
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[700])
                          ),
                          child: Center(
                            child: Text(displayXO[index],
                              style: TextStyle(color: Colors.white, fontSize: 40),),
                          )
                      ),
                    );
                  }),
            ),
            Expanded(
              child:
              GestureDetector(

                onTap: () {

                  int now = DateTime.now().millisecondsSinceEpoch;
                  if (now - lastTap < 1000) {
                    consecutiveTaps+=1;
                    if (consecutiveTaps == 3){
                      consecutiveTaps = 0;
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => Login_Screen()));
                    }
                  } else {
                    consecutiveTaps = 0;
                  }
                  lastTap = now;
                },
              ),

            ),

          ],
        ),
      ),
    );
  }
  void _tapped(int index){

    setState(() {
      if(oTurn && displayXO[index]==''){
        filledBox+=1;
        displayXO[index]='O';
        oTurn=!oTurn;
      }else if(!oTurn && displayXO[index]==''){
        filledBox+=1;
        displayXO[index]='X';
        oTurn=!oTurn;
      }

      _checkWinner();
    });

  }
  void _checkWinner(){
    if(displayXO[0]==displayXO[1] && displayXO[1]==displayXO[2] && displayXO[0]!='')
    {
      _showWinner(displayXO[0]);
    }
    if(displayXO[3]==displayXO[4] && displayXO[3]==displayXO[5] && displayXO[3]!='')
    {
      _showWinner(displayXO[3]);
    }
    if(displayXO[6]==displayXO[7] && displayXO[6]==displayXO[8] && displayXO[6]!='')
    {
      _showWinner(displayXO[6]);
    }
    if(displayXO[0]==displayXO[3] && displayXO[0]==displayXO[6] && displayXO[0]!='')
    {
      _showWinner(displayXO[0]);
    }
    if(displayXO[1]==displayXO[4] && displayXO[1]==displayXO[7] && displayXO[1]!='')
    {
      _showWinner(displayXO[1]);
    }
    if(displayXO[2]==displayXO[5] && displayXO[2]==displayXO[8] && displayXO[2]!='')
    {
      _showWinner(displayXO[2]);
    }
    if(displayXO[6]==displayXO[4] && displayXO[6]==displayXO[2] && displayXO[6]!='')
    {
      _showWinner(displayXO[6]);
    }
    if(displayXO[0]==displayXO[4] && displayXO[0]==displayXO[8] && displayXO[0]!='')
    {
      _showWinner(displayXO[0]);
    }
    else if(filledBox==9)
    {
      _showDrawDialog();
    }
  }

  void _showWinner(String winner){
    showDialog(
        barrierDismissible: false,
        context: context,
        builder:(BuildContext context){
          return AlertDialog(
            title:Text('WINNER IS:'+ winner),
            actions:[
              FlatButton(
                child: Text('Play Again!'),
                onPressed:(){
                  _clearBoard();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
    );

    if(winner=='O'){
      oScore+=1;
    }else if(winner=='X'){
      xScore+=1;
    }

  }

  void _showDrawDialog(){
    showDialog(
        barrierDismissible: false,
        context: context,
        builder:(BuildContext context){
          return AlertDialog(
            title:Text('DRAW!'),
            actions:[
              FlatButton(
                child: Text('Play Again!'),
                onPressed:(){
                  _clearBoard();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
    );

  }
  void _clearBoard() {
    setState(() {
      for (int i = 0; i < 9; i++) {
        displayXO[i] = '';
      }
      filledBox=0;
    });
  }
}

