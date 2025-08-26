import 'package:awesome_dialog/awesome_dialog.dart' show DialogType;
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

  // ✅ ValueNotifier qo‘shildi
  final ValueNotifier<String> fullnameNotifier = ValueNotifier<String>("");

  @override
  void initState() {
    super.initState();

    fullnameNotifier.value =
        SharedPreferencesService.instance.getString("profilfullname") ?? "";
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
                  fullname.isEmpty ? "Ism familiya kiritilmagan" : fullname,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              );
            },
          ),
          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              'Ismingiz',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          CustomTextField(
            label: "",
            controller: nameController,
            hintText: "Ismingizni kiriting",
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              'Familiyangiz',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          CustomTextField(
            controller: surnameController,
            hintText: "Familiyangizni kiriting",
            label: '',
          ),
    
          Center(
            child: CustomButton(
              onPressed: () async {
                final newFullname =
                    "${nameController.text} ${surnameController.text}";
    
      
                SharedPreferencesService.instance
                    .saveString('profilfullname', newFullname);
                fullnameNotifier.value = newFullname;

                CustomAwesomeDialog.showInfoDialog(
                  onOkPress: () {
                    Navigator.pop(context);
                  },
                  dialogtype: DialogType.success,
                  context,
                  title: "O'zgarishlar saqlandi",
                  desc: "Ism va familiyangiz muvaffaqiyatli o'zgartirildi",
                );
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
          ),
        ],
      ),
    );
  }
}
