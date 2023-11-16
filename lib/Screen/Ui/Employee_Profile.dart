


import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:zainlak_tech/Constant/AppColor.dart';
import 'package:zainlak_tech/Services/reservations.dart';
import 'package:zainlak_tech/Services/users.dart';

import '../../Auth/LoginScreen.dart';

class employeeProfile extends StatefulWidget {
  final Map<String,dynamic> tech;
  const employeeProfile ({Key? key, required this.tech}) : super(key: key);

  @override
  State<employeeProfile> createState() => _employeeProfile();
}

class _employeeProfile extends State<employeeProfile> {



  bool isLoading = false;
  String phoneNumber = "";
  String email="";
  String name = "";
  String position = "";
  String joinedAt = "";
  String imageUrl = "";
  String job = "";
  bool isSameUser = false;

  DateTime? _date;

  int _time = 0;
  bool _isFavorite = false;
  void detectIsFavorite()async{
    bool isFavorite = await UserService.isFavoriteTechnician(technicianId: widget.tech['_id']);
    setState(() {
      _isFavorite = isFavorite;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    detectIsFavorite();
  }

  DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    DateTime Date = DateTime.now();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.AppColors,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Stack(


                    children: [


                      Card(

                        margin: const EdgeInsets.symmetric(vertical: 40,horizontal: 20),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 30,),
                              Align( alignment: Alignment.center, child:
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(widget.tech['name'],style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                                  Text(widget.tech['available'] ? "Available" : "Not Available",style: TextStyle(fontWeight: FontWeight.bold,color:widget.tech['available'] ? Colors.green : Colors.red,fontSize: 20),)
                                ],
                              )),
                              const SizedBox(height: 10,),
                              Align( alignment: Alignment.center, child: const Text('Joined Since',style: TextStyle(fontSize: 17,color: Colors.indigo),).tr(args: [dateFormat.format(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.tech['createdAt'])))])),
                              const SizedBox(height: 20,),
                              Align(alignment: Alignment.center  , child: const Text('WorkTime').tr(args: [widget.tech['from'],widget.tech['to']]),),
                              const SizedBox(height: 20,),
                              Align(alignment: Alignment.center, child: const Text('Service Price').tr(args: ["${widget.tech['price']} SAR"]),),
                              const SizedBox(height: 20,),

                              const Divider(thickness: 1,),
                              const SizedBox(height: 40,),
                              Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 20,right: 20,left: 20,top: 0),
                                  child: Visibility(
                                    visible: widget.tech['available'],
                                    child: MaterialButton(
                                      onPressed: () async{
                                        DateTime? date = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime(2024),
                                          locale: const Locale('en','')
                                        );

                                        if(date != null){
                                          TimeOfDay? time = await showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now()
                                          );

                                          if(time != null){
                                            setState(() {
                                              _date = date;
                                              _time = time.hour;
                                            });
                                          }
                                          await bookReservation();
                                        }


                                      },
                                      color: AppColor.AppColors,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Text('احجز زياره للمنزل',style: TextStyle(color: Colors.white,fontSize: 18),).tr(),
                                const SizedBox(width: 10,),
                                const Icon(Icons.bookmark_border,color: Colors.white,)
                                ],
                              ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10,),
                              Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                  onPressed: ()async{
                                    if(_isFavorite){
                                      await UserService.deleteFavoriteTech(widget.tech['_id']);
                                    }else{
                                      await UserService.createFavoriteTech(widget.tech['_id']);
                                    }
                                    setState(() {
                                      _isFavorite = !_isFavorite;
                                    });
                                  },
                                  icon: Icon(Icons.favorite,color: _isFavorite ? Colors.red : Colors.black,),
                                ),
                              ),
                              const Divider(thickness: 1,),

                              const SizedBox(height: 10,),


                              const SizedBox(height: 10,),






                            ],
                          ),
                        ),


                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Container(
                            width:80 ,
                            height:80 ,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(width: 5,color: Theme.of(context).scaffoldBackgroundColor),
                                image: DecorationImage(image: CachedNetworkImageProvider(widget.tech['image']),fit: BoxFit.fill)
                            ),
                          )
                        ],)
                    ]
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void logOut (context){
    showDialog(context: context, builder: (context){

      return  AlertDialog(

        title: Column(
          children: [
            Row(children: [
              const Icon(Icons.logout),
              const SizedBox(width: 10,),
              const Text('Sign Out').tr()
            ],),
            const SizedBox(height: 10,),
            TextButton(onPressed: (){}, child: const Text('Do you want logOut',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),).tr())
          ],
        ),
        actions: [
          TextButton(onPressed: ()async{


            Navigator.push(context, MaterialPageRoute(builder: (context){
              return const LoginScreen();
            }));

          }, child: const Text('Ok').tr()),
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: const Text('Cancel').tr()),
        ],

      );
    });
  }
  Future<void> bookReservation() async {
    try {
      DateFormat format = DateFormat('MM-dd');
      String newDate = format.format(_date!);

      ({String? message}) result = await ReservationService.createReservation(widget.tech['_id'], newDate, _time);

      if(result.message == null){
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AnimatedDialog(
              title: 'Booking Successful'.tr(),
              icon: Icons.check_circle,
              iconColor: Colors.green,
              backgroundColor: AppColor.AppColors,
            );
          },
        );
      }else{
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AnimatedDialog(
              title: result.message!,
              icon: Icons.close,
              iconColor: Colors.red,
              backgroundColor: Colors.black,
            );
          },
        ); }



    } catch (error) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const AnimatedDialog(
            title: 'Booking Failed',
            icon: Icons.close,
            iconColor: Colors.red,
            backgroundColor: Colors.white,
          );
        },
      );
    }
  }

}


class AnimatedDialog extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;

  const AnimatedDialog({super.key, 
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
  });

  @override
  _AnimatedDialogState createState() => _AnimatedDialogState();
}

class _AnimatedDialogState extends State<AnimatedDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      backgroundColor: Colors.transparent,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (BuildContext context, Widget? child) {
          return ScaleTransition(
            scale: _scaleAnimation,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                height: 250,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.icon,
                      color: widget.iconColor,
                      size: 80,
                    ),
                    const SizedBox(height: 20),
                    AutoSizeText(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),maxLines: 1,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'OK',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
