# Invoice Beast - A Javascript-less, highly interactive demo

Invoice Beast is highly interactive invoice editing user interface
that is entire server rendered. It is simular to Xero's invoice
editing interface.

It deviate from the standard Rails "form" edit/submit flow by allowing
a user to make changes to multiple related models, and see the result
of those changes in real time without submitting the form. The user can
then either dismiss those changes, or persist them to the database.

It makes use of StimulusReflex to communicate via Websockets.
The user interface is as responsive, or faster than any SPA.

- Lines of Javascript: Zero.
- JSON API: No.
- GraphQL: No.
- React: No.
- Sanity: Maintained.

## Video Demo

[![](https://img.youtube.com/vi/KHZuMW0IZTY/maxresdefault.jpg)](https://youtu.be/KHZuMW0IZTY)

## Features
- Dynamic form validation. Form is initially validated when the form is submitted. Then, errors are cleared as they are resolved, without requiring a form resubmission.
- Allow adding/removing rows, with automatic recalculation
- Line item total is automatically calculated and updated after each change
- Amounts summary is automatically calculated and updated after each change
-
## Technologies used (in order of importance):

- [Stimulus Reflex](https://docs.stimulusreflex.com/)
- [Universal ID](https://github.com/hopsoft/universalid)
- [Turbo](https://turbo.hotwired.dev/)

## Inspiration:

- [Beast Mode](https://beastmode.leastbad.com/)
- [Xero](https://xero.com)'s invoice user interface
