
import 'package:gold_house/bloc/bloc/user_agrrements_dart_bloc.dart';
import 'package:gold_house/core/constants/app_imports.dart';

class UserAgreements extends StatefulWidget {
  const UserAgreements({super.key});
  @override
  State<UserAgreements> createState() => _UserAgreementsState();
}
class _UserAgreementsState extends State<UserAgreements> {
  String language = "uz";
  @override
  void initState() {
    super.initState();
    language = SharedPreferencesService.instance.getString("selected_lg") ?? "uz";
    BlocProvider.of<UserAgrrementsDartBloc>(
      context,
    ).add(GetUserAgreementsDataEvent());
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Foydalanuvchi shartnomasi")),
      body: BlocBuilder<UserAgrrementsDartBloc, UserAgrrementsDartState>(
        builder: (context, state) {
         if(state is UserAgrrementsDartSuccess){
          return Column(
            children: [
     Text( language == "uz" ? state.userAgreements[0].titleUz : language == "ru" ? state.userAgreements[0].titleRu : state.userAgreements[0].titleEn,style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600),),
     Text(language == "uz" ? state.userAgreements[0].contentUz : language == "ru" ? state.userAgreements[0].contentRu : state.userAgreements[0].contentEn,style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
          ],
        );
         }else{
          return const Center(child: CircularProgressIndicator());
         }
        },
      ),
    );
  }
}
