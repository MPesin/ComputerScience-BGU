package bgu.spl.mics.impl;

import bgu.spl.mics.Message;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.CopyOnWriteArrayList;

public class LastIndexArray {
	
	private int fIndex;
	public CopyOnWriteArrayList<LinkedBlockingQueue<Message>> array;
	
	public int getIndex(){
		return fIndex;
	}
	
	public LastIndexArray(){
		 fIndex = 0;
		 array = new CopyOnWriteArrayList<LinkedBlockingQueue<Message>>();
	}
	
	public void updateI(){
		if (fIndex<array.size())
			fIndex++;
		else 
			fIndex=0;
	}
}
