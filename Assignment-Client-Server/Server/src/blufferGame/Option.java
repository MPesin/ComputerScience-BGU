package blufferGame;

import gameFeatures.Player;
import tokenizer.StringMessage;

/**
 * Container to ease passing around a tuple of two objects. This object provides a sensible
 * implementation of equals(), returning true if equals() is true on each of the contained
 * objects.
 */
public class Option {
    public final String option;
    public final Player<StringMessage> player;

    /**
     * Constructor for a Pair.
     *
     * @param first the first object in the Pair
     * @param second the second object in the pair
     */
    public Option(String option, Player<StringMessage> player) {
        this.option = option;
        this.player = player;
    }

}