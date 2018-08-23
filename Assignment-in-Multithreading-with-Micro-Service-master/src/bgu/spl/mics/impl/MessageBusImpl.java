package bgu.spl.mics.impl;

import bgu.spl.mics.Broadcast;
import bgu.spl.mics.Message;
import bgu.spl.mics.MessageBus;
import bgu.spl.mics.MicroService;
import bgu.spl.mics.Request;
import bgu.spl.mics.RequestCompleted;

import java.util.ListIterator;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.ConcurrentHashMap;
import java.util.ArrayList;
import java.util.concurrent.ConcurrentLinkedQueue;
import java.util.concurrent.CopyOnWriteArrayList;

public class MessageBusImpl implements MessageBus {

	private ConcurrentHashMap<Class<? extends Request>,LastIndexArray> fRequest;
	private ConcurrentHashMap<Class<? extends Broadcast>,CopyOnWriteArrayList<LinkedBlockingQueue>> fBroadcast;
	private ConcurrentHashMap<MicroService,LinkedBlockingQueue<Message>> fMSQueue;

	private static class SingletonHolder {
		private static MessageBusImpl instance = new MessageBusImpl();
	}
	
	private MessageBusImpl(){
		fRequest = new ConcurrentHashMap<Class<? extends Request>,LastIndexArray>();
		fBroadcast = new ConcurrentHashMap<Class<? extends Broadcast>,CopyOnWriteArrayList<LinkedBlockingQueue>>();
		fMSQueue = new ConcurrentHashMap<MicroService,LinkedBlockingQueue<Message>>();
	}
	
	public static MessageBusImpl getInstance() {
		return SingletonHolder.instance;
	}

	public void subscribeRequest(Class<? extends Request> type, MicroService m) {
		LinkedBlockingQueue msgQ = fMSQueue.get(m); //point to this
		if (fRequest.contains(type.getClass()))
			fRequest.get(type.getClass()).array.add(msgQ);	
		else{
			fRequest.put(type,new LastIndexArray());
			fRequest.get(type).array.add(msgQ);
		}
	}

	@Override
	public void subscribeBroadcast(Class<? extends Broadcast> type, MicroService m) {
		LinkedBlockingQueue msgQ = fMSQueue.get(m); //point to this
		if (fBroadcast.contains(type.getClass()))
			fBroadcast.get(type.getClass()).add(msgQ);	
		else{
			fBroadcast.put(type,new CopyOnWriteArrayList<LinkedBlockingQueue>());
			fBroadcast.get(type).add(msgQ);
		}
	}

	@Override
	public <T> void complete(Request<T> r, T result) {
		RequestCompleted<T> req = new RequestCompleted<T>(r, result);
		for(int i=0;i<fRequest.get(req).array.size();i++)
			try {
				fRequest.get(req).array.get(i).put(req);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
	}

	@Override
	public void sendBroadcast(Broadcast b) {
		CopyOnWriteArrayList<LinkedBlockingQueue> brdList = fBroadcast.get(b.getClass());
		for (LinkedBlockingQueue i : brdList) //Iterator
			i.add(b);
	}

	@Override
	public boolean sendRequest(Request<?> r, MicroService requester) {
		if (fMSQueue.contains(r.getClass())){
			LastIndexArray reqList = fRequest.get(r);
			int i = reqList.getIndex();
			reqList.array.get(i).add(r);
			reqList.updateI();
			return true;
		}
		return false;
	}

	public void register(MicroService m) {
		if (fMSQueue.containsKey(m))
			return;
		else
			fMSQueue.put(m, new LinkedBlockingQueue<Message>());
	}

	public void unregister(MicroService m) {
		while (!fMSQueue.get(m).isEmpty()) //delete queue
			fMSQueue.get(m).poll(); 
		fMSQueue.remove(m);		//delete MicroService
	}

	@Override
	public Message awaitMessage(MicroService m) throws InterruptedException {
		if (fMSQueue.containsKey(m))
			return fMSQueue.get(m).take();
		else
			throw new IllegalStateException();
	}

}
