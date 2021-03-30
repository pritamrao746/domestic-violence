import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class Comments extends StatefulWidget {
  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  final Color primaryColor=Color(0xff18203d);
  final Color secondaryColor = Color(0xff232c51);
  final Color logoGreen=Color(0xff25bcbb);

  Widget _buildComment(int index){
    return ListTile(
      leading:Container(
        margin:EdgeInsets.all(10),
        width:50,
        height:50,
        decoration:BoxDecoration(
          shape:BoxShape.circle,
          boxShadow:[
            BoxShadow(
              color:Colors.black45,
              offset:Offset(0,2),
              blurRadius:6.0,
            ),
          ],
        ),
        child:CircleAvatar(
          child:ClipOval(
            child:Image(
              height:50.0,
              width:50.0,
              image:AssetImage('assets/profile.png'),
              fit:BoxFit.cover,
            ),
          ),
        ),
      ),
      title:Text(
        'Pritam',
        style:TextStyle(
          fontWeight:FontWeight.bold,
        ),
      ),
      subtitle:Text('SO truee!!!'),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title:Text('Posts'),
            backgroundColor: primaryColor,
            actions:[
              IconButton(icon: Icon(Icons.g_translate, color:Colors.white) ,onPressed: null)
            ]
        ),
        backgroundColor:Color(0xFFEDF0F6),
        body:SingleChildScrollView(
          physics:AlwaysScrollableScrollPhysics(),
          child:Column(
            children:[
              Container(
                  margin:EdgeInsets.symmetric(vertical:10),
                  width:double.infinity,
                  height:425.0,
                  decoration:BoxDecoration(
                    color: Colors.white,
                    borderRadius:BorderRadius.circular(25.0),
                  ),
                  child:Column(
                      children:<Widget>[
                        Padding(
                            padding:EdgeInsets.symmetric(vertical:10),
                            child:Column(
                              children:[
                                ListTile(
                                  leading:Container(
                                    margin:EdgeInsets.all(10),
                                    width:50,
                                    height:50,
                                    decoration:BoxDecoration(
                                      shape:BoxShape.circle,
                                      boxShadow:[
                                        BoxShadow(
                                          color:Colors.black45,
                                          offset:Offset(0,2),
                                          blurRadius:6.0,
                                        ),
                                      ],
                                    ),
                                    child:CircleAvatar(
                                      child:ClipOval(
                                        child:Image(
                                          height:50.0,
                                          width:50.0,
                                          image:AssetImage('assets/profile.png'),
                                          fit:BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  title:Text(
                                    'Mahipal',
                                    style:TextStyle(
                                      fontWeight:FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text('12:04 15th March'),

                                ),
                                Container(
                                    margin:EdgeInsets.all(10.0),
                                    width:250,
                                    height:250,
                                    decoration:BoxDecoration(
                                        borderRadius: BorderRadius.circular(25.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black45,
                                            offset:Offset(0,4),
                                            blurRadius:8,
                                          ),
                                        ],
                                        image:DecorationImage(
                                          image:AssetImage('assets/post1.jpg'),
                                          fit:BoxFit.fitWidth,
                                        )
                                    )
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal:20.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children:[
                                      Row(
                                        children:[
                                          Row(
                                            children:[
                                              IconButton(
                                                icon:Icon(Icons.favorite_border),
                                                iconSize:30,
                                                onPressed:(){

                                                },
                                              ),
                                              Text(
                                                '10',
                                                style:TextStyle(
                                                  fontSize:14.0,
                                                  fontWeight:FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width:20),
                                          Row(
                                              children:[
                                                IconButton(
                                                  icon:Icon(Icons.chat),
                                                  iconSize:30,
                                                  onPressed:(){

                                                  },
                                                ),
                                                Text(
                                                  '2',
                                                  style:TextStyle(
                                                    fontSize:14.0,
                                                    fontWeight:FontWeight.w600,
                                                  ),
                                                ),
                                              ]
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                          icon:Icon(Icons.share),
                                          iconSize:30,
                                          onPressed:(){

                                          }
                                      )
                                    ],
                                  ),
                                )
                              ],
                            )
                        )
                      ]
                  )
              ),
              SizedBox(height:10),
              Container(
                  width:double.infinity,
                  decoration:BoxDecoration(
                    color:Colors.white,
                    borderRadius:BorderRadius.only(
                      topLeft:Radius.circular(30.0),
                      topRight:Radius.circular(30.0),
                    ),
                  ),
                  child:Column(
                      children:[
                        _buildComment(0),
                        _buildComment(1),
                      ]
                  )
              ),
            ],
          ),
        ),
        bottomNavigationBar: Transform.translate(
          offset:Offset(0.0,-1*MediaQuery.of(context).viewInsets.bottom),
          child: Container(
              height:100,
              decoration:BoxDecoration(
                borderRadius:BorderRadius.only(
                  topLeft:Radius.circular(30),
                  topRight:Radius.circular(30),
                ),
                boxShadow:[
                  BoxShadow(
                    color:Colors.black12,
                    offset:Offset(0,-2),
                    blurRadius:6.0,
                  ),
                ],
                color:Colors.white,
              ),
              child:Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  decoration:InputDecoration(
                    border:InputBorder.none,
                    enabledBorder:OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide:BorderSide(color:Colors.grey),
                    ),
                    focusedBorder:OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide:BorderSide(color:Colors.grey),
                    ),
                    hintText:'Add a comment',
                    prefixIcon:Container(
                      margin:EdgeInsets.all(10),
                      width:50,
                      height:50,
                      decoration:BoxDecoration(
                        shape:BoxShape.circle,
                        boxShadow:[
                          BoxShadow(
                            color:Colors.black45,
                            offset:Offset(0,2),
                            blurRadius:6.0,
                          ),
                        ],
                      ),
                      child:CircleAvatar(
                        child:ClipOval(
                          child:Image(
                            height:50.0,
                            width:50.0,
                            image:AssetImage('assets/profile.png'),
                            fit:BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    suffixIcon:Container(
                      margin:EdgeInsets.only(right:10),
                      width:70,
                      child:FlatButton(
                          shape:RoundedRectangleBorder(
                            borderRadius:BorderRadius.circular(30),
                          ),
                          color:Color(0xFF23B66F),
                          child:Icon(
                            Icons.send,
                            size:20,
                            color:Colors.white,
                          )

                      ),
                    ),
                  ),
                ),
              )
          ),
        )
    );
  }
}
