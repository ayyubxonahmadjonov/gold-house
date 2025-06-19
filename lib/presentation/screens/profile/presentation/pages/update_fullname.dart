import 'package:awesome_dialog/awesome_dialog.dart';
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
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setString(
                    'profilfullname',
                    "${nameController.text} ${surnameController.text}",
                  );

                  CustomAwesomeDialog.showInfoDialog(
                    onOkPress: () {
                      Navigator.pop(context);
                      setState(() {});
                    },

                    dialogtype: DialogType.success,
                    context,
                    title: "O'zgarishlarni saqlandi",
                    desc: "Ism va familiyangiz muvaffaqiyatli o'zgartirildi",
                  );
                },
                title: "O'zgarishlarni salash",
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
      ),
    );
  }
}
