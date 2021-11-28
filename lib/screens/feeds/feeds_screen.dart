
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:social_app/models/comment_model/comment_model.dart';
import 'package:social_app/models/post_model/post_model.dart';
import 'package:social_app/models/user_model/user_model.dart';
import 'package:social_app/screens/home_layout_screen/cubit/cubit.dart';
import 'package:social_app/screens/home_layout_screen/cubit/states.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class FeedsScreen extends StatelessWidget {
  SocialUserModel userModel;
  CommentModel commentModel;
  FeedsScreen({
    this.userModel,
    this.commentModel,
  });

  var commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (context,state){},
      builder: (context,state){
        return ConditionalBuilder(
          condition:SocialCubit.get(context).posts.length >0,
          builder: (context) =>SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children:
              [
                Card(
                  elevation: 5.0,
                  margin: EdgeInsets.all(8.0),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      Image(
                        image: NetworkImage(
                            'https://image.freepik.com/free-photo/horizontal-shot-smiling-curly-haired-woman-indicates-free-space-demonstrates-place-your-advertisement-attracts-attention-sale-wears-green-turtleneck-isolated-vibrant-pink-wall_273609-42770.jpg'),
                        fit: BoxFit.cover,
                        height: 250,
                        width: double.infinity,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text('Communicate with friends',
                          style: TextStyle(
                              fontFamily: 'Jannah',
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.separated(
                  itemBuilder: (context, index) => buildPostItem(SocialCubit.get(context).posts[index],context,index),
                  itemCount: SocialCubit.get(context).posts.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) => myDivider(),
                ),
                SizedBox(
                  height: 8.0,
                ),
              ],
            ),
          ),
          fallback: (context) =>Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
  Widget buildPostItem(PostModel model,context,index) => Card(
        elevation: 5.0,
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 25.0,
                    backgroundImage: NetworkImage(
                        '${model.image}'),
                  ),
                  SizedBox(width: 15.0,),
                  Expanded(
                    flex: 8,
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${model.name}',
                            style: TextStyle(
                                fontFamily: 'Jannah',
                                fontSize: 16,
                                height: 1.5
                            ),
                          ),
                          SizedBox(width: 5,),
                          Icon(Icons.check_circle,
                            color: Colors.blue,
                            size: 17,
                          ),
                        ],
                      ),
                      Text('${model.dateTime}',
                        style: Theme
                            .of(context)
                            .textTheme
                            .caption
                            .copyWith(height: 1.5),
                      ),
                    ],
                  ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(icon: Icon(Icons.more_horiz, size: 19,),
                        onPressed: () {}),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.grey[300],
                ),
              ),
              Text(
                '${model.text}',
                style: TextStyle(
                  fontFamily: 'Jannah',
                  fontSize: 15,
                ),
              ),
              if(model.postImage != '')
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    image: DecorationImage(
                      image: NetworkImage(
                          '${model.postImage}',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        child: Row(
                          children: [
                            Icon(
                              IconBroken.Heart,
                              size: 19.0,
                              color: Colors.red,
                            ),
                            SizedBox(width: 5.0,),
                            Text('${SocialCubit.get(context).likes[index]}',
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .caption
                                  .copyWith(fontSize: 14),
                            ),
                          ],
                        ),
                        onTap: ()
                        {
                        },
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              IconBroken.Chat,
                              size: 19.0,
                              color: Colors.amber,
                            ),
                            SizedBox(width: 5.0,),
                            Text('0 comment',
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .caption
                                  .copyWith(fontSize: 14),
                            ),
                          ],
                        ),
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.grey[300],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 18.0,
                              backgroundImage: NetworkImage(
                                '${SocialCubit.get(context).userModel.image}'
                              ),
                            ),
                            SizedBox(width: 10.0,),
                            Text('Write a comment ...',
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .caption
                                  .copyWith(fontSize: 13),
                            ),
                          ],
                        ),
                        onTap: ()
                        {
                            showModalBottomSheet(
                        context: context,
                          builder: (context) {
                          SocialCubit.get(context).getComments(SocialCubit.get(context).postsId[index], index);
                            return  GestureDetector(
                              child: Container(
                                height: 600,
                                color: Colors.white,
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children:
                                    [
                                      ListView.separated(
                                        itemBuilder: (context,index) => buildCommentItem(model,SocialCubit.get(context).comments[index],context,index),
                                        separatorBuilder: (context,index) => myDivider(),
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: SocialCubit.get(context).comments.length,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 18.0,
                                              backgroundImage: NetworkImage(
                                                  '${SocialCubit.get(context).userModel.image}'
                                              ),
                                            ),
                                            SizedBox(width: 10.0,),
                                            Expanded(
                                              child: Container(
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.grey[300],
                                                      width: 1.0
                                                  ),
                                                  borderRadius: BorderRadius.circular(15.0),
                                                ),
                                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                                        child: TextFormField(
                                                          controller: commentController,
                                                          decoration: InputDecoration(
                                                            border: InputBorder.none,
                                                            hintText: 'write a comment ... ',
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 50.0,
                                                      color: Colors.blue,
                                                      child: MaterialButton(
                                                        minWidth: 1.0,
                                                        onPressed: ()
                                                        {
                                                          var now = DateTime.now();
                                                          SocialCubit.get(context).postsComments(index, SocialCubit.get(context).postsId[index], text: commentController.text, dateTimeComment:now.toString() );
                                                        },
                                                        child: Icon(
                                                          IconBroken.Send,
                                                          color: Colors.white,
                                                          size: 16.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              onTap: ()
                              {
                                Navigator.of(context).pop();
                              },
                            );
                        });
                        },
                      ),
                    ),
                    InkWell(
                      child: Row(
                        children: [
                          Icon(
                            IconBroken.Heart,
                            size: 19.0,
                            color: Colors.red,
                          ),
                          SizedBox(width: 5.0,),
                          Text('Like',
                            style: Theme
                                .of(context)
                                .textTheme
                                .caption
                                .copyWith(fontSize: 14),
                          ),
                        ],
                      ),
                      onTap: ()
                      {
                        SocialCubit.get(context).postsLikes(index,SocialCubit.get(context).postsId[index]);
                      },
                    ),
                    SizedBox(width: 15,),
                    InkWell(
                      child: Row(
                        children: [
                          Icon(
                            IconBroken.Upload,
                            size: 19.0,
                            color: Colors.green,
                          ),
                          SizedBox(width: 5.0,),
                          Text('Share',
                            style: Theme
                                .of(context)
                                .textTheme
                                .caption
                                .copyWith(fontSize: 14),
                          ),
                        ],
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

}
