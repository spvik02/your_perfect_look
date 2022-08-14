import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:forypldbauth/model/appuser.dart';
import 'package:forypldbauth/model/combination.dart';
import 'package:forypldbauth/model/occasion.dart';
import 'package:http/http.dart' as http;
import 'package:forypldbauth/model/category.dart';
import 'package:forypldbauth/model/element.dart';
import 'package:forypldbauth/network/api_request.dart';
import 'package:forypldbauth/values/api_const.dart';

List<ElementCategory> parseCategory(String responseBody){
  var l = json.decode(responseBody) as List<dynamic>;
  var categories = l.map((model) => ElementCategory.fromJson(model)).toList();
  return categories;
}
List<Occasion> parseOccasion(String responseBody){
  var l = json.decode(responseBody) as List<dynamic>;
  var occasions = l.map((model) => Occasion.fromJson(model)).toList();
  return occasions;
}
List<MyElement> parseElement(String responseBody){
  var l = json.decode(responseBody) as List<dynamic>;
  var elements = l.map((model) => MyElement.fromJson(model)).toList();
  return elements;
}
MyElement parseElementDetail(String responseBody){
  var l = json.decode(responseBody) as dynamic;
  var element = MyElement.fromJson(l);
  return element;
}
Combination parseCombinationDetail(String responseBody){
  var l = json.decode(responseBody) as dynamic;
  var combination = Combination.fromJson(l);
  return combination;
}
List<Combination> parseCombination(String responseBody){
  var l = json.decode(responseBody) as List<dynamic>;
  var combinations = l.map((model) => Combination.fromJson(model)).toList();
  return combinations;
}
List<Appuser> parseAppuser(String responseBody){
  var l = json.decode(responseBody) as List<dynamic>;
  var users = l.map((model) => Appuser.fromJson(model)).toList();
  return users;
}
Appuser parseAppuserDetail(String responseBody){
  var l = json.decode(responseBody) as dynamic;
  var user = Appuser.fromJson(l);
  return user;
}




Future<List<ElementCategory>> fetchCategories() async {
  final response = await http.get(Uri.parse('$mainUrl$categoriesUrl'));
  if (response.statusCode == 200){
    return compute(parseCategory, response.body);
  }
  else if (response.statusCode == 404)
    throw Exception('Not found');
  else
    throw Exception('Cannot get Categories');
}
Future<List<Occasion>> fetchOccasions() async {
  final response = await http.get(Uri.parse('$mainUrl$occasionsUrl'));
  if (response.statusCode == 200){
    return compute(parseOccasion, response.body);
  }
  else if (response.statusCode == 404)
    throw Exception('Not found');
  else
    throw Exception('Cannot get Categories');
}
Future<List<MyElement>> fetchElementsByCategory(id) async {
  final response = await http.get(Uri.parse('$mainUrl$elementsUrl/$id'));
  if (response.statusCode == 200){
    //elementList = compute(parseElement, response.body)
    return compute(parseElement, response.body);
  }
  else if (response.statusCode == 404)
    throw Exception('Not found');
  else
    throw Exception('Cannot get Elements');
}
Future<List<MyElement>> fetchElementsSearch(idUser, idCategory, name) async {
  final String ElementsUrl = 'SearchElements';
  final response = await http.get(Uri.parse('$mainUrl$ElementsUrl/$idUser/$idCategory/$name'));
  if (response.statusCode == 200){
    return compute(parseElement, response.body);
  }
  else if (response.statusCode == 404)
    throw Exception('Not found');
  else
    throw Exception('Cannot get Elements');
}
Future<List<MyElement>> fetchElementsByCategoryAndUserId(idCategory, idUser) async {
  final response = await http.get(Uri.parse('$mainUrl$elementsByCategoryAndUserUrl/$idCategory/$idUser'));
  if (response.statusCode == 200){
    return compute(parseElement, response.body);
  }
  else if (response.statusCode == 404)
    throw Exception('Not found');
  else
    throw Exception('Cannot get Elements');
}
//отображает элементы из комбинации, используется в отображении образов
Future<List<MyElement>> fetchElementsByIdCombination(idCombination) async {
  final response = await http.get(Uri.parse('$mainUrl$elementsByIdCombination/$idCombination'));
  if (response.statusCode == 200){
    return compute(parseElement, response.body);
  }
  else if (response.statusCode == 404)
    throw Exception('Not found');
  else
    throw Exception('Cannot get Elements');
}
Future<List<Combination>> fetchCombinationByOccasionAndUserId(idOccasion, idUser) async {
  final response = await http.get(Uri.parse('$mainUrl$combinationByOccasionAndUserUrl/$idOccasion/$idUser'));
  if (response.statusCode == 200){
    return compute(parseCombination, response.body);
  }
  else if (response.statusCode == 404)
    throw Exception('Not found');
  else
    throw Exception('Cannot get Elements');
}
Future<List<Combination>> fetchCombinationWithElement(idElement) async {
  final response = await http.get(Uri.parse('$mainUrl$combinationUrl/GetCombinationsWithElement/$idElement'));
  if (response.statusCode == 200){
    return compute(parseCombination, response.body);
  }
  else if (response.statusCode == 404)
    throw Exception('Not found');
  else
    throw Exception('Cannot get Elements');
}
Future<List<Combination>> fetchCombinationOfFriendsByUserId(idUser) async {
  final response = await http.get(Uri.parse('$mainUrl$combinationUrl/GetCombinationsOfFriendsByUserId/$idUser'));
  if (response.statusCode == 200){
    return compute(parseCombination, response.body);
  }
  else if (response.statusCode == 404)
    throw Exception('Not found');
  else
    throw Exception('Cannot get Elements');
}
Future<List<Combination>> fetchCombinations() async {
  final response = await http.get(Uri.parse('$mainUrl$combinationUrl'));
  if (response.statusCode == 200){
    return compute(parseCombination, response.body);
  }
  else if (response.statusCode == 404)
    throw Exception('Not found');
  else
    throw Exception('Cannot get Elements');
}
Future<Combination> fetchCombination(idCombination) async{
  final response = await http.get(Uri.parse('$mainUrl$combinationUrl/$idCombination'));
  if (response.statusCode == 200){
    return compute(parseCombinationDetail, response.body);
  }
  else if (response.statusCode == 404)
    throw Exception('Not found');
  else
    throw Exception('Cannot get Element Detail');
}
Future<MyElement> fetchElementsDetail(id) async {
  final response = await http.get(Uri.parse('$mainUrl$elementDetailUrl/$id'));
  if (response.statusCode == 200){
    return compute(parseElementDetail, response.body);
  }
  else if (response.statusCode == 404)
    throw Exception('Not found');
  else
    throw Exception('Cannot get Element Detail');
}

