import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(DisplaySplash()) ;
  void appStarted() async {
    await Future.delayed(const Duration(seconds:2));
    emit(
      Unauthenticated()
    );
}
}