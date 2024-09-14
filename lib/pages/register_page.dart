import 'package:flutter/material.dart';
import 'package:global_chat_app/components/my_button.dart';
import 'package:global_chat_app/components/my_email_field.dart';
import 'package:global_chat_app/data/auth_services.dart';
import 'package:provider/provider.dart';
class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({
    super.key,required this.onTap,
  });
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController cPassController = TextEditingController();
  // Register method
  void register(){
    final authServices = Provider.of<AuthServices>(context, listen: false);
    if(passController.text != cPassController.text){
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Password Mismatched"
          ),
        ),
      );
    }else{
    try{
      authServices.createUserWithEmailAndPassword(emailController.text, passController.text);
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
                SizedBox(height: 30),
                Text(
                  'Create a new account',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 50),
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
                SizedBox(height:35),
                //Email textform will be here
                MyEmailField(
                  hintText: "Confirm Password",
                  isObsecureText: true,
                  controller: cPassController,
                ),
                SizedBox(height: 25,),
                // signin button
                MyButton(title: "Sign up", onTap:register),

                // not a member
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already a Member?"),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text("Login",
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
