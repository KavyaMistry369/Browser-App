import 'package:browser_app/controllers/browser_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';

GlobalKey<FormState>FormKey=GlobalKey<FormState>();

PullToRefreshController? refresh_controller;
InAppWebViewController? web_controller;

bool back=false;
bool forward=false;
String? SearchData;

class One extends StatefulWidget {
 One({super.key});

  @override
  State<One> createState() => _OneState();
}

class _OneState extends State<One> {

  @override

  int progress=0;

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
      child: Consumer<Engine_Controller>(
        builder: (context,provider,_) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(onPressed: (){
                Navigator.of(context).pop();
              }, icon: Icon(Icons.arrow_back)),
              title: Text("Chrome"),
              actions: [
               IconButton(onPressed: (){
                 web_controller!.reload();
               }, icon: Icon(Icons.refresh)),
               Visibility(
                 visible: Provider.of<Engine_Controller>(context,listen: false).CanBack,
                 child: IconButton(onPressed: (){
                  web_controller!.canGoBack();
                 }, icon: Icon(Icons.arrow_back_ios)),
               ),
               IconButton(onPressed: (){
                  web_controller!.canGoForward();
               }, icon: Icon(Icons.arrow_forward_ios_rounded)),
               IconButton(onPressed: (){showModalBottomSheet(context: context,builder:(context) => Container(
                    height: 500,
                    width: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                      color: Colors.grey.shade200
                    ),
                    child: Form(
                      key: FormKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                initialValue:SearchData,
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
                                  SearchData!=val;
                                },
                                decoration: InputDecoration(
                                  hintText: "Search",
                                  suffixIcon: Icon(Icons.search),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                                ),
                              ),
                            ),
                            ElevatedButton(onPressed: (){
                              if(FormKey.currentState!.validate())
                                {
                                  FormKey.currentState!.save();
                                  provider.Fetch(Search: SearchData);
                                  print("$SearchData");
                                }
                            }, child: Text("Search"))
                          ],
                        ),
                      ),
                    ),
                  ),);
                }, icon: Icon(Icons.search_outlined),),
              ],
            ),
            body: Center(
              child: Container(
                child: InAppWebView(
                  initialUrlRequest: URLRequest(url: Uri.parse(provider.chrome)),
                  onWebViewCreated: (controller){
                    Provider.of<Engine_Controller>(context,listen: false).Init(controller: controller);
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
          );
        }
      ),
    );
  }
}
