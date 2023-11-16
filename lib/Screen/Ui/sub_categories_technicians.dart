import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:zainlak_tech/Constant/AppColor.dart';
import 'package:zainlak_tech/Screen/Ui/Employee_Profile.dart';
import 'package:zainlak_tech/Services/subCategories.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SubCategoriesTechnicians extends StatefulWidget {
  final String subCategoryId;

  const SubCategoriesTechnicians({Key? key, required this.subCategoryId})
      : super(key: key);

  @override
  State<SubCategoriesTechnicians> createState() =>
      _SubCategoriesTechniciansState();
}

class _SubCategoriesTechniciansState extends State<SubCategoriesTechnicians> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.AppColors,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ),
        body: FutureBuilder<({List technicians, String? message})>(
            future: SubCategoriesService.getAllSubCategoriesTechnicians(
            subCategoryId: widget.subCategoryId,
        ),
        builder: (BuildContext context,
        AsyncSnapshot<({List<dynamic> technicians, String? message})>
            snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (snapshot.hasError) {
        return Center(
          child: const Text('Something Went Wrong').tr(),
        );
      }

      if (snapshot.data != null) {

        if(snapshot.data!.technicians.isEmpty){
          return Center(
            child: AutoSizeText('There Is No Technicians Here'.tr(),style: const TextStyle(
              fontSize: 24
            ),maxLines: 1,),
          );
        }
        if (snapshot.data!.message != null) {
          return Text('${snapshot.data!.message}');
        } else {
          return ListView.builder(
            itemCount: snapshot.data?.technicians.length,
            itemBuilder: (context, index) {
              final tech = snapshot.data!.technicians[index];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: CachedNetworkImage(
                    imageUrl: tech['image'],
                    placeholder: (context, url) => const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                    imageBuilder: (context, imageProvider) => Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  title: Text(tech['name']),
                  subtitle: Text(tech['location']),
                  onTap: () {
                    // Navigate to profile screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => employeeProfile(tech: tech),
                      ),
                    );
                  },
                ),
              );
            },
          );
        }
      }

      return Container();
    },
    ),
    );
  }
}
