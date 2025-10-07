// business_selection_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:gold_house/core/constants/app_imports.dart';

// Events
abstract class BusinessSelectionEvent {}

class SelectBusinessEvent extends BusinessSelectionEvent {
  final String selectedBusiness;
  final int selectedIndex;

  SelectBusinessEvent(this.selectedBusiness, this.selectedIndex);
}

// States
abstract class BusinessSelectionState {}

class BusinessSelectionInitial extends BusinessSelectionState {}

class BusinessSelectedState extends BusinessSelectionState {
  final String selectedBusiness;
  final int selectedIndex;

  BusinessSelectedState(this.selectedBusiness, this.selectedIndex);
}

// Bloc
class BusinessSelectionBloc extends Bloc<BusinessSelectionEvent, BusinessSelectionState> {
  BusinessSelectionBloc() : super(BusinessSelectionInitial()) {
    on<SelectBusinessEvent>((event, emit) async {
      await SharedPreferencesService.instance.saveString("selected_business", event.selectedBusiness);
      emit(BusinessSelectedState(event.selectedBusiness, event.selectedIndex));
    });

    _loadInitialBusiness();
  }

  void _loadInitialBusiness() async {
    final selectedBusiness = SharedPreferencesService.instance.getString("selected_business") ?? "Stroy Baza №1";
    final selectedIndex = selectedBusiness == "Stroy Baza №1"
        ? 0
        : selectedBusiness == "Giaz Mebel"
            ? 1
            : selectedBusiness == "Goldklinker"
                ? 2
                : 0;
    add(SelectBusinessEvent(selectedBusiness, selectedIndex));
  }
}