import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/screens/home_layout_screen/cubit/cubit.dart';
import 'package:social_app/screens/home_layout_screen/cubit/states.dart';
import 'package:social_app/screens/login_screen/login_screen.dart';
import 'package:social_app/screens/new_post/new_post.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class HomeLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SocialCubit()..getUserData()..getPosts(),
      child: BlocConsumer<SocialCubit,SocialStates>(
          listener: (context,state){},
          builder: (context,state){
            var cubit = SocialCubit.get(context);
            return  Scaffold(
              appBar: AppBar(
                title:Text( cubit.titles[cubit.currentIndex],),
                actions: [
                  IconButton(icon: Icon(IconBroken.Notification),
                      onPressed: (){}),
                  IconButton(icon: Icon(IconBroken.Search),
                      onPressed: (){}),
                  if(cubit.currentIndex==3)
                    IconButton(icon: Icon(IconBroken.Logout),
                        onPressed: () {
                          SocialCubit.get(context).logout(context);
                          navigateTo(context, LoginScreen());
                        }
                    ),
                ],
              ),
              body: cubit.screens[cubit.currentIndex],
              floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
              floatingActionButton: FloatingActionButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>NewPostScreen()));
                },
                tooltip: 'Increment',
                backgroundColor: Colors.blue,
                child: Icon(IconBroken.Paper_Plus,color: Colors.white,),
                elevation: 2.5,
              ),
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: cubit.currentIndex,
                onTap: (index){
                  cubit.changeBottomNav(index);
                },
                items:
                [
                  BottomNavigationBarItem(
                    icon: Icon(IconBroken.Home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(IconBroken.Chat),
                    label: 'Chats',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(IconBroken.Location),
                    label: 'Users',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(IconBroken.Profile),
                    label: 'Profile',
                  ),
                ],
              ),

            );
          },
        ),
    );
  }
}
