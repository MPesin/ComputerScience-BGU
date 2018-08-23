package tokenizer;

public interface TokenizerFactory<T> {
	
	public FixedSeparatorMessageTokenizer<T> create();
}
