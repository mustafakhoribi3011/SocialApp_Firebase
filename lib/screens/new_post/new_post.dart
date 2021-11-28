import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/screens/home_layout_screen/cubit/cubit.dart';
import 'package:social_app/screens/home_layout_screen/cubit/states.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class NewPostScreen extends StatelessWidget {
  var textController = TextEditingController();
  var now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (context,state){},
      builder: (context,state){
        return Scaffold(
          appBar: defaultAppBar(
              context: context,
              title: 'Create Post',
              actions: [
                defaultTextButton(
                    function: ()
                    {
                      if(SocialCubit.get(context).postImage==null)
                      {
                        SocialCubit.get(context).createPost(dateTime:now.toString(), text: textController.text);
                      }else
                        {
                          SocialCubit.get(context).uploadPostImage(dateTime: now.toString(), text: textController.text);
                        }
                    },
                    text: 'Post'),
              ]
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                if(state is SocialCreatePostLoadingState)
                LinearProgressIndicator(),
                if(state is SocialCreatePostLoadingState)
                  SizedBox(height: 10.0,),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25.0,
                      backgroundImage: NetworkImage(
                      '${SocialCubit.get(context).userModel.image}'
                      ),
                    ),
                    SizedBox(width: 10.0,),
                    Expanded(child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${SocialCubit.get(context).userModel.name}',
                              style: TextStyle(
                                  fontFamily: 'Jannah',
                                  fontSize: 16,
                                  height: 1.5
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                    ),
                  ],
                ),
                Expanded(
                  child: TextFormField(
                    controller: textController,
                    decoration: InputDecoration(
                        hintText: 'what is on your mind ...',
                      hintStyle: TextStyle(fontSize: 15),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 20.0,),
                if(SocialCubit.get(context).postImage!= null)
                Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        image: DecorationImage(
                          image:FileImage(SocialCubit.get(context).postImage),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    IconButton(
                        icon: CircleAvatar(
                          radius: 20.0,
                          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                          child: Stack(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.grey.withOpacity(0.6),
                                radius: 14.0,
                                child: Icon(
                                 Icons.close,
                                  color: Colors.black,
                                  size: 17.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onPressed: ()
                        {
                          SocialCubit.get(context).removePostImage();
                        }
                    ),
                  ],
                ),
                SizedBox(height: 20.0,),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: ()
                        {
                          SocialCubit.get(context).getPostImage();
                        },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                IconBroken.Image,
                              ),
                              SizedBox(width: 5.0,),
                              Text('add photo'),
                            ],
                          ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(onPressed: (){},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('# tags'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],

            ),
          ),
        );
      },
    );
  }
}
