import 'package:flutter/material.dart';
import 'package:global_chat_app/components/my_button.dart';
import 'package:global_chat_app/components/my_email_field.dart';
import 'package:global_chat_app/data/auth_services.dart';
import 'package:provider/provider.dart';
class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  // sigin method
  void signIn(){
    final authServices = Provider.of<AuthServices>(context,listen: false);
    try{
      authServices.signInWithEmailAndPassword(emailController.text, passController.text);
    } catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
        content: Text(
        e.toString(),
        ),
        ),
      );
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                SizedBox(height: 70),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Image(
                          image: AssetImage('assets/chatapp.jpg'),
                      ),
                      SizedBox(width: 10),
                      const Text(
                          "Solo",
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'courier',
                      )
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                 Text(
                    'Welcome back! Login to your account',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 100),
                //Email textform will be here
                MyEmailField(
                  hintText: "Email",
                  isObsecureText: false,
                  controller: emailController,
                ),
                SizedBox(height:35),
                //Email textform will be here
                MyEmailField(
                  hintText: "Password",
                  isObsecureText: true,
                  controller: passController,
                ),
                SizedBox(height: 25,),
                // signin button
                MyButton(title: "Sign in", onTap:signIn),

                // not a member
                const SizedBox(height: 20),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Not a Member?"),
                    GestureDetector(
                      onTap: widget.onTap ,
                      child: const Text("Signup",
                          style:TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
