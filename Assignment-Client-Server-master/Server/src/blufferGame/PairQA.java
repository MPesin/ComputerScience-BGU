package blufferGame;

import java.util.Objects;

/**
 * Container to ease passing around a tuple of two objects. This object provides a sensible
 * implementation of equals(), returning true if equals() is true on each of the contained
 * objects.
 */
public class PairQA<Q, A> {
    public final Q question;
    public final A answers;

    /**
     * Constructor for a Pair.
     *
     * @param first the first object in the Pair
     * @param second the second object in the pair
     */
    public PairQA(Q question, A answers) {
        this.question = question;
        this.answers = answers;
    }

    /**
     * Checks the two objects for equality by delegating to their respective
     * {@link Object#equals(Object)} methods.
     *
     * @param o the {@link Pair} to which this one is to be checked for equality
     * @return true if the underlying objects of the Pair are both considered
     *         equal
     */
    @Override
    public boolean equals(Object o) {
        if (!(o instanceof PairQA)) {
            return false;
        }
        PairQA<?, ?> p = (PairQA<?, ?>) o;
        return Objects.equals(p.question, question) && Objects.equals(p.answers, answers);
    }
}