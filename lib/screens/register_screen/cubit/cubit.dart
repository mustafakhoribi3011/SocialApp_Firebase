import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/screens/register_screen/cubit/states.dart';
import 'package:social_app/models/user_model/user_model.dart';

class SocialRegisterCubit extends Cubit<SocialRegisterStates>
{
  SocialRegisterCubit() : super(SocialRegisterInitialState());

  static SocialRegisterCubit get(context) =>BlocProvider.of(context);

  void userRegister({
    @required String name,
    @required String email,
    @required String password,
    @required String phone,
  })
  {
    emit(SocialRegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
        email: email,
        password: password,
    ).then((value) {
      userCreate(
          name: name,
          email: email,
          phone: phone,
          uId: value.user.uid
      );
    }).catchError((error){
      emit(SocialRegisterErrorState(error.toString()));
    });
  }

  void userCreate({
    @required String name,
    @required String email,
    @required String phone,
    @required String uId,
  })
  {
    SocialUserModel model = SocialUserModel(
      name: name,
      email: email,
      phone: phone,
      bio: 'Write your bio ...',
      image: 'https://image.freepik.com/free-photo/smiling-happy-black-man-with-little-toy-water-gun-hand_273609-30135.jpg',
      cover:'https://img.freepik.com/free-photo/freedom-traveler-takes-pictures-scenic-nature-view-tries-capture-beautiful-lake-with-mountains-forest-stands-back_273609-26932.jpg?size=338&ext=jpg' ,
      uId: uId,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value) {
          emit(SocialCreateUserSuccessState());
    })
        .catchError((error){
          print(error.toString());
          emit(SocialCreateUserErrorState(error.toString()));
    });
  }
  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility ()
  {
    isPassword = !isPassword;
    suffix = isPassword ?  Icons.visibility_outlined:Icons.visibility_off_outlined ;

    emit(SocialRegisterChangePasswordVisibilityState());
  }


}