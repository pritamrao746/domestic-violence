import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:domestic_violence/home-views/comments.dart';

class AllPosts extends StatefulWidget {
  @override
  _AllPostsState createState() => _AllPostsState();
}

class _AllPostsState extends State<AllPosts> {

  Widget _buildPost(int index){
    return Padding(
      padding:EdgeInsets.symmetric(horizontal: 10.0,vertical:5.0),
      child:Container(
          margin:EdgeInsets.symmetric(vertical:10),
          width:double.infinity,
          height:500.0,
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
                        InkWell(
                          onTap:(){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) => Comments()));
                          },
                          child: Container(
                              margin:EdgeInsets.all(10.0),
                              width:double.infinity,
                              height:325,
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
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (_) => Comments()));
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics:AlwaysScrollableScrollPhysics(),
      children:[
        _buildPost(0),
        _buildPost(1),
      ],
    );
  }
}
