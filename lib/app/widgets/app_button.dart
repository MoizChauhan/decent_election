import 'package:decent_election/app/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppButton extends StatelessWidget {
  const AppButton(
      {super.key,
      required this.onPressed,
      required this.buttonText,
      this.horizontal = 40.0,
      this.customWidget});
  final Function() onPressed;
  final String buttonText;
  final double horizontal;
  final Widget? customWidget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: 10.0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: AppColors.gradient1.withOpacity(0.4),
                offset: Offset(4, 4),
                blurRadius: 15.0),
            BoxShadow(
                color: AppColors.gradient2.withOpacity(0.4),
                offset: Offset(4, 4),
                blurRadius: 15.0)
          ],
          gradient: LinearGradient(
            begin: Alignment(-0.35, -1.272),
            end: Alignment(0.84, 0.87),
            colors: [AppColors.gradient1, AppColors.gradient2],
            stops: const [0.0, 1.0],
          ),
          color: Colors.deepPurple.shade300,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            splashFactory: InkRipple.splashFactory,
            elevation: MaterialStateProperty.all(50),
            minimumSize: MaterialStateProperty.all(Size(Get.width, 50)),
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
            // elevation: MaterialStateProperty.all(3),
            shadowColor: MaterialStateProperty.all(Colors.transparent),
          ),
          onPressed: () {
            onPressed.call();
          },
          child: Padding(
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (customWidget != null) ...[
                  customWidget!,
                  SizedBox(width: 10)
                ],
                Text(
                  buttonText,
                  style: TextStyle(
                    fontSize: 18,
                    // fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // width: MediaQuery.of(context).size.width * 0.8,
    // height: 50,
  }
}

Widget loader() {
  return Center(child: CupertinoActivityIndicator());
}

class AppButtonOutlined extends StatelessWidget {
  const AppButtonOutlined(
      {super.key,
      required this.onPressed,
      required this.buttonText,
      this.horizontal = 40.0,
      this.customWidget});
  final Function() onPressed;
  final String buttonText;
  final double horizontal;
  final Widget? customWidget;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(
        side: MaterialStateProperty.all<BorderSide>(
            BorderSide(color: AppColors.gradient2)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13.0),
              side: BorderSide(color: AppColors.gradient2)),
        ),
        splashFactory: InkRipple.splashFactory,
        elevation: MaterialStateProperty.all(50),
        minimumSize: MaterialStateProperty.all(Size(40, 50)),
        // backgroundColor: MaterialStateProperty.all(Colors.transparent),
        // elevation: MaterialStateProperty.all(3),
        shadowColor: MaterialStateProperty.all(Colors.transparent),
      ),
      onPressed: () {
        onPressed.call();
      },
      child: Padding(
        padding: const EdgeInsets.only(
          top: 10,
          bottom: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (customWidget != null) customWidget!,
            SizedBox(width: 6),
            Text(
              buttonText,
              style: TextStyle(
                fontSize: 15,

                // fontWeight: FontWeight.w700,
                color: AppColors.gradient2,
              ),
            ),
          ],
        ),
      ),
    );

    // width: MediaQuery.of(context).size.width * 0.8,
    // height: 50,
  }
}

class AppCustomButton extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final double? radius;
  final Color? color;
  final List<BoxShadow>? shadow;
  final Function onpressed;
  final bool isContainerDim;

  const AppCustomButton({
    super.key,
    required this.width,
    required this.height,
    required this.onpressed,
    this.radius,
    this.color,
    this.shadow,
    required this.child,
    this.isContainerDim = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        height: isContainerDim ? height : null,
        width: isContainerDim ? width : null,
        decoration: BoxDecoration(
          boxShadow: shadow ??
              [
                BoxShadow(
                    color: color == null
                        ? Colors.black26
                        : AppColors.gradient2.withOpacity(0.2),
                    offset: Offset(0, 2),
                    blurRadius: color == null ? 5.0 : 7)
              ],
          gradient: color == null
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.gradient1, AppColors.gradient2],
                  stops: const [0.0, 1.0],
                )
              : null,
          color: color,
          borderRadius: BorderRadius.circular(radius ?? 10),
        ),
        child: Center(
          child: ElevatedButton(
            style: ButtonStyle(
              padding: isContainerDim
                  ? MaterialStateProperty.all(EdgeInsets.zero)
                  : null,
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius ?? 10),
                ),
              ),
              minimumSize: MaterialStateProperty.all(Size(width, height)),
              backgroundColor: MaterialStateProperty.all(Colors.transparent),
              // elevation: MaterialStateProperty.all(3),
              shadowColor: MaterialStateProperty.all(Colors.transparent),
            ),
            onPressed: () {
              onpressed();
            },
            child: child,
            // Padding(
            // padding: const EdgeInsets.only(
            //   top: 10,
            //   bottom: 10,
            // ),
            // child: Text(
            //   buttonText,
            //   style: TextStyle(
            //     fontSize: 18,
            //     fontFamily: AppFonts.Montserrat,
            //     // fontWeight: FontWeight.w700,
            //     color: Colors.white,
            //   ),
            // ),
          ),
        ),
        // ),
      ),
    );
  }
}
