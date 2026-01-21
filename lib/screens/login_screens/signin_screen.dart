import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/bottom_screen.dart';
import 'package:to_do_app/screens/login_screens/forgetpassword_screen.dart';
import 'package:to_do_app/screens/login_screens/signup_screen.dart';


class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController password= TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(height: double.infinity,width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff1253AA), Color(0xff05243E)],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Form(key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 100),
                  Center(child: Image.asset('assets/Checkmark-1.png')),
                  SizedBox(height: 30),
                   SingleChildScrollView(scrollDirection: Axis.horizontal,
                     child: Row(
                       children: [
                         Text("Welcome Back to",style: TextStyle(color: Colors.white,fontSize: 25)),
                         SizedBox(width: 8),
                         Text("DO IT ",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 23)),
                       ],
                     ),
                   ),
                   Text("Have an other productive day ! ",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14)),
                  SizedBox(height: 40),
                  TextFormField(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email,color: Color(0xff000000)),
                      hintText: 'E-mail',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      filled: true
                    ),
                    validator: (value){
                      if(value==null || value.isEmpty){
                        return 'please enter your email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: password,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock,color: Color(0xff000000),),
                        hintText: 'Password',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        filled: true
                    ),
                    validator: (value){
                      if(value==null  || value.isEmpty){
                        return 'please enter your email';
                      }
                      return null;
                    },
                  ),
                  Align(alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetpasswordScreen()),);
                      },
                      child:Text("Forget password?", style: TextStyle(color: Colors.white, decoration: TextDecoration.underline)),
                    ),
                  ),
                  SizedBox(
                  height: 45,
                  width: double.infinity,
                  child: TextButton(
                      // onPressed: ()async{
                      //       if(_formKey.currentState!.validate()){}
                      //       try{
                      //         UserCredential login= await auth.signInWithEmailAndPassword(email: email.text, password: password.text);
                      //         if(login.user!.emailVerified){
                      //           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomScreen()));
                      //         }
                      //         else{
                      //           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("First verify your email")));
                      //         }
                      //        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomScreen()),);
                      //       }catch(e){
                      //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                      //       }
                      //     },
                      onPressed: isLoading ? null : () async {
                        if (!_formKey.currentState!.validate()) return;
                        setState(() => isLoading = true);
                        try {
                          UserCredential login = await auth.signInWithEmailAndPassword(email: email.text.trim(), password: password.text.trim(),
                          );
                          if (login.user!.emailVerified) {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomScreen()),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("First verify your email")),
                            );
                          }
                        } catch(e){
                          String message= 'Loign Faild';
                          if(e is FirebaseAuthException){
                            if(e.code=='user-not-found') message='no user found';
                            if(e.code=='wrong-password') message='incorrect password';
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(message)),
                          );
                        }
                        finally {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                      style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Color(0xff0EA5E9),
                              textStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: isLoading?
                            SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(color: Colors.white,strokeWidth: 2,)):Text("sign in",)),
                ),
                  SizedBox(height: 20),
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Don’t have an account?',style: TextStyle(color: Colors.white),),
                      TextButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SignupScreen()),);
                      },
                          child: Text('sign up',style: TextStyle(color: Color(0xff0EA5E9),fontWeight: FontWeight.bold),))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
