import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meeting/helper/ErrorBottomSheet.dart';
import 'package:meeting/helper/imagees.dart';
import 'package:meeting/helper/textview.dart';
import '../APIs/Api.dart';
import '../APIs/user_data.dart';
import '../Models/login_model.dart';
import '../Routes/AppRoutes.dart';
import '../helper/NotificationServices.dart';
import '../helper/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {

  bool passwordAisible = true;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? fcmTokn;

  @override
  void initState() {
    super.initState();
    fcmToken();
  }
  fcmToken() async {
    fcmTokn = await NotificationServices.messaging.getToken();
    print('hghjghjhgjhgj$fcmTokn');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.WHITECOLOR,
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 40),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 100),
                  child: headingText(
                    title: 'Welcome',
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                addPadding(20, 0),
                Center(
                  child: Image.asset(
                    loginimage,
                    fit: BoxFit.fitHeight,
                  ),
                ),
                addPadding(40, 0),
                _emailUi(),

                addPadding(20, 0),
                _passwordUi(),

                addPadding(30, 0),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: InkWell(
            onTap: () {
              if (_formKey.currentState!.validate()) {
                initiateLoginApi();
              }
            },
            child: Container(
              height: 55,
              width: double.infinity,
              decoration: BoxDecoration(
              color: ColorConstants.DarkMahroon,
                  borderRadius: BorderRadius.circular(10)),
              child:  Center(
                  child: isLoading? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Please wait....',style: TextStyle(
                          color: Colors.white,fontSize: 20
                      ),),
                    ],
                  ):
                  const Text(
                    'Continue',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )),
            ),
          ),
        ),
      ),
    );
  }
  // Email input field
  _emailUi() => TextFormField(
    controller: emailController,
    keyboardType: TextInputType.emailAddress,
    style: TextStyle(
        color: ColorConstants.GREY7COLOR,
        decorationColor: ColorConstants.WHITECOLOR),
    cursorColor: ColorConstants.DarkMahroon,
    decoration: InputDecoration(
      labelText: 'Email Address',
      labelStyle: TextStyle(fontSize: 14, color: ColorConstants.GREY6COLOR),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color: ColorConstants.GREYCOLOR)),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: ColorConstants.DarkMahroon)),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {

        return 'This field is required';
      }
      final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
      if (!emailRegex.hasMatch(value)) {
        return 'Please enter a valid email format like demo@gmail.com';
      }
      return null;
    },
  );

  _passwordUi() => TextFormField(
    style: const TextStyle(color: ColorConstants.GREYCOLOR),
    cursorColor: ColorConstants.DarkMahroon,
    controller: passwordController,
    obscureText: passwordAisible,
    decoration: InputDecoration(
      border: const OutlineInputBorder(
        borderSide: BorderSide(
          color: ColorConstants.GREYCOLOR,
        ),
      ),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: ColorConstants.DarkMahroon)),
      labelText: 'Password',
      labelStyle: TextStyle(fontSize: 14, color: ColorConstants.GREY6COLOR),
      suffixIcon: IconButton(
        icon: Icon(passwordAisible
            ? Icons.visibility_off
            : Icons.visibility),
        onPressed: () {
          setState(() {
            passwordAisible = !passwordAisible;
          });
        },
      ),
    ),
    validator: (value) {
      if (value!.isEmpty) {
        return 'This field is required';
      }
      return null;
    },
  );

  initiateLoginApi() async {
    setState(() {isLoading = true;});
    var hashMap = {
      "email": emailController.text.trim().toString(),
      "password": passwordController.text.trim(),
      "firebase_tokens":  fcmTokn.toString(),
    };
    print('check_login_api$hashMap');
    var response = await loginApi(hashMap);
    setState(() {
      if (response.status){
        showSuccessBottomSheet(response.message);
        LoginModel myModel = response.data;
        viewLoginDetail = myModel;
        setLoginModelDetail(myModel).whenComplete((){
          getLoginModelDetail().then((userDatum)
          {
            print("LOGIN_API=>$iAuthorization");
            viewLoginDetail = userDatum;
            if(viewLoginDetail!=null){
              Get.offAllNamed(Routes.DASHBOARD
              );
            }
          });
        });
        isLoading = false;
      } else {
        isLoading = false;
        showErrorBottomSheet(response.message);
        /*ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: headingText(title: response.message,color: Colors.red,
              fontSize: 18)),
        );
*/
      }
    });
  }
}
