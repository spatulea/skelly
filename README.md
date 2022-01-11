# skelly

Tag along as skelly evolves from template to messaging app.

## Goals
  - Create a thread-based messaging app where users can create, share & join messaging threads and communicate with uther users in those threads.
  - Develop the app following guidelines set by the Flutter team's skeleton template:
    - Minimal use of 3rd party widgets
    - Use ChangeNotifier+AnimatedBuilder for "state management" (this goal may change as the app evolves if the method proves too awkward)
    - Use a Service-Controller-View pattern, a derivation of the common Model-View-Controller pattern
    - Achieve good test coverage
    - Maintain good code organization with widgets, methods and files to avoid spaghetti architecture as much as possible
  - Create a unique UI experience that is differentiated from either Material or Cupertino styles
  - Use Firebase for authentication and database, but with minimal backend development
    - Firestore for user preferences and threads
    - Auth for anonymous-only user authentication
    - Use Firestore security rules to manage access control and data validation (no cloud functions)
  - Submit (and be accepted by) both app stores
    - Include reporting and blocking/unsubscribe features as required by app stores
  - Last but perhaps most important: **learn**