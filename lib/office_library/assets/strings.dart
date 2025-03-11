class UriStrings {
  static const address = 'https://localhost:44319';

  static const getBooksUri = '$address/api/Book/GetAll';
  static const getBooksByReaderUri = '$address/api/Book/GetByReader/';

  static const postBookUri = '$address/api/Book/Post';
  static const putBookUri = '$address/api/Book/Put/';
  static const deleteBookUri = '$address/api/Book/Delete/';

  static const getOneUserByEmailUri = '$address/api/User/GetByEmail/';

  static const registerUri = '$address/Account/Register';
  static const loginUri = '$address/Account/Login';
  static const logoutUri = '$address/Account/LogOff';
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
  static const phoneNumber = 'PhoneNumber';
  static const userName = 'UserName';
  static const role = 'Role';
  static const registrationDate = 'RegistrationDate';
  static const photo = 'PhotoBase64';
  static const books = 'Books';
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
}