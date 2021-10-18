import 'package:bloc/bloc.dart';

enum TabEvent {to_history, to_grafik}

class TabBloc extends Bloc<TabEvent, int>{
  int _idx = 0;
  TabBloc(int initialState) : super(initialState);

  @override
  Stream<int> mapEventToState(TabEvent event) async* {
    if(event == TabEvent.to_grafik) _idx = 1;
    else _idx = 0;

    print(_idx);
    yield _idx;  
  }

}