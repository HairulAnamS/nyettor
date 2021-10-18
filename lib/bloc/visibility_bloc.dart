import 'package:bloc/bloc.dart';

enum VisibilityEvent { to_show, to_hide }

class VisibilityBloc extends Bloc<VisibilityEvent, bool> {
  bool _isShow = false;
  VisibilityBloc(bool initialState) : super(initialState);

  @override
  Stream<bool> mapEventToState(VisibilityEvent event) async* {
    _isShow = (event == VisibilityEvent.to_show) ? true : false;
    print(_isShow);
    yield _isShow;
  }

}
