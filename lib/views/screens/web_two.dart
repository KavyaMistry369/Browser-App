import 'package:browser_app/controllers/browser_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';

class Two extends StatefulWidget {
  const Two({super.key});

  @override
  State<Two> createState() => _TwoState();
}


class _TwoState extends State<Two> {

  PullToRefreshController? refresh_controller;
  InAppWebViewController? web_controller;

  bool back=false;
  bool forward=false;
  int progress=0;

  @override

  void initState() {
    // TODO: implement initState
    super.initState();

    refresh_controller =PullToRefreshController(
        onRefresh: (){
          web_controller!.reload();
        }
    );

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool WillPop = await Provider.of<Engine_Controller>(context,listen: false)
            .web_controller!
            .canGoBack();

        if (WillPop) {
          Provider.of<Engine_Controller>(context,listen: false).web_controller!.goBack();
        }
        return WillPop;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: (){
            Navigator.of(context).pop();
          }, icon: Icon(Icons.arrow_back)),

          title: Text("Bing"),
          actions: [
            IconButton(onPressed: (){}, icon: Icon(Icons.refresh)),
            Visibility(
              visible: Provider.of<Engine_Controller>(context,listen: false).CanBack,
              child: IconButton(onPressed: (){
                Provider.of<Engine_Controller>(context,listen: false).back();
              }, icon: Icon(Icons.arrow_back_ios)),
            ),
            IconButton(onPressed: (){
              Provider.of<Engine_Controller>(context,listen:false).forward();
            }, icon: Icon(Icons.arrow_forward_ios_rounded)),
            IconButton(onPressed: (){showModalBottomSheet(context: context,builder:(context) => Container(
              height: 500,
              width: 400,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                  color: Colors.grey.shade200
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      initialValue: Provider.of<Engine_Controller>(context).SearchData,
                      validator: (val){
                        if(val!.isEmpty)
                        {
                          return "Search";
                        }
                        else
                        {
                          return "";
                        }
                      },
                      onSaved: (val){
                        Provider.of<Engine_Controller>(context).SearchData!=val;
                      },
                      decoration: InputDecoration(
                        hintText: "Search",
                        suffixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                      ),
                    ),
                  ),
                ],
              ),
            ),);
            }, icon: Icon(Icons.search_outlined),),
          ],
        ),
        body: Center(
          child: Container(
            child: InAppWebView(
              initialUrlRequest: URLRequest(url: Uri.parse(Provider.of<Engine_Controller>(context).Bing)),
              onWebViewCreated: (controller){
                Provider.of<Engine_Controller>(context).Init(controller: controller);
              },
              onLoadStart: (controller,url)async{
                back=await web_controller!.canGoBack();
                setState(() {});
              },

              onLoadStop: (controller,url)async{
                back=await web_controller!.canGoBack();
                setState(() {
                  refresh_controller!.endRefreshing();
                });
              },

              onProgressChanged: (controller,progress){
                setState(() {
                  this.progress=progress;
                });
                if(progress==100)
                {
                  refresh_controller!.endRefreshing();
                }
              },

            ),
          ),
        ),
      ),
    );
  }
}
