import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/screens/home_layout_screen/cubit/cubit.dart';
import 'package:social_app/screens/home_layout_screen/cubit/states.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class EditProfileScreen extends StatelessWidget
{
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var bioController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (context,state){},
      builder: (context,state){
        var userModel = SocialCubit.get(context).userModel;
        var profileImage = SocialCubit.get(context).profileImage;
        var coverImage = SocialCubit.get(context).coverImage;

        nameController.text = userModel.name;
        phoneController.text = userModel.phone;
        bioController.text = userModel.bio;


        return Scaffold(
          appBar: defaultAppBar(
              context: context,
              title: 'Edit Profile',
              actions:
              [
                defaultTextButton(
                  function: ()
                  {
                    SocialCubit.get(context).updateUser(name: nameController.text, phone: phoneController.text, bio: bioController.text);
                  },
                  text: 'Update',),
                SizedBox(width: 15.0,),
              ]
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                children: [
                  if(state is SocialUserUpdateLoadingState)
                  LinearProgressIndicator(),
                  if(state is SocialUserUpdateLoadingState)
                    SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    height: 265,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topCenter,
                          child: Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              Container(
                                height: 200,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4.0),
                                    topRight: Radius.circular(4.0),
                                  ),
                                  image: DecorationImage(
                                    image: coverImage ==null ?NetworkImage('${userModel.cover}'):FileImage(coverImage),
                                    fit: BoxFit.cover,
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
                                            IconBroken.Camera,
                                            color: Colors.black,
                                            size: 17.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onPressed: ()
                                  {
                                    SocialCubit.get(context).getCoverImage();
                                  }
                              ),
                            ],
                          ),
                        ),
                        CircleAvatar(
                          radius: 75.0,
                          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 70.0,
                                backgroundImage: profileImage == null ? NetworkImage(
                                    '${userModel.image}'): FileImage(profileImage),
                              ),
                              Positioned.directional(
                                textDirection: Directionality.of(context),
                                end: 0,
                                bottom: 0,
                                child: IconButton(
                                    icon: CircleAvatar(
                                      radius: 20.0,
                                      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                      child: Stack(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: Colors.grey.withOpacity(0.6),
                                            radius: 14,
                                            child: Icon(
                                              IconBroken.Camera,
                                              size: 17.0,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onPressed: ()
                                    {
                                      SocialCubit.get(context).getProfileImage();
                                    }
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if(SocialCubit.get(context).profileImage != null || coverImage != null)
                    SizedBox(
                    height: 10.0,
                  ),
                  if(SocialCubit.get(context).profileImage != null ||SocialCubit.get(context).coverImage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Row(
                      children: [
                        if(SocialCubit.get(context).profileImage != null)
                        Expanded(
                          child: Column(
                          children: [
                            defaultButton(
                                function: ()
                                {
                                  SocialCubit.get(context).
                                  uploadProfileImage(
                                      name: nameController.text,
                                      phone: phoneController.text,
                                      bio: bioController.text);
                                },
                                text: 'Upload profile'),
                            if(state is SocialUserUpdateLoadingState)
                              SizedBox(height: 5.0,),
                            if(state is SocialUserUpdateLoadingState)
                            LinearProgressIndicator(),
                          ],
                        ),
                        ),
                        SizedBox(width: 5.0,),
                        if(SocialCubit.get(context).coverImage != null)
                        Expanded(
                          child: Column(
                          children: [
                            defaultButton(
                                function: ()
                                {
                                  SocialCubit.get(context).
                                  uploadCoverImage(
                                      name: nameController.text,
                                      phone: phoneController.text,
                                      bio: bioController.text);
                                },
                                text: 'Upload cover'),
                            if(state is SocialUserUpdateLoadingState)
                              SizedBox(height: 5.0,),
                            if(state is SocialUserUpdateLoadingState)
                              LinearProgressIndicator(),
                          ],
                        ),
                        ),
                      ],
                    ),
                  ),
                    SizedBox(height: 20.0,),
                  defaultFormField(controller: nameController, type: TextInputType.name, validate: (String value){if(value.isEmpty){return 'Name must not be empty';}return null;}, label: 'Name', prefix: IconBroken.Profile,),
                  SizedBox(height: 12.0,),
                  defaultFormField(controller: bioController, type: TextInputType.text, validate: (String value){if(value.isEmpty){return 'Bio must not be empty';}return null;}, label: 'Bio', prefix: IconBroken.Info_Circle,),
                  SizedBox(height: 12.0,),
                  defaultFormField(controller: phoneController, type: TextInputType.phone, validate: (String value){if(value.isEmpty){return 'Phone must not be empty';}return null;}, label: 'Phone', prefix: IconBroken.Call,),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
