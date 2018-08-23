package blufferGame;

import gameFeatures.Player;

public class Question {
	private String questionText;
	private String realAnswer;

	public Question(String text, String answer){
		this.questionText = text;
		this.realAnswer = answer;
	}

	class Answer{
		private Option answer;

		public Answer(String option, Player player){
			answer = new Option(option, player);
		}

		/**
		 * @return the answer
		 */
		public Option getAnswer() {
			return answer;
		}		
	}

	/**
	 * @return the text
	 */
	public String getText() {
		return questionText;
	}

	/**
	 * @return the realAnswer
	 */
	public String getRealAnswer() {
		return realAnswer;
	}
}