Future<Appuser> getUserDetail(key, idUser) async{
  final response = await http.get(Uri.parse('$mainUrl$userPath/$idUser'), headers: {
    'Authorization': 'Bearer $key'
  });
  if (response.statusCode == 200){
    return compute(parseAppuserDetail, response.body);
  }
  else if (response.statusCode == 404)
    throw Exception('Not found');
  else
    throw Exception('Cannot get User Detail');

}
//возвращает строку являются ли пользователи друзьями
Future<String> getFriendshipState(idUser, idFriend) async{
  final response = await http.get(Uri.parse('$mainUrl$friendsUrl/GetFriendResult/$idUser/$idFriend'));
  if (response.statusCode == 200){
    return response.body;
  }
  else if (response.statusCode == 404){
    return 'Connection Not found';
  }
  else{
    throw Exception('Cannot get User by Id');
  }
}
Future<List<Combination>> getFriendPostedCombinations(idUser) async{
  final response = await http.get(Uri.parse('$mainUrl$combinationUrl/GetFriendPostedCombination/$idUser'));
  if (response.statusCode == 200){
    return compute(parseCombination, response.body);
  }
  else if (response.statusCode == 404)
    throw Exception('Not found');
  else
    throw Exception('Cannot get Elements');
}

Future<List<Appuser>> fetchFriendsByName(name) async {
  final response = await http.get(Uri.parse('$mainUrl$friendsUrl/$getFriendByNameUrl/$name'));
  if (response.statusCode == 200){
    return compute(parseAppuser, response.body);
  }
  else if (response.statusCode == 404)
    throw Exception('Not found');
  else
    throw Exception('Cannot get Elements');
}

Future<List<Appuser>> fetchFriendsRequest(idUser) async {
  final response = await http.get(Uri.parse('$mainUrl$friendsUrl/$getFriendRequests/$idUser'));
  if (response.statusCode == 200){
    return compute(parseAppuser, response.body);
  }
  else if (response.statusCode == 404)
    throw Exception('Not found');
  else
    throw Exception('Cannot get friends requests');
}
Future<List<Appuser>> fetchFriendsAcceptedRequest(idUser) async {
  final response = await http.get(Uri.parse('$mainUrl$friendsUrl/GetFriendAcceptedRequests/$idUser'));
  if (response.statusCode == 200){
    return compute(parseAppuser, response.body);
  }
  else if (response.statusCode == 404)
    throw Exception('Not found');
  else
    throw Exception('Cannot get friends requests');
}

