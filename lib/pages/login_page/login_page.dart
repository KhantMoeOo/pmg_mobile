import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../obs/response_ob.dart';
import '../../services/odoo.dart';
import '../../utils/app_const.dart';
import '../dashboard/dashboard_page.dart';
import 'login_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _dbcontroller = TextEditingController();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final _loginFormKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool ispwdshow = false;
  FocusNode dbFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode pwdFocus = FocusNode();
  final loginBloc = LoginBloc();
  final Odoo odoo = Odoo(BASEURL);
  List<dynamic> dbList = [];
  String dbName = '';

  @override
  void initState() {
    super.initState();
    loginBloc.getLoginStream().listen((ResponseOb responseOb) {
      if (responseOb.msgState == MsgState.data) {
        final snackbar = SnackBar(
            elevation: 0.0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 1),
            backgroundColor: Colors.green,
            content:
                const Text('Login Successfully!', textAlign: TextAlign.center));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) {
          return const DashboardPage(); //ProductListPage
        }), (route) => false);
      }
      if (responseOb.msgState == MsgState.error) {
        final snackbar = SnackBar(
            elevation: 0.0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 1),
            backgroundColor: const Color.fromARGB(255, 241, 15, 15),
            content: const Text('Something went wrong!',
                textAlign: TextAlign.center));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _dbcontroller.dispose();
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(left: height * 0.2, right: height * 0.2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                // mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    width: height * 0.4,
                    height: height * 0.4,
                    child: Image.asset(
                      'assets/logo/logo.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                  Form(
                    child: Expanded(
                      child: ListView(
                        padding: EdgeInsets.only(
                            left: height * 0.2,
                            right: height * 0.2,
                            top: height * 0.2,
                            bottom: height * 0.2),
                        // mainAxisAlignment: MainAxisAlignment.center,
                        // mainAxisSize: MainAxisSize.max,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Email',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 50,
                            width: height * 0.5,
                            child: TextFormField(
                              focusNode: emailFocus,
                              scrollPadding: const EdgeInsets.only(bottom: 40),
                              onEditingComplete: (() => FocusScope.of(context)
                                  .requestFocus(pwdFocus)),
                              controller: _emailcontroller,
                              autofocus: false,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                              decoration: InputDecoration(
                                // focusedBorder: OutlineInputBorder(
                                //     borderSide:
                                //         const BorderSide(color: Colors.purple),
                                //     borderRadius: BorderRadius.circular(10)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ), //Email Text Field
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'Password',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: height * 0.5,
                            height: 50,
                            child: TextFormField(
                              scrollPadding: const EdgeInsets.only(bottom: 40),
                              onEditingComplete: () {
                                FocusScope.of(context).unfocus();
                                // loginButton();
                              },
                              focusNode: pwdFocus,
                              controller: _passwordcontroller,
                              autofocus: false,
                              obscureText: !ispwdshow,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onPressed: () {
                                    setState(() {
                                      ispwdshow = !ispwdshow;
                                    });
                                  },
                                  icon: ispwdshow
                                      ? const Icon(Icons.visibility)
                                      : const Icon(Icons.visibility_off),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ), // Password Text Field
                          const SizedBox(
                            height: 20,
                          ),
                          StreamBuilder<ResponseOb>(
                            stream: loginBloc.getLoginStream(),
                            builder:
                                (context, AsyncSnapshot<ResponseOb> snapshot) {
                              ResponseOb? responseOb = snapshot.data;
                              if (responseOb?.msgState == MsgState.loading) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  width: height * 0.5,
                                  height: 50,
                                  child: Center(
                      child: Image.asset(
                        'assets/gifs/loading.gif',
                        width: 50,
                        height: 50,
                      ),
                    ),
                                );
                              }
                              return SizedBox(
                                width: height * 0.5,
                                height: 50,
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Colors.red),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  // borderSide: BorderSide(
                                  //   width: 5.0,
                                  //   color: Colors.blue,
                                  //   style: BorderStyle.solid,
                                  // ),
                                  onPressed: () {
                                    print(
                                        '___________________ ${_emailcontroller.text} $dbName ${_passwordcontroller.text}');
                                    loginBloc.login(
                                        _emailcontroller.text,
                                        _passwordcontroller.text,
                                        'pmg_testing_01');
                                  },
                                  child: const Text(
                                    'Log in',
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 20),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Positioned(
              top: 20,
              right: 20,
              child: Text(
                'v0.0.2',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
