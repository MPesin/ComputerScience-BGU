package tokenizer;

public class StringMessage {
	private final String message;
	private String[] allMsg; 
	
	public StringMessage(String message){
		if (message != null)
			this.message = message;
		else
			this.message = "";
		this.allMsg = message.split(" ");
	}

	public String getMessage(){
		return message;
	}
	
	public String printString(){
		String ans = "[";
		for (String s : allMsg)
			ans = ans+" "+'"'+s+'"'+" ";
		return ans+"]";
	}

	public String getCommand(){
		return allMsg[0];
	}

	public String getParam(){
		if (allMsg.length>1){
			String ans = "";
			for(int i = 1; i< allMsg.length-1;i++)
				ans = ans + allMsg[i]+" ";
			ans=ans+allMsg[allMsg.length-1];
			return ans;
		}
		else
			return "";
	}

	public String toString() {
		return message;
	}

	public boolean equals(String other) {
		return message.equals(other);
	}

}
