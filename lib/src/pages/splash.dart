import 'package:raidlayer_practical/src/bloc/bloc.dart';
import 'package:raidlayer_practical/src/network/network_request.dart';
import 'package:raidlayer_practical/src/pages/home_page.dart';
import 'package:flutter/material.dart';

extension _ColorExtension on String {
  toColor() {
    var hexColor = this.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
}

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  NetworkRequest request;
  VerificationBloc bloc;
  @override
  void initState() {
    request = NetworkRequest();
    bloc = VerificationBloc(request);
    super.initState();
  }

  Future<void> init() async {
    await Future.delayed(const Duration(seconds: 1));
    await bloc.verifyUser();
    if (bloc.isLoading.value == LoadingState.LOADED_SUCESS) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                    color: bloc.backgroundNetworkColor.toColor(),
                  )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Object>(
          future: init(),
          builder: (context, snapshot) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 100, bottom: 80),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      minRadius: 50,
                      backgroundColor: Colors.grey[200],
                      child: FlutterLogo(
                        size: 50,
                      ),
                    ),
                    StreamBuilder<LoadingState>(
                        stream: bloc.isLoading,
                        builder: (context, snapshot) {
                          if (snapshot.data == LoadingState.LOADING)
                            return CircularProgressIndicator();
                          if (snapshot.hasError)
                            return Column(
                              children: [
                                IconButton(
                                    icon: Icon(Icons.refresh),
                                    onPressed: () {
                                      init();
                                    }),
                                Text(snapshot.error.toString()),
                              ],
                            );
                          return SizedBox();
                        })
                  ],
                ),
              ),
            );
          }),
    );
  }
}