//return all user's accepted friends
Future<List<Appuser>> fetchUserFriends(idUser) async{
  final response = await http.get(Uri.parse('$mainUrl$friendsUrl/GetUserFriends/$idUser'));
  if (response.statusCode == 200){
    return compute(parseAppuser, response.body);
  }
  else if (response.statusCode == 404)
    throw Exception('Not found');
  else
    throw Exception('Cannot get user friends');

}

Future<String> findUser(id, token) async {
  final response = await http.get(Uri.parse('$mainUrl$userPath/$id'), headers: {
    'Authorization': 'Bearer $token'
  });
  if (response.statusCode == 200){
    return response.body;
  }
  else if (response.statusCode == 404){
    return 'User Not found';
  }
  else{
    throw Exception('Cannot get User by Id');
  }
}
Future<String> findElement(id, token) async {
  final response = await http.get(Uri.parse('$mainUrl$elementDetailUrl/$id'), headers: {
    'Authorization': 'Bearer $token'
  });
  if (response.statusCode == 200){
    return response.body;
  }
  else if (response.statusCode == 404){
    return 'Element Not found';
  }
  else{
    throw Exception('Cannot get Element by Id');
  }
}
Future<String> findFriend(idUser, idFriend) async{
  final response = await http.get(Uri.parse('$mainUrl$getFriendResult/$idUser/$idFriend')
      //, headers: {'Authorization': 'Bearer $token'}
      );
  return response.body;
}

createUserApi(String key, String uid, String name, String email, String psw) async{
  var body = {
    'IdUser':uid,
    'Name':name,
    'Email': email,
    'Psw': psw,
    'IsAdmin':0
  };
  var res = await http.post(Uri.parse('$mainUrl$userPath'), headers: {
    "content-type":"application/json",
    "accept":"application/json",
    "Authorization":"Bearer $key"
  }, body: json.encode(body));
  if(res.statusCode == 201) return 'Created';
  else if (res.statusCode == 209) return 'Conflict';
  else return res;
}
//add element
createElementApi(String key, MyElement element) async{
  var body = {
    'NameElement':element.nameElement,
    'IdCategory': element.idCategory,
    'Price': element.price,
    'Note': element.note,
    'PicPath': element.picPath,
    'IdUser':element.idUser
  };
  var res = await http.post(Uri.parse('$mainUrl$elementDetailUrl'), headers: {
    "content-type":"application/json",
    "accept":"application/json",
    "Authorization":"Bearer $key"
  }, body: json.encode(body));
  if(res.statusCode == 201) return 'Created';
  else if (res.statusCode == 209) return 'Conflict';
  else return res;
}
//add combination
createCombinationApi(String key, Combination combination) async{
  var body = {
    'NameCombination': combination.nameCombination,
    'Note': combination.note,
    'IdOccasion': combination.idOccasion,
    'IdUser': combination.idUser,
    'IsPosted': combination.isPosted,
    'ElementInCombinations': combination.elementInCombinations
  };
  var res = await http.post(Uri.parse('$mainUrl$combinationUrl'), headers: {
    "content-type":"application/json",
    "accept":"application/json",
    "Authorization":"Bearer $key"
  }, body: json.encode(body));
  if(res.statusCode == 201) return 'Created';
  else if (res.statusCode == 209) return 'Conflict';
  else return res;
}
//add friend connection
createFriendApi(String key, String idUser, String idFriend) async{
  var body = {
    'IdUser': idUser,
    'IdFriend': idFriend,
    'IsAccepted': null
  };
  var res = await http.post(Uri.parse('$mainUrl$friendsUrl'), headers: {
    "content-type":"application/json",
    "accept":"application/json",
    "Authorization":"Bearer $key"
  }, body: json.encode(body));
  if(res.statusCode == 201) return 'Created';
  else if (res.statusCode == 209) return 'Conflict';
  else return res.statusCode;
}
createRating(String key, int idCombination, String idUser, double rating) async{
  var body = {
    'idCombination': idCombination,
    'idUser': idUser,
    'rating1': rating.toInt()
  };
  var res = await http.put(Uri.parse('$mainUrl$ratingUrl/CreateRating'), headers: {
    "content-type":"application/json",
    "accept":"application/json",
    "Authorization":"Bearer $key"
  }, body: json.encode(body));
  print('msgl createRating: ${res.statusCode.toString()}');
  if(res.statusCode == 200) return 'Updated';
  else if(res.statusCode == 204) return 'Updated';
  else return res.statusCode.toString();
}

