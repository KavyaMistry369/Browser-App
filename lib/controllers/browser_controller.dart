import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class Engine_Controller extends ChangeNotifier{

  InAppWebViewController? web_controller;

  bool CanBack=false;
  bool CanForward=false;
  String? SearchData;
  String chrome="https://www.google.com/";
  String Bing="https://www.bing.com/";
  String Duck="https://duckduckgo.com/";
  String Brave="https://search.brave.com/";
  String Yahoo="https://in.search.yahoo.com/?fr2=inr";
  PullToRefreshController? refreshController;

  List<String>img=[
    "lib/views/assets/1.png",
    "lib/views/assets/2.png",
    "lib/views/assets/3.png",
    "lib/views/assets/4.png",
    "lib/views/assets/5.png",
  ];

  List<String>Names=[
    "Chrome",
    "Bing",
    "Duck Duck Go",
    "Brave",
    "Yahoo",
  ];

  List<String>Pages=[
    "One",
    "Two",
    "Three",
    "Four",
    "Five",
  ];

  Fetch({required Search}){
    this.SearchData=Search;
    notifyListeners();
  }



  Init({required InAppWebViewController controller}){
    this.web_controller=controller;
    refreshController =PullToRefreshController(
      onRefresh: (){
        web_controller!.reload();
        notifyListeners();
      },
      options: PullToRefreshOptions(
        enabled: true,
    ),
    );
    notifyListeners();
  }

  back(){
    web_controller!.goBack();
    notifyListeners();
  }

  forward(){
    web_controller!.goForward();
    notifyListeners();
  }

  Web()async{
    CanBack=await web_controller!.canGoBack();
    CanForward=await web_controller!.canGoForward();
    notifyListeners();
  }

}