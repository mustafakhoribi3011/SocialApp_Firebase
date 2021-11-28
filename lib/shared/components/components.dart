import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_app/models/comment_model/comment_model.dart';
import 'package:social_app/models/post_model/post_model.dart';
import 'package:social_app/shared/styles/icon_broken.dart';
Widget defaultAppBar({@required BuildContext context,
String title,
  List<Widget>actions,
}) => AppBar(
 leading: IconButton(
   onPressed: (){Navigator.pop(context);},
   icon: Icon(IconBroken.Arrow___Left_2),
 ),
  title: Text(title),
  actions: actions,
  titleSpacing: 0.0,
);

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double radius = 3.0,
  @required Function function,
  @required String text,
}) =>
    Container(
      width: width,
      height: 40.0,
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          radius,
        ),
        color: background,
      ),
    );

void showToast({
  @required String text,
  @required ToastStates state,
}) =>
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 16.0,
    );

// enum
enum ToastStates { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastStates state) {
  Color color;

  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}
Widget separatorDivider() => Container(
  height: 0.5,
  color: Colors.grey,
);

Widget myDivider() => SizedBox(
  height: 8.0,
);

Widget  defaultFormField ({
  @required TextEditingController controller,
  @required TextInputType type,
  Function onSubmit,
  Function onChange,
  Function onTap,
  @required Function validate,
  @required String label,
  @required IconData prefix,
  bool isClickable  = true,
  IconData suffix,
  Function suffixPressed,
  bool isPassword = false,

}) => TextFormField(
  obscureText: isPassword,
  onTap:onTap ,
  controller: controller,
  enabled: isClickable,
  keyboardType: type,
  onFieldSubmitted: onSubmit,
  onChanged: onChange,
  validator: validate,
  decoration: InputDecoration(
    labelText: label,
    prefixIcon: Icon(prefix),
    suffixIcon: suffix != null
        ? IconButton(
      onPressed: suffixPressed,
      icon: Icon(
        suffix,
      ),
    )
        : null,
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.amber,
      ),
    ),
  ),
);

Widget defaultTextButton({
  @required Function function,
  @required String text,
}) =>
    TextButton(
      onPressed: function,
      child: Text(
        text.toUpperCase(),
        style: TextStyle(letterSpacing: 0.5,),
      ),
    );

Widget buildCommentItem(PostModel model,CommentModel commentModel,context,index)=> Row(
  children: [
    CircleAvatar(
      radius: 18.0,
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
              Text(
                '${commentModel.text}',
                style: TextStyle(
                    color: Colors.black.withOpacity(0.72),
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                    height: 1.5
                ),
              ),
            ],
          ),
          Text('${commentModel.dateTimeComment}',
            style: TextStyle(
                color: Colors.grey.shade500
            ),
          ),
        ],
      ),
    ),
  ],
);


void navigateTo(context, widget) => Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => widget,
  ),
);

void navigateAndFinish(
    context,
    widget,
    ) =>
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
          (route) {
        return false;
      },
    );