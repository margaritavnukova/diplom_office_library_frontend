import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'strings.dart';

class Auth {
    late Dio dio;
    late PersistCookieJar cookieJar;

    Auth() {
        dio = Dio();
        _setupCookieJar();
    }

    Future<void> _setupCookieJar() async {
        final appDocDir = await getApplicationDocumentsDirectory();
        final cookiePath = join(appDocDir.path, 'cookies');
        cookieJar = PersistCookieJar(storage: FileStorage(cookiePath));
        dio.interceptors.add(CookieManager(cookieJar));
    }

    Future<void> login(String email, String password) async {
        try {
            final response = await dio.post(
                UriStrings.loginUri,
                data: {UserJsonKeys.email: email, UserJsonKeys.password: password},
            );

            if (response.statusCode == 200) {
                print('login success');
            }
            else {
                throw Exception(MyExceptions.loginException);
            }
        }
        catch (e) {
            throw Exception('${MyExceptions.loginException}: $e'); 
        }
    }

    Future<void> register(String email, String password) async {
        try {
            final response = await dio.post(
                UriStrings.registerUri,
                data: {UserJsonKeys.email: email, UserJsonKeys.password: password},
            );

            if (response.statusCode == 200) {
                print('login success');
            }
            else {
                throw Exception(MyExceptions.loginException);
            }
        }
        catch(e) {
            throw Exception('${MyExceptions.loginException}: $e'); 
        }
    }

    Future<void> logout() async{
        try {
            await dio.post(UriStrings.logoutUri);
            await cookieJar.deleteAll();
        }
        catch(e) {
            throw Exception('${MyExceptions.logoutException}: $e'); 
        }
    }
}