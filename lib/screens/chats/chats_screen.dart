import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/user_model/user_model.dart';
import 'package:social_app/screens/chat_details/chat_details_screen.dart';
import 'package:social_app/screens/home_layout_screen/cubit/cubit.dart';
import 'package:social_app/screens/home_layout_screen/cubit/states.dart';
import 'package:social_app/shared/components/components.dart';

class ChatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<SocialCubit,SocialStates>(
      listener: (context,state){},
      builder: (context,state)
      {
        return ConditionalBuilder(
          condition: SocialCubit.get(context).users.length >0,
          builder: (context) =>ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder:(context,index) => buildChatItem( SocialCubit.get(context).users[index],context) ,
            separatorBuilder: (context,index) => separatorDivider(),
            itemCount: SocialCubit.get(context).users.length,
          ),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
  Widget buildChatItem(SocialUserModel model,context) => InkWell(
    onTap: ()
    {
      navigateTo(context, ChatDetailsScreen(
        userModel: model,
      ));
    },
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25.0,
            backgroundImage: NetworkImage(
              '${model.image}'
          ),
          ),
          SizedBox(width: 15.0,),
          Text(
            '${model.name}',
            style: TextStyle(
                fontFamily: 'Jannah',
                fontSize: 16,
                height: 1.5
            ),
          ),
        ],
      ),
    ),
  );
}
