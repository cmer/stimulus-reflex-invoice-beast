# Stimulus Reflex Demo - Invoice Beast

This is a demo of a highly dynamic invoice editing user interface
that is entire server rendered. It is simular to Xero's invoice
editing interface.

It deviate from the standard Rails "form" edit/submit flow by allowing
a user to make changes to multiple related models, and see the result
of those changes in real time without submitting the form. The user can
then either dismiss those changes, or persist them to the database.

It makes heavy use of StimulusReflex to communicate via websockets.
The user interface is as responsive, or faster than any SPA.

- Lines of Javascript: Zero.
- JSON API: No.
- GraphQL: No.
- React: No.
- Sanity: Maintained.

Technologies used (in order of importance):

- [Stimulus Reflex](https://docs.stimulusreflex.com/)
- [CableReady](https://cableready.stimulusreflex.com/)
- [AllFutures](https://allfutures.leastbad.com/)
- [Rails 7](https://rubyonrails.org/)
- [Turbo](https://turbo.hotwired.dev/)
- [ViewComponent](https://viewcomponent.org/)

Inspiration:

- [Beast Mode](https://beastmode.leastbad.com/)
- [Xero](https://xero.com)'s invoice user interface
