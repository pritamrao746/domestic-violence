import 'package:flutter/material.dart';
import 'package:domestic_violence/home.dart';
import 'package:domestic_violence/Settings.dart';
import 'package:domestic_violence/Logout.dart';

class Home_Screen extends StatefulWidget {
  @override
  _Home_ScreenState createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen> {
  int index=0;
  final Color primaryColor=Color(0xff18203d);
  final Color secondaryColor = Color(0xff232c51);
  final Color logoGreen=Color(0xff25bcbb);
  List<Widget> list=[
    Home(),
    Settings(),
    Logout(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
          title:Text('Home Page'),
          backgroundColor: primaryColor,
          actions:[
            IconButton(icon: Icon(Icons.g_translate, color:Colors.white) ,onPressed: null)
          ]
      ),
      body:list[index],
      drawer:MyDrawer(onTap:(ctx,i){
        setState((){
          index=i;
          Navigator.pop(ctx);
        });
      },),
    );
  }
}

class MyDrawer extends StatelessWidget {
  final Function onTap;
  MyDrawer({
    this.onTap
  });

  final Color primaryColor=Color(0xff18203d);
  final Color secondaryColor = Color(0xff232c51);
  final Color logoGreen=Color(0xff25bcbb);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width*0.8,
      child:Drawer(
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children:<Widget>[
              DrawerHeader(
                decoration:BoxDecoration(color:primaryColor),
                child:Padding(
                  padding:EdgeInsets.all(6),
                  child:Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment:MainAxisAlignment.end,
                      children:[
                        Center(
                          child: Container(
                            width:60,
                            height:80,
                            child:CircleAvatar(
                              backgroundImage: AssetImage('assets/profile.png'),
                            ),
                          ),
                        ),
                        SizedBox(height:10,),
                        Center(
                          child: Text(
                            'Name',
                            style:TextStyle(
                                fontSize:15,
                                fontWeight:FontWeight.w600,
                                color:Colors.white
                            ),
                          ),
                        ),
                        SizedBox(height: 3,),
                        Center(
                          child: Text(
                            'email.com',
                            style:TextStyle(
                                color:Colors.white,
                                fontSize:12
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ListTile(
                leading:Icon(Icons.home),
                title:Text('Home'),
                onTap:()=>onTap(context,0),
              ),
              ListTile(
                leading:Icon(Icons.settings),
                title:Text('Settings'),
                onTap:()=>onTap(context,1),
              ),
              Divider(height:1,),
              ListTile(
                leading:Icon(Icons.exit_to_app),
                title:Text('LogOut'),
                onTap:()=>onTap(context,2),
              ),
            ],
          )
      ),
    );
  }
}

