import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/screens/home_layout_screen/cubit/cubit.dart';
import 'package:social_app/screens/home_layout_screen/cubit/states.dart';
import 'package:social_app/screens/home_layout_screen/home_layout_screen.dart';
import 'package:social_app/screens/login_screen/login_screen.dart';
import 'package:social_app/bloc_observer.dart';
import 'package:social_app/screens/register_screen/register_screen.dart';
import 'package:social_app/shared/constants/constants.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
void main() async{
  SystemUiOverlayStyle(
    statusBarColor: Colors.yellow,
  );
  Widget widget;
  Bloc.observer = MyBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();
  uId = CacheHelper.getData(key: 'uId');
  if(uId != null ){
    widget = HomeLayout();
  }else
  {
    widget = LoginScreen();
  }
  runApp(MyApp(
    startWidget: widget,
  ));
}
class MyApp extends StatelessWidget {
  final Widget startWidget;
  const MyApp({Key key, this.startWidget}) : super(key: key);
  @override
  Widget build(BuildContext context) {
        return  BlocProvider(
          create: (BuildContext context) => SocialCubit()..getUserData()..getPosts(),
          child: BlocConsumer<SocialCubit,SocialStates>(
            listener: (context,state){},
            builder: (context,state)
            {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Flutter Demo',
                theme: ThemeData(
                  bottomNavigationBarTheme: BottomNavigationBarThemeData(
                      backgroundColor: Colors.white
                  ),
                  scaffoldBackgroundColor: Colors.white,
                  fontFamily: 'Jannah',
                  primarySwatch: Colors.blue,
                  appBarTheme: AppBarTheme(
                    iconTheme: IconThemeData(
                        color: Colors.black
                    ),
                    elevation: 0,
                    titleTextStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Jannah'
                    ),
                    backwardsCompatibility: false,
                    systemOverlayStyle: SystemUiOverlayStyle(
                        statusBarColor: Colors.transparent,
                        statusBarIconBrightness: Brightness.dark
                    ),
                    backgroundColor: Colors.white,
                  ),
                ),
                darkTheme: ThemeData(
                  appBarTheme: AppBarTheme(
                    color: Colors.black54,
                  ),
                  cardColor: Colors.black54,
                ),
                home: startWidget,
              );
            },
          ),
        );
      }
  }
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
