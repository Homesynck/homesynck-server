# Requests Manual 

## Authentication service
Conversation on this service is done with TCP and secured with SSL (no client cert. required).

### login
Lets you login with regular credentials. Gives you a temporary connection token on success that enables you to login to other services.

- in `login [OPTIONS]`
  - `u:<username>` Either an username or an email address
  - `p:<password>` Password
- out success `ok <token> <expiration_date>`
- out failure `nop <reason>`
  - `syntax:<args,>` Syntax error on comma-separated arguments args
  - `unavailable` Login service is unavailable
  - `credentials` Could not login successfully because of either:
    - username or email is not known
    - username or email is known but password is wrong
  - `unverifiednumber` Account was found but phone number not validated by the owner yet
  - `unverifiedemail` Account was found but email was not validated by the owner yet

### register
Lets you create an account with mandatory unique phone number validation.

- in `register [OPTIONS]`
  - `u:<username>` Username between 3 and 32 chars.
  - `p:<password>` Password. Should be between 10 and 64 chars. It will be hashed in our database.
  - `n:<phone_number>` A valid phone number, only used to limit spam. It will be hashed and it will never be linked to any user account in our database.
  - *optional* `e:<email_address>` A valid email address. It will be hashed and it will be linked to your user account in our database for email recovery.
- out success `ok` A validation SMS was sent to the phone number and a verification email was sent if email given.
- out failure `nop <reason>`
  - `syntax:<arg,>` Syntax error on comma-separated arguments args
  - `unavailable` Register service is unavailable
  - `invalidusername` Invalid username
  - `usernametaken` Username already taken
  - `baddata` Either password, phone number

If you didn't get the validation SMS or the validation email after some time and still had no error, you can retry this since the account was not yet fully validated.

### validatephone
Lets you validate your phone number with the code sent by sms.

- `validatephone [OPTIONS]`
  - `p:<phone_number>` Phone number used in register phase
  - `c:<code>` Validation code received by SMS
- out success `ok`
- out failure `nop <reason>`
  - `syntax:<arg,>` Syntax error on comma-separated arguments args
  - `unavailable` Phone validation service is unavailable
  - `badcode` Code is wrong
  - `invalidnumber` Invalid phone number because of either:
    - invalid syntax
    - unknown phone number