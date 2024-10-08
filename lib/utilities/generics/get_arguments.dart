import 'package:flutter/widgets.dart';

extension GetArgument on BuildContext{
  T? getArgument<T>(){
    final modalRoute = ModalRoute.of(this); // this - here refers to current build context
    if(modalRoute != null){
       final args = modalRoute.settings.arguments;
       if(args!=null && args is T){
        return args as T;
       }
    }
    return null;
  }
}