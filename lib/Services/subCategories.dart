import 'package:http/http.dart' as http;
import 'dart:convert';

class SubCategoriesService{
  static Future<List> getAllSubCategories({ required String parentCategory }) async{
    try{
      var uri = Uri.parse('https://adminzaindev.zaindev.com.sa/subCategories/$parentCategory');
      http.Response response = await http.get(uri);
      List subCategories = jsonDecode(response.body);

      return subCategories;
    }catch(error){
      print(error.toString());
      return [];
    }
  }

  static Future<({List technicians, String? message})> getAllSubCategoriesTechnicians({ required String subCategoryId }) async{
    try{
      var uri = Uri.parse('https://adminzaindev.zaindev.com.sa/subCategories/$subCategoryId/technicians');
      http.Response response = await http.get(uri);
      List subCategories = jsonDecode(response.body);

      return (technicians:subCategories,message:null);
    }catch(error){
      print(error.toString());
      return (technicians:[],message:"Failed To Get Technicians");
    }
  }
}