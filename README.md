# Custom Pronouns
## The `P` Global Class
Holds all the pronouns variables and the randomization functions.

### SIGNALS
#### `curr_pronoun(pronoun)`
Emits to set the current pronoun.

#### `curr_verb()`
Emits to set the proper verb to the current pronoun.

#### `set_sentence`
Emits once the verbs button is clicked. Sets all the sentence examples for the pronouns.

#### `loaded_pronouns`
Emits once the pronouns have been loaded.

#### `saved_pronouns`
Emits once the pronouns have been saved.

### VARIANTS
#### `var player_pronouns: Dictionary`
Stores all the pronouns and the pronouns correct verbs.

#### `var default_pronouns: Dicitionary`
The default pronouns, add in all the default pronouns here.
They will automatically be added as a button.

## SCRIPTS

## The `pronouns_setup.gd`
Contains all the logic for setting up the pronouns with the UI.

## The `example_sentence.gd`
Contains all the logic for setting up the verbs for all the pronoun(s) with the UI.
