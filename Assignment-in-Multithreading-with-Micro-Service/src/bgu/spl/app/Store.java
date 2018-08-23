
package bgu.spl.app;
import java.util.HashMap;

public class Store{
	
	private HashMap fStock;
	
	public enum BuyResult{
		NOT_IN_STOCK,
		NOT_ON_DISCOUNT,
		REGULAR_PRICE,
		DISCOUNTED_PRICE;
	}
	
	public void load(ShoeStorageInfo[] storage){
		//initialize the array and add item from it to the store.
	}
	public BuyResult take(String shoeType , boolean onlyDiscount){
		return null;
	
		/*search in the data structure the wanted shoe, and return an enum message (and change data if needed)
		 search by name:
		if not found NOT_IN_STOCK,
		if found check onlyDiscount value,
			if true DISCOUNTED_PRICE
			else REGULAR_PRICE.
		*/
	}
	

}
