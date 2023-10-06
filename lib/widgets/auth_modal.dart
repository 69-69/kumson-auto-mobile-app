import 'package:flutter/material.dart';
import '../utils/size_config.dart';

class AuthModal extends StatefulWidget {
  final String authType;

  const AuthModal({super.key, required this.authType});

  @override
  State<AuthModal> createState() => _AuthModalState();
}

class _AuthModalState extends State<AuthModal> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen
    SizeConfig().init(context);

    return Container(
      height: SizeConfig.screenHeight! * 0.85,
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(60)),
      child: SingleChildScrollView(
        primary: true,
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.symmetric(vertical: SizeConfig.screenHeight! / 4),
        physics: const BouncingScrollPhysics(),
        child: Form(
          child: buildAuthForm(context),
        ),
      ),
    );
  }

  Column buildAuthForm(BuildContext context) {
    return Column(
          children: [
            Text(
              widget.authType,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: getProportionateScreenWidth(20),
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const Divider(thickness: 1),
            SizedBox(height: getProportionateScreenHeight(20)),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              // onFieldSubmitted: bloc.onChangeEmail,
              // onChanged: bloc.onChangeEmail,
              decoration: InputDecoration(
                filled: true,
                hintText: "Enter Email",
                // errorText: snapshot.hasError ? snapshot.error.toString() : "",
                fillColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.04),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 2.0, horizontal: 10.0),

                alignLabelWithHint: true,
                /*border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),*/
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(7)),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              // onFieldSubmitted: bloc.onChangeEmail,
              // onChanged: bloc.onChangeEmail,
              decoration: InputDecoration(
                filled: true,
                hintText: "Enter Password",
                // errorText: snapshot.hasError ? snapshot.error.toString() : "",
                fillColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.04),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 2.0, horizontal: 10.0),

                alignLabelWithHint: true,
                /*border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),*/
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(7)),
            SizedBox(
              width: SizeConfig.screenWidth,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                      width: 1.0,
                      color: Theme.of(context).colorScheme.primary),
                ),
                child: Text(widget.authType),
              ),
            ),
          ],
        );
  }
}