putFriendStatus(String key, String idUser, String idFriend, bool status) async{
  var body = {
    'idUser': idFriend,
    'idFriend': idUser,
    'isAccepted': status
  };
  var res = await http.put(Uri.parse('$mainUrl$friendsUrl/PutFriendStatus'), headers: {
    "content-type":"application/json",
    "accept":"application/json",
    "Authorization":"Bearer $key"
  }, body: json.encode(body));
  print('$body');
  print('msgl putFriendStatus: ${res.statusCode.toString()}');
  if(res.statusCode == 200) return 'Updated';
  else if(res.statusCode == 204) return 'Updated';
  //500 все плохо
  else return res.statusCode.toString();
}
putCombinationStatus(String key, int idCombination, bool status) async{
  var body = {
    'idCombination': idCombination,
    'isPosted': status
  };
  var res = await http.put(Uri.parse('$mainUrl$combinationUrl/PutCombinationStatus'), headers: {
    "content-type":"application/json",
    "accept":"application/json",
    "Authorization":"Bearer $key"
  }, body: json.encode(body));
  if(res.statusCode == 200) return 'Updated';
  else if(res.statusCode == 204) return 'Updated';
  else return res.statusCode.toString();
}
putAppuserInfo(String key, Appuser user)async{
  var body = {
    'idUser': user.idUser,
    'name': user.name,
    'email' : user.email,
    'isAdmin': user.isAdmin,
    'height': user.height,
    'collar': user.collar,
    'chest': user.chest,
    'sleeve': user.sleeve,
    'waist': user.waist,
    'insideLeg': user.insideLeg,
  };
  var res = await http.put(Uri.parse('$mainUrl$userPath/${user.idUser}'), headers: {
    "content-type":"application/json",
    "accept":"application/json",
    "Authorization":"Bearer $key"
  }, body: json.encode(body));
  print('msgl putCombinationStatus: ${res.statusCode.toString()}');
  if(res.statusCode == 200) return 'Updated';
  else if(res.statusCode == 204) return 'Updated';
  else return res.statusCode.toString();
}
putElementInfo(String key, MyElement element)async{
  var body = {
    'idElement': element.idElement,
    'nameElement': element.nameElement,
    'idCategory': element.idCategory,
    'price': element.price,
    'note': element.note,
    'picPath': element.picPath,
    'idUser': element.idUser,
  };
  var res = await http.put(Uri.parse('$mainUrl$elementDetailUrl/${element.idElement}'), headers: {
    "content-type":"application/json",
    "accept":"application/json",
    "Authorization":"Bearer $key"
  }, body: json.encode(body));
  if(res.statusCode == 200) return 'Updated';
  else if(res.statusCode == 204) return 'Updated';
  else return res.statusCode.toString();
}
putCombinationInfo(String key, Combination combination)async{
  var body = {
    'idCombination': combination.idCombination,
    'nameCombination': combination.nameCombination,
    'note': combination.note,
    'idOccasion': combination.idOccasion,
    'idUser': combination.idUser,
    'isPosted': combination.isPosted,
  };
  var res = await http.put(Uri.parse('$mainUrl$combinationUrl/${combination.idCombination}'), headers: {
    "content-type":"application/json",
    "accept":"application/json",
    "Authorization":"Bearer $key"
  }, body: json.encode(body));
  if(res.statusCode == 200) return 'Updated';
  else if(res.statusCode == 204) return 'Updated';
  else return res.statusCode.toString();
}




GetRatingByUserAndCombination(String key, String idUser, int idCombination) async{
  final response = await http.get(Uri.parse('$mainUrl$ratingUrl/GetRatingByUserAndCombination/$idUser/$idCombination'), headers: {
    'Authorization': 'Bearer $key'
  });
  if (response.statusCode == 200){
    return response.body;
  }
  else if (response.statusCode == 404){
    return 4;
  }
  else{
    throw Exception('Cannot get rating');
  }
}
getRatingByCombination(String key, int idCombination) async{
  final response = await http.get(Uri.parse('$mainUrl$ratingUrl/GetRatingByCombination/$idCombination'), headers: {
    'Authorization': 'Bearer $key'
  });
  if (response.statusCode == 200){
    return response.body;
  }
  else if (response.statusCode == 404){
    return 4;
  }
  else{
    throw Exception('Cannot get rating');
  }
}

deleteCombination(String key, int idCombination) async{
  var res = await http.delete(Uri.parse('$mainUrl$combinationUrl/$idCombination'), headers: {
    "content-type":"application/json",
    "accept":"application/json",
    "Authorization":"Bearer $key"
  });
  if(res.statusCode == 200) return 'Deleted';
  else if(res.statusCode == 204) return 'Deleted';
  else return res.statusCode.toString();
}
deleteElement(String key, int idElement) async{
  var res = await http.delete(Uri.parse('$mainUrl$elementDetailUrl/$idElement'), headers: {
    "content-type":"application/json",
    "accept":"application/json",
    "Authorization":"Bearer $key"
  });
  if(res.statusCode == 200) return 'Deleted';
  else if(res.statusCode == 204) return 'Deleted';
  else return res.statusCode.toString();
}














