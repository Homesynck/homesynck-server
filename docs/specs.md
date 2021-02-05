# Requests Specifications

## Authentication service
Conversation on this service is done with TCP and secured with SSL (no client cert. required).

### registerphone
Lets you register a phone number

- in `registerphone [Options:Json]`
  - `"phone_number":<phone_number>` Phone number you want to register

*examples:*
```
registerphone {"phone_number":"0183629183"}
```

- out success `ok` A register SMS was sent to verify this phone number
- out failure `nop <reason>`
  - `syntax <arg,>` Syntax error on comma-separated arguments args
  - `unavailable` Phone registering service is unavailable
  - `invalidnumber` Invalid phone number

*examples:*
```
ok
```
```
nop syntax phone_number
```
```
nop unavailable
```

### validatephone
Lets you validate your phone number with the code sent by sms.

- in `validatephone [Options:Json]`
  - `"phone_number":<phone_number>` Phone number used in register phase
  - `"code":<code>` Validation code received by SMS

*examples:*
```
validatephone {"phone_number":"0183629183", "code":"12345"}
```

- out success `ok <registration_token>` A registration token that enables you to create 1 account
- out failure `nop <reason>`
  - `syntax <arg,>` Syntax error on comma-separated arguments args
  - `unavailable` Phone validation service is unavailable
  - `invalid` Eaither the phone number or the code is not registered

### register
Lets you create an account with mandatory unique phone number validation.

- in `register [Options:Json]`
  - `"username":<username>` Username between 3 and 32 chars.
  - `"password":<password>` Password. Should be between 10 and 64 chars. It will be hashed in our database.
  - `"registration_token":<registration_token>` A registration token that you obtain after the phone validation phase.
  - *optional* `"email":<email_address>` A valid email address. It will be hashed and it will be linked to your user account in our database for email recovery.

*examples:*
```
register {"username":"jane_doe", "registration_token": "8EZe08s2Upml98o2K3b12a31", "password":"prettyStrongPass"}
```
```
register {"username":"jane_doe", "password":"prettyStrongPass", "email":"jane@doe-company.com"}
```

- out success `ok` A verification email was sent if email given.
- out failure `nop <reason>`
  - `syntax <arg,>` Syntax error on comma-separated arguments args
  - `unavailable` Register service is unavailable
  - `invalidusername` Invalid username
  - `usernametaken` Username already taken
  - `invalid` Either password, registration token

If you didn't get the validation SMS or the validation email after some time and still had no error, you can retry this since the account was not yet fully validated.

### login
Lets you login with regular credentials. Gives you a temporary connection token on success that enables you to login to other services.

- in `login [Options:Json]`
  - `"username":<username>` Either an username or an email address
  - `"password":<password>` Password

*examples:*
```
login {"username":"jane_doe", "password":"prettyStrongPass"}
```
```
register {"username":"jane@doe-company.com", "password":"prettyStrongPass"}
```

- out success `ok <token> <expiration_date>`
- out failure `nop <reason>`
  - `syntax <args,>` Syntax error on comma-separated arguments args
  - `unavailable` Login service is unavailable
  - `credentials` Could not login successfully because of either:
    - username or email is not known
    - username or email is known but password is wrong
  - `unverifiednumber` Account was found but phone number not validated by the owner yet
  - `unverifiedemail` Account was found but email was not validated by the owner yet
