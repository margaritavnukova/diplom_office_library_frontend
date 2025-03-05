class UriStrings {
  static final address = 'localhost:44319';

  static final getBooksUri = 'https://$address/api/Book';
  static final getBooksByReaderUri = 'https://$address/api/Book/GetBooksByReader?reader=';

  static final getOneUserByEmailUri = 'https://$address/api/User/GetUserByEmail?email=';

  static final registerUri = 'https://$address/Account/Register';
  static final loginUri = 'https://$address/Account/Login';
  static final logoutUri = 'https://$address/Account/LogOff';
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
  static const email = 'Email';
  static const password = 'Password';
  static const fullName = 'FullName';
  static const books = 'Books';
}

class BookJsonKeys {
  static const id = 'Id';
  static const author = 'Author';
  static const title = 'Title';
  static const genre = 'Genre';
  static const year = 'Year';
  static const readers = 'Readers';
}