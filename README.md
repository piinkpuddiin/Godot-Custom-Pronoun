# Custom Pronouns
# The `P` Global Class
Holds all the pronouns variables and the randomization functions.

## Signals
#### - `curr_pronoun(pronoun)`
Emits to set the current pronoun.

#### - `curr_verb()`
Emits to set the proper verb to the current pronoun.

#### - `set_sentence`
Emits once the verbs button is clicked. Sets all the sentence examples for the pronouns.

#### - `loaded_pronouns`
Emits once the pronouns have been loaded.

#### - `saved_pronouns`
Emits once the pronouns have been saved.

## Variants
#### - `player_pronouns: Dictionary`
Stores all the pronouns and the pronouns correct verbs.

#### - `default_pronouns: Dicitionary`
The default pronouns, add in all the default pronouns here. Every new key and their values will automatically be added as a button.

#### - `custom_pronouns: Dicitionary`
Temporarily holds the inputed pronouns.

#### - `current_pronoun: String`
The current result of the randomized pronoun from the randomized functions.

## Functions

## Scripts

#### The `pronouns_setup.gd`
Contains all the logic for setting up the pronouns with the UI.

#### The `example_sentence.gd`
Contains all the logic for setting up the verbs for all the pronoun(s) with the UI.
