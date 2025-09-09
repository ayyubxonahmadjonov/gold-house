import 'package:awesome_dialog/awesome_dialog.dart' show DialogType;
import 'package:easy_localization/easy_localization.dart';
import 'package:gold_house/bloc/user_update/user_update_bloc.dart';
import 'package:gold_house/core/constants/app_imports.dart';
import 'package:gold_house/core/shared/custom_awesome_dialog.dart';
import 'package:gold_house/core/shared/custom_textfield.dart';

class UpdateFullname extends StatefulWidget {
  const UpdateFullname({super.key});

  @override
  State<UpdateFullname> createState() => _UpdateFullnameState();
}

class _UpdateFullnameState extends State<UpdateFullname> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();

  final ValueNotifier<String> fullnameNotifier = ValueNotifier<String>("");
  int id = 0;

  @override
  void initState() {
    super.initState();

    fullnameNotifier.value =
        SharedPreferencesService.instance.getString("profilfullname") ?? "";
    id = SharedPreferencesService.instance.getInt("user_id") ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔽 Bu yerda doimiy yangilanish
          ValueListenableBuilder<String>(
            valueListenable: fullnameNotifier,
            builder: (context, fullname, _) {
              return Center(
                child: Text(
                   "Ism Familiya kiriting",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              'your_name'.tr(),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          CustomTextField(
            label: "",
            controller: nameController,
            hintText: "enter_your_name".tr(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              'your_surname'.tr(),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          CustomTextField(
            controller: surnameController,
            hintText: "enter_your_surname".tr(),
            label: '',
          ),

          BlocConsumer<UserUpdateBloc, UserUpdateState>(
            listener: (context, state) {
        if(state is UserUpdateSuccess){
                CustomAwesomeDialog.showInfoDialog(
                  onOkPress: () {
                    Navigator.pop(context);
                  },
                  dialogtype: DialogType.success,
                  context,
                  title: "O'zgarishlar saqlandi",
                  desc: "Ism va familiyangiz muvaffaqiyatli o'zgartirildi",
                );
            }
            },
            builder: (context, state) {
              return Center(
                child: CustomButton(
                  onPressed: () async {
                    final newFullname =
                        "${nameController.text} ${surnameController.text}";
                    BlocProvider.of<UserUpdateBloc>(context).userFullNameUpdate(
                      UserFullNameUpdateEvent(
                        firstname: nameController.text,
                        lastname: surnameController.text,
                        userid: id.toString(),
                      ),
                    );
                    SharedPreferencesService.instance.saveString(
                      'profilfullname',
                      newFullname,
                    );
                    fullnameNotifier.value = newFullname;
                  },
                  title: "O'zgarishlarni saqlash",
                  bacColor: AppColors.yellow,
                  textColor: AppColors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  borderRadius: 5,
                  width: 350.w,
                  height: 50.h,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
