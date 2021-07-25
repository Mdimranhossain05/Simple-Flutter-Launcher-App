
import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: PageView(
          children: [
            Container(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 180,),
                    Image.asset("images/homepage.png",),
                    SizedBox(height: 20,),
                    Text("HomePage",style: TextStyle(color: Colors.white),)
                  ],
                )
              ),
            ),
            FutureBuilder(
                future: DeviceApps.getInstalledApplications(
                  includeSystemApps: true,
                  onlyAppsWithLaunchIntent: true,
                  includeAppIcons: true,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    List<Application> allApps = snapshot.data as List<Application>;
                    return GridView.count(
                      physics: BouncingScrollPhysics(),
                      crossAxisCount: 3,
                      padding: EdgeInsets.only(top: 60),
                      children: List.generate(allApps.length, (index) {
                        return GestureDetector(
                          onTap: (){
                            DeviceApps.openApp(allApps[index].packageName);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Image.memory(
                                  (allApps[index] as ApplicationWithIcon).icon,
                                  width: 32,
                                ),
                                SizedBox(height: 15,),
                                Text(
                                  "${allApps[index].appName}", style: TextStyle(color: Colors.white),
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                    );
                  }
                  return Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
