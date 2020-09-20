# pokedex_app

## Instructions

● Use the public Pokedex API [https://pokeapi.co/](https://pokeapi.co/) to create a small mobile application using Flutter

● In your mobile application create the following views:
  - Onboard/welcome
  - Login
  - Home (displaying pokemon)
  - Details Screen (once a pokemon is selected)

● Include
  - Documentation on how to run the project locally
  
  clone repo `git clone https://github.com/quetool/pokedex_app.git`

  move to root project folder `cd {clone_path}`
  
  get packages `flutter pub get`
  
  run on iOS `flutter run` or, better, `flutter run --release`
  
  - Why do you chose the plugins used
  
  `http` for API request
  
  `rxdart` for a simply implementation of BLoC pattern
  
  `shimmer` for shimmering effect during loading Pokemon
  
  `cached_network_image` for caching Pokemon's images
  
  `pointycastle` for creating a secure password
  
  `sqflite` for implementing a dummy user login and storing it (more secure than SharedPreferences)
  
  `shared_preferences` for storing some flags
  
  `very_good_analysis` for static code analisys rules

Notes

● The onboarding/welcome should only be shown once and after logging into your account you should go straight to the home screen (do this locally, no back end is required).

● Although testing is not required at this point, your code should be structured in such a way that tests could be set up afterward.
