// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';

import 'package:travel_app/Dataservice/httpservice.dart';

class Homepage extends StatefulWidget {
  const Homepage({ Key? key }) : super(key: key);
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  ApiService apiService=Get.find<ApiService>();
  ScrollController scrollController=ScrollController();
  var currentheight=0.0;

  @override
  void initState() {
    super.initState();
    apiService.homepagedetails();
    scrollController.addListener(() {
      setState(() {
        currentheight=scrollController.offset;
      });
    });
  }
  
  double pw=Get.size.height;
  double ph=Get.size.height;

  @override
  Widget build(BuildContext context) {
    return Obx((){
      if(apiService.gettingdetails.value){
        return loading();
      }else{
      var totalheight=ph*(0.6)*min(apiService.images.length,apiService.text.length);
      return apiService.headertitle.toString()==''?empty():Scaffold(
        body: body(),floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
        floatingActionButton: bar(totalheight),
      );
      }
    });
  }

  Widget bar(totalheight){
    return Stack(
      children: [
        Container(margin: EdgeInsets.only(top:20),
          height: 140,
          width: 6,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white.withOpacity(0.5)),
        ),
      Container(margin: EdgeInsets.only(top:20),
        height:140*(currentheight/totalheight),
        width: 6,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white.withOpacity(0.9)),
      )
      ],
    );
  }

  Widget body(){
    return ListView(
      controller: scrollController,
      shrinkWrap: true,
      children: [
        Stack(
          children: [
            Container(width: double.infinity,height:ph,
             child:FadeInImage(fit: BoxFit.fill,
                  placeholder: AssetImage('images/loading.png'),
                  image:NetworkImage(apiService.headerimage.toString()),
                  ),
            ),    
        Positioned(bottom: 0,left: 0,child: text(1,'${apiService.headertitle}',24.0,FontWeight.bold,Colors.white,0.0,50.0,30.0,10.0,)),
          ],
        ),
        ListView.builder(
          itemBuilder: (context,index){
          return card(index);
          },
          itemCount: min(apiService.images.length,apiService.text.length),
          shrinkWrap:true,physics: BouncingScrollPhysics(),
          )
      ],
    );
  }

  Widget card(index){
    return Column(
      children: [
        Container(width: double.infinity,height: ph*0.18,
          color: Colors.orange.withOpacity(0.2),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              text(1,'${apiService.text[index][0]}',17.0,FontWeight.w400,Colors.black.withOpacity(0.5),20.0,0.0,20.0,10.0,),
              text(3,'${apiService.text[index][1]}',19.0,FontWeight.w500,Colors.black.withOpacity(0.9),0.0,20.0,20.0,10.0,),
            ],
          ),
        ),
        Container(height: ph*0.42,width: double.infinity,
              child:FadeInImage(fit: BoxFit.fill,
              placeholder: AssetImage('images/loading.png'),
              image:NetworkImage(apiService.images[index].toString()),
              ),
        ),
      ],
    );
  }

  Widget text(ml,text1,fontsize,fontWeight,color,to,bo,le,ri){
    return Padding(
      padding:EdgeInsets.only(top:to,bottom: bo,left: le,right: ri),
      child: Text("$text1",maxLines: ml,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: fontsize,fontWeight:fontWeight,color: color),),
    );
  }

  Widget loading(){
    return Scaffold(backgroundColor: Colors.white,body: Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          text(1,'Loading',19.0,FontWeight.w400,Colors.black.withOpacity(0.5),20.0,0.0,20.0,10.0,),
          text(1,'Please wait...',19.0,FontWeight.w400,Colors.black.withOpacity(0.5),20.0,0.0,20.0,10.0,),
          SizedBox(height: 50,),
          CircularProgressIndicator(color: Colors.black.withOpacity(0.5),)
    ],),),);
  }

    Widget empty(){
    return Scaffold(backgroundColor: Colors.white,body: Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          text(1,'Some error',19.0,FontWeight.w400,Colors.black.withOpacity(0.5),20.0,0.0,20.0,10.0,),
          text(1,'No data found.',19.0,FontWeight.w400,Colors.black.withOpacity(0.5),20.0,0.0,20.0,10.0,),
          SizedBox(height: 50,),
          Icon(Icons.error_outline_outlined,size: 30,color: Colors.black.withOpacity(0.5),)
    ],),),);
  }
}