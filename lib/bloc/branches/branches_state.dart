part of 'branches_bloc.dart';


abstract class BranchesState {}

final class BranchesInitial extends BranchesState {}
class GetBranchesSuccess extends BranchesState{
  List<BranchModel> branches;
  GetBranchesSuccess({required this.branches});
}
class GetBranchesLoading extends BranchesState{}
class GetBranchesError extends BranchesState{
  final String message;
  GetBranchesError({required this.message});
}
