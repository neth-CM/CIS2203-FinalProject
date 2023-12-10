# Final Project Instructions

By pair, maximum of 3

Create a Mobile Application using Flutter that connects to an API of your making/choice. The application should be able to perform CRUD operations. This project is expected to be done only for Android, to avoid any complications in configuring for other platforms.

Functional Requirements:

Login
Sign in with Email and Password
Sign in with Provider (whichever you prefer, that Firebase provides)
Logout
Registration Page
Sign up with Email and Password
Dashboard, and any other pages that are fit for your application.
CRUD operations
For the API, you can use an existing one from your old projects/subjects, or make a new one (no backend framework restrictions). Or you can utilize an open-source API.

A user can only have 1 account. For example, a user that signs in using Google provider must also be able to sign in with email/password using the same account credentials. Below is a crude implementation of the expected functionality:

To ensure that a user logging in with email/password and Google provider have the same account, you need to link the authentication providers. Here's how you can do it:

Sign in the user using any authentication provider which returns a UserCredential.
- Check if another account has the same email address.
- If an account with the same email address exists, link the sign-in methods.
(See Image on Canvas)

This one is how it can be done the other way around. Logging in first using email/password
(See Image on Canvas)

Linking can also be done on registration:
(See Image on Canvas)

Note that the snippets provided are not necessarily the exact implementations of the desired feature. You can also follow the same logic when implementing it in the backend. You need to read through the documentation of FlutterFire for your reference, https://firebase.flutter.dev/docs/overviewLinks to an external site. 

Lastly, I have decided to shorten the documentation requirements. You only need to submit a documentation with the following contents, and the format is up to you:
- Explanation of the application, what are its features

- A flowchart of the application (frontend and backend)

- Screenshots

- Test Accounts that i can use for checking the app.

- APK file of the android application (discussion to follow.)

- A link to the github repository of your code.
