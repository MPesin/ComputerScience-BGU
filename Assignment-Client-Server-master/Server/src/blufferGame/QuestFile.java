package blufferGame;

import java.util.ArrayList;

public class QuestFile {

	private ArrayList<Question> questions;

	/**
	 * Build the class the JSON should read from
	 * @return the questions
	 */
	public ArrayList<Question> getQuestions() {
		return questions;
	}

	class text{
		private String questionText;

		/**
		 * @return the text
		 */
		public String getText() {
			return questionText;
		}
	}

	class answer{
		private String realAnswer;

		/**
		 * @return the realAnswer
		 */
		public String getRealAnswer() {
			return realAnswer;
		}

	}

}
