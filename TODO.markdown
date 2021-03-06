This is a list of potential changes for OpenBrewComp, in no particular order.

* I18n/L10n work.
* Resolve CSS issues with the flight management pages in IE.
* Use role_requirement plugin instead of our hand-rolled roles+rights. (Not
  sure how this would work with the entrant, entry, and judge controllers.)
* Provide a way to handle duplicate records, specifically cases where an
  entrant registers under two similar, but slightly different, names.
* Add support for assigned scores, i.e, the combined score assigned by the
  judge panel, instead of automatically generated average scores (though judge
  panels seem to compute an average score for the assigned score anyway).
* Include scores in the flight show panel.
* Improved handling of judge signup. As currently written, BJCP IDs must be
  unique, but if a judge attempts to sign up without using the registration
  key sent in the email invite, they're prevented from doing so because they're
  already listed in the judge table.
* Also need to investigate the ramifications of requiring more than 3 bottles
  for a category, though such a requirement is unlikely which probably puts this
  item at a very low priority.
