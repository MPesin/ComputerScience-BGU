package protocol;

/**
* A protocol that describes the behaviour of the server .
*
* @param <T> type of message that the protocol handles .
*/
public interface ServerProtocol <T> {
/**
* Processes a message
*
* @param msg the message to process
* @param callback an instance of ProtocolCallback unique to the
connection from which msg originated .
*/
void processMessage (T msg , ProtocolCallback callback );
/**
* Determine whether the given message is the termination message .
*
* @param msg the message to examine
* @return true if the message is the termination message , false
otherwise
*/
boolean isEnd (T msg);
}