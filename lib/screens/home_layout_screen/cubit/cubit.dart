import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/models/comment_model/comment_model.dart';
import 'package:social_app/models/message_model/message_model.dart';
import 'package:social_app/models/post_model/post_model.dart';
import 'package:social_app/models/user_model/user_model.dart';
import 'package:social_app/screens/chats/chats_screen.dart';
import 'package:social_app/screens/feeds/feeds_screen.dart';
import 'package:social_app/screens/home_layout_screen/cubit/states.dart';
import 'package:social_app/screens/login_screen/login_screen.dart';
import 'package:social_app/screens/profile/settings_screen.dart';
import 'package:social_app/screens/users/users_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SocialCubit  extends Cubit<SocialStates>
{
  SocialCubit() : super(SocialInitialStates());

  static SocialCubit get(context) => BlocProvider.of(context);
  SocialUserModel userModel;
  CommentModel commentModel;

  File profileImage;
  var picker = ImagePicker();

  Future<void> getProfileImage()async
  {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if(pickedFile != null)
    {
      profileImage = File(pickedFile.path);
      emit(SocialProfileImagePickedSuccessState());
    }else
    {
      print('No image selected');
      emit(SocialProfileImagePickedErrorState());
    }
  }

  File coverImage;
  Future<void> getCoverImage()async
  {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if(pickedFile != null)
    {
      coverImage = File(pickedFile.path);
      emit(SocialCoverImagePickedSuccessState());
    }else
    {
      print('No image selected');
      emit(SocialCoverImagePickedErrorState());
    }
  }

  void removePostImage()
  {
    postImage = null;
    emit(SocialRemovePostImageState());
  }

  void uploadProfileImage({
    @required String name,
    @required String phone,
    @required String bio})
  {
    emit(SocialUserUpdateLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage.path).pathSegments.last}')
        .putFile(profileImage)
        .then((value) {
      value.ref.getDownloadURL().then((value)
    {
      print(value);
      updateUser(name: name, phone: phone, bio: bio,image: value);
    }).catchError((error){
      emit(SocialUploadProfileImageErrorState());
    });
    })
      .catchError((error){
        emit(SocialUploadProfileImageErrorState());
    });
  }

  void uploadCoverImage({
    @required String name,
    @required String phone,
    @required String bio})
  {
    emit(SocialUserUpdateLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage.path).pathSegments.last}')
        .putFile(coverImage)
        .then((value)
    {value.ref.getDownloadURL().then((value)
    {
      print(value);
      updateUser(name: name, phone: phone, bio: bio,cover: value);
    }).catchError((error){
      emit(SocialUploadCoverImageErrorState());
    });
    })
        .catchError((error){
      emit(SocialUploadCoverImageErrorState());
    });
  }

  File postImage;
  Future<void> getPostImage()async
  {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if(pickedFile != null)
    {
      postImage = File(pickedFile.path);
      emit(SocialCoverImagePickedSuccessState());
    }else
    {
      print('No image selected');
      emit(SocialCoverImagePickedErrorState());
    }
  }

  void uploadPostImage({
    @required String dateTime,
    @required String text,
  })
  {
    emit(SocialCreatePostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage.path).pathSegments.last}')
        .putFile(postImage)
        .then((value)
    {value.ref.getDownloadURL().then((value)
    {
      print(value);
      createPost(dateTime: dateTime, text: text,postImage: value);
    }).catchError((error){
      emit(SocialCreatePostErrorState());
    });
    })
        .catchError((error){
      emit(SocialCreatePostErrorState());
    });
  }

  void createPost({
    @required String dateTime,
    @required String text,
    String postImage,
  })
  {
    emit(SocialCreatePostLoadingState());
    PostModel model = PostModel(
      name: userModel.name,
      image: userModel.image,
      uId: userModel.uId,
      dateTime: dateTime,
      text: text,
      postImage: postImage ??'',
    );
    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value)
    {
      emit(SocialCreatePostSuccessState());
    })
        .catchError((error)
    {
      print(error.toString());
      emit(SocialCreatePostErrorState());
    });
  }

  void updateUser({
    @required String name,
    @required String phone,
    @required String bio,
    String cover,
    String image,
  })
  {
    SocialUserModel model = SocialUserModel(
      name: name,
      phone: phone,
      bio: bio,
      email: userModel.email,
      cover: cover??userModel.cover,
      image: image??userModel.image,
      uId: userModel.uId,
      isEmailVerified: false,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .update(model.toMap())
        .then((value)
    {
      getUserData();
    })
        .catchError((error)
    {
      print(error.toString());
      emit(SocialUserUpdateErrorState());
    });
  }

  List<PostModel>posts = [];
  List<String>postsId = [];
  List<int>likes = [];
  List<CommentModel>comments= [];

  void getPosts()
  {
    FirebaseFirestore.instance
        .collection('posts')
        .get()
        .then((value1) async{
          for(int index = 0 ; index < value1.docs.length; index ++){
           await value1.docs[index].reference
                .collection('likes')
                .get()
                .then((value) {
              likes.add(value.docs.length);
              postsId.add(value1.docs[index].id);
              posts.add(PostModel.fromJson(value1.docs[index].data()));
            })
                .catchError((error){});
          }
          emit(SocialGetPostsSuccessState());
    })
        .catchError((error)
    {
      emit(SocialGetPostsErrorState(error.toString()));
    });
  }

  void getUserData()
  {
    emit(SocialGetUserLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((value) {
      print(value.data());
      userModel = SocialUserModel.fromJson(value.data());
      emit(SocialGetUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialGetUserErrorState(error.toString()));
    });
  }

  void postsLikes(int index,String postId)
  {
    int noLikes = likes[index];
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel.uId)
    .get()
    .then((value) async{
      if(value.exists)
      {
      await value.reference.delete();
      likes[index]=noLikes-1;
        emit(SocialPostLikesSuccessState());
      }else
        {
          FirebaseFirestore.instance
              .collection('posts')
              .doc(postId)
              .collection('likes')
              .doc(userModel.uId)
              .set({'like':true})
              .then((value) {
            likes[index]=noLikes+1;
            emit(SocialPostLikesSuccessState());
          })
              .catchError((error){
            emit(SocialPostLikesErrorState());
          });
        }
    });
  }

  void postsComments(
      int index,String postId,
      {
        @required String text,
        @required String dateTimeComment
      })
  {
    CommentModel commentModel = CommentModel(
      name: userModel.name,
      uId: userModel.uId,
      image: userModel.image,
      text: text,
      dateTimeComment: dateTimeComment,
    );
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add(commentModel.toMap())
        .then((value) {
          emit(SocialPostCommentsSuccessState());
    })
        .catchError((error){
          emit(SocialPostCommentsErrorState());
    });
  }
  void getComments(String postId,int index)
  {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('dateTimeComment',descending: true)
        .snapshots()
        .listen((event) {
      comments = [];
      event.docs.forEach((element)
      {
        comments.add(CommentModel.fromJson(element.data()));
      });
      emit( SocialPostGetCommentsSuccessState());
    });
    //     .get()
    //     .then((value) {
    //        value.docs.forEach((element) {
    //           comments.add(CommentModel.fromJson(element.data()));
    //           print(element.data());
    //           print(postId.toString());
    //       });
    //       emit( SocialPostGetCommentsSuccessState());
    //       print(comments.length.toString());
    // })
    //     .catchError((error){
    //       emit( SocialPostGetCommentsErrorState());
    // });
  }

  List<SocialUserModel> users = [];

  void getUsers()
  {
    if(users.length == 0)
    FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((value) {
      value.docs.forEach((element)
      {
        if(element.data()['uId'] != userModel.uId)
        users.add(SocialUserModel.fromJson(element.data()));
      });
      emit(SocialGetAllUsersSuccessState());
    })
        .catchError((error)
    {
      emit(SocialGetAllUsersErrorState(error.toString()));
    });
  }

  void sendMessage({
    @required String receiverId,
    @required String dateTime,
    @required String text,
})
  {
    MessageModel model = MessageModel(
      senderId: userModel.uId,
      receiverId: receiverId,
      dateTime: dateTime,
      text: text,
    );
    FirebaseFirestore.instance
    .collection('users')
    .doc(userModel.uId)
    .collection('chats')
    .doc(receiverId)
    .collection('messages')
    .add(model.toMap())
    .then((value) {
      emit(SocialSendMessageSuccessState());
    })
    .catchError((error){
      emit(SocialSendMessageErrorState());
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel.uId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    })
        .catchError((error){
      emit(SocialSendMessageErrorState());
    });
  }

  List<MessageModel> messages = [];

  void getMessages({
    @required String receiverId,
})
  {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
          messages = [];
          event.docs.forEach((element)
          {
            messages.add(MessageModel.fromJson(element.data()));
          });
          emit(SocialGetMessageSuccessState());
    });
  }

  int currentIndex = 0;

  List<Widget>screens = [
    FeedsScreen(),
    ChatsScreen(),
    UsersScreen(),
    ProfileScreen(),
  ];

  List<String>titles =[
    'Home',
    'Chats',
    'Users',
    'Profile',
  ];

  void changeBottomNav(int index)
  {
    if (index == 1)
      getUsers();
    currentIndex = index;
    emit(SocialChangeBottomNavState());
  }

  void logout (context) async
  {
    await FirebaseAuth.instance.signOut();
    navigateTo(context, LoginScreen());
    emit(SocialLogoutState());
  }
  }