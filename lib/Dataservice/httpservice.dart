import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ApiService extends GetxController{

  final String baseurl='http://website-bucket-12234.s3-website-us-east-1.amazonaws.com/api.json';

  var gettingdetails=false.obs;

  var headertitle=''.obs;
  var headerimage=''.obs;

  var text=[].obs;
  var images=[].obs;

  // getting details to show in homepage
  homepagedetails()async{
    try{
      headertitle('');headerimage('');text([]);images([]);
      gettingdetails(true);
      var response=await http.get(Uri.parse(baseurl));
      if(response.statusCode==200 && json.decode(response.body)['success']==true){
        headertitle(json.decode(response.body)['data']['title']);
        headerimage(json.decode(response.body)['data']['coverUrl']);
        dynamic len=json.decode(response.body)['data']['components'].length;
        var items=json.decode(response.body)['data']['components'];
        for (var i =0;i<len;i++){
          if(items[i]['type']=='image'){
            images.add(items[i]['url']);
          }else{
            text.add([items[i]['title'],items[i]['desc']]);
          }
        }
      }
      else{
      print("Error from Api-apis.dart main page details function ");
      }
      print('${images.length} ${text.length}');
    }catch(e){
      print("Error from Api-apis.dart details function $e");
      gettingdetails(false);
    }finally{
      gettingdetails(false);
    }
  }

}