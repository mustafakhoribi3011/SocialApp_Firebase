import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/screens/edit_profile/edit_profile.dart';
import 'package:social_app/screens/home_layout_screen/cubit/cubit.dart';
import 'package:social_app/screens/home_layout_screen/cubit/states.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class ProfileScreen extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (context,state){},
      builder: (context,state)
      {
        var userDataModel = SocialCubit.get(context).userModel;
        return  Padding(
          padding: const EdgeInsets.all(6.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 265,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      Align(
                        alignment: AlignmentDirectional.topCenter,
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4.0),
                              topRight: Radius.circular(4.0),
                            ),
                            image: DecorationImage(
                              image: NetworkImage('${userDataModel.cover}'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      CircleAvatar(
                        radius: 75.0,
                        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                        child: CircleAvatar(
                          radius: 70.0,
                          backgroundImage: NetworkImage('${userDataModel.image}'),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5.0,),
                Text('${userDataModel.name}',
                  style: TextStyle(
                      fontSize: 18
                  ),
                ),
                Text('${userDataModel.bio}',
                    style: Theme.of(context).textTheme.caption
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: (){},
                          child: Column(
                            children: [
                              Text('100',
                                  style: Theme.of(context).textTheme.subtitle2
                              ),
                              Text('Posts',
                                  style: Theme.of(context).textTheme.caption.copyWith(fontSize: 13)
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: (){},
                          child: Column(
                            children: [
                              Text('235',
                                  style: Theme.of(context).textTheme.subtitle2
                              ),
                              Text('Photos',
                                  style: Theme.of(context).textTheme.caption.copyWith(fontSize: 13)
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: (){},
                          child: Column(
                            children: [
                              Text('10k',
                                  style: Theme.of(context).textTheme.subtitle2
                              ),
                              Text('Followers',
                                  style: Theme.of(context).textTheme.caption.copyWith(fontSize: 13)
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: (){},
                          child: Column(
                            children: [
                              Text('64',
                                  style: Theme.of(context).textTheme.subtitle2
                              ),
                              Text('Followings',
                                  style: Theme.of(context).textTheme.caption.copyWith(fontSize: 13)
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(child: OutlinedButton(onPressed: (){}, child:Text('Add Photos'),)),
                    SizedBox(width: 10,),
                    OutlinedButton(onPressed: (){
                      navigateTo(context, EditProfileScreen());
                    }, child:Icon(IconBroken.Edit,size: 18,),),
                  ],
                ),
                SizedBox(height: 100,),
              ],
            ),
          ),
        );
      },
    );
  }
}
