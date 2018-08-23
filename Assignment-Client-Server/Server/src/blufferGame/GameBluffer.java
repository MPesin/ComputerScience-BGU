package blufferGame;

import gameFeatures.*;
import tokenizer.StringMessage;

import com.google.gson.Gson;
import com.google.gson.stream.JsonReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.concurrent.ConcurrentHashMap;

//describe the game object
public class GameBluffer extends Game<StringMessage>{

	private ConcurrentHashMap<Question, ArrayList<Option>> QA;
	private Question currQuestion;
	private LinkedList<Player<StringMessage>> members;
	private Iterator<Question> Qit;
	private int countChoices;

	public GameBluffer(Room <StringMessage> room){
		super("BLUFFER", room);
		QA = new ConcurrentHashMap<Question, ArrayList<Option>>();
		members = logic.getRoomMembers(room);
		countChoices = 0;
		initJason();
	}

	private void initJason(){
		Gson gson = new Gson();
		try {
			JsonReader reader = new JsonReader(new FileReader("bluffer.json"));
			QuestFile obj = gson.fromJson(reader, QuestFile.class);
			reader.close();
			ArrayList<Question> q = obj.getQuestions();
			Collections.shuffle(q);
			int count = 0;
			for (Question i : q){
				if (count>=3)
					break;
				QA.put(i, new ArrayList<Option>());
				QA.get(i).add(new Option(i.getRealAnswer(), null));
				count++;
			}

		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public synchronized void startPlay(){
		Qit = QA.keySet().iterator();
		continuePlay();
	}

	public void continuePlay(){
		if(Qit.hasNext()){
			this.currQuestion = Qit.next();
			
			for (Player<StringMessage> p : members)
				askTxt(p, currQuestion.getText());
			System.out.println("Waiting for all players to send an option. This could take a while...");
		}
		else 
			endPlay();
	}

	@Override
	public synchronized void getTxt(Player<StringMessage> currentPlayer, String option) {
		Option opt = new Option (option, currentPlayer);
		addOption(currQuestion, opt);
		System.out.println("Waiting for all players to answer. This could take a while...");
		if(members.size() == (QA.get(currQuestion).size()-1)){
			Collections.shuffle(QA.get(currQuestion));
			logic.sendRoomMessageGame(room, printOptions(QA.get(currQuestion)));
		} else
			currentPlayer.sendUserMsg(new StringMessage("Waiting for other players..."));
	}

	@Override
	public synchronized void getChoises(Player<StringMessage> currentPlayer, String choice) {
		ArrayList<Option> options = QA.get(currQuestion);
		int ans = -1;
		try{
			ans = Integer.parseInt(choice);
		} catch (NumberFormatException e){
			currentPlayer.sendUserMsgGame(new StringMessage("Please enter a valid Integer"+"\n"));
		}

		if (ans != -1 && ans<options.size()){
			countChoices++;
			if (options.get(ans).player == null){
				currentPlayer.sendUserMsgGame(new StringMessage("You are Correct! You get +10 pts"+"\n"));
				currentPlayer.addPoints(10);
			} else {
				options.get(ans).player.addPoints(5);
				options.get(ans).player.sendUserMsgGame(new StringMessage("Congrats! Somebody chose your Answer! You get +5 pts"+"\n"));
			}
			if (countChoices == members.size()){
				countChoices =0;
				logic.sendRoomMessageGame(room, "The correct answer is: "+currQuestion.getRealAnswer()+"\n");
				logic.sendRoomMessageGame(room, printResults(members));
				continuePlay();
			} else
				currentPlayer.sendUserMsg(new StringMessage("Waiting for other players..."));
		}
		else
			currentPlayer.sendUserMsgGame(new StringMessage("Please choose legal number between 0 to "+(options.size()-1)+"\n"));
	}

	private String printOptions(ArrayList<Option> list){
		String ans = "";
		int i = 0;
		for (Option o : list){
			ans = ans + i +'.'+o.option+"  ";
			i++;
		}
		return ans;
	}

	private String printResults(LinkedList<Player<StringMessage>> list){
		String ans = "";
		for (Player<StringMessage> p : list){
			ans = ans + p.getName()+" : "+p.getScore()+" pts,  ";
		}
		return "Summary: "+ans+"\n";
	}

	public synchronized void addOption(Question q ,Option op){
		QA.get(q).add(op);
	}

	public void endPlay(){
		logic.sendRoomMessageGame(room, "Game over. Thank you for playing.\n You can now join other room or start a new game.");
		room.changeInGameStatus();
	}

}
