import 'package:browser_app/controllers/browser_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home_Page extends StatelessWidget {
  const Home_Page({super.key});

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
      child: SafeArea(
        child: Consumer<Engine_Controller>(
          builder: (context, provider, child) => Scaffold(
            body: Padding(
                padding: EdgeInsetsDirectional.all(16),
                child: GridView.builder(
                  itemCount: 5,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      childAspectRatio: 2 / 3,
                      mainAxisSpacing: 10),
                  itemBuilder: (context, index) => Container(
                    height: 200,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey.shade200,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          Provider.of<Engine_Controller>(context).img[index],
                          width: 100,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(provider.Names[index]),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                  Provider.of<Engine_Controller>(context,
                                          listen: false)
                                      .Pages[index]);
                            },
                            child: Text("Next"))
                      ],
                    ),
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
