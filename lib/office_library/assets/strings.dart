class UriStrings {
  static const address = 'https://localhost:44319';

  static const getBooksByReaderUri = '$address/api/Book/GetByReader/';
  static const getOneUserByEmailUri = '$address/api/User/GetByEmail/';
  static const takeBookUri = '$address/api/UserBookHistory/RegisterBookTaking';
  static const returnBookUri = '$address/api/UserBookHistory/RegisterBookReturning';

  static const getUri = '$address/api/[controllerName]/GetAll';
  static const getOneByIdUri = '$address/api/[controllerName]/GetOne/';
  static const postUri = '$address/api/[controllerName]/Post';
  static const putByIdUri = '$address/api/[controllerName]/Put';
  static const deleteByIdUri = '$address/api/[controllerName]/Delete';

  static const registerUri = '$address/AccountApi/Register';
  static const loginUri = '$address/AccountApi/Login';
  static const logoutUri = '$address/AccountApi/LogOff';

  static addControllerName(String uri, String controllerName) { return uri.replaceAll('[controllerName]', controllerName); }
}

class MyStrings {
  static const emailLabel = 'Адрес электронной почты';
  static const passwordLabel = 'Пароль';
  static const formValidatorLabel = 'Введите логин и пароль'; 
  static const loginButtonLabel = 'Войти';
  static const registerButtonLabel = 'Зарегистрироваться';
}

class MyExceptions {
  static const registerException = 'Регистрация не удалась';
  static const loginException = 'Авторизация не удалась';
  static const logoutException = 'Выход из системы не удался';
}

class UserJsonKeys {
  static const id = 'Id';
  static const email = 'Email';
  static const password = 'Password';
  static const phoneNumber = 'PhoneNumber';
  static const userName = 'UserName';
  static const role = 'Role';
  static const registrationDate = 'RegistrationDate';
  static const books = 'Books';
  static const photoBase64 = 'PhotoBase64';
}

class BookJsonKeys {
  static const id = 'Id';
  static const author = 'Author';
  static const title = 'Title';
  static const genre = 'Genre';
  static const year = 'Year';
  static const readers = 'Readers';
  static const isTaken = 'IsTaken';
  static const dateOfReturning = 'DateOfReturning';
  static const takingCount = 'TakingCount';
  static const currentReader = 'CurrentReader';
  static const photoBase64 = 'PhotoBase64';
}

class GenreJsonKeys {
  static const id = 'Id';
  static const name = 'Name';
  static const description = 'Description';
}

class AuthorJsonKeys {
  static const id = 'Id';
  static const name = 'Name';
  static const lifetime = 'LifeTime';
  static const country = 'Country';
}