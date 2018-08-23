package bgu.spl.app;

public class Receipt {

	private String fSeller;
	private String fCustomer;
	private String fShoeType;
	private Boolean fDiscount;
	private int fIssuedTick;
	private int fRequestTick;
	private int fAmountSold;
	
	public String getSeller() {
		return fSeller;
	}
	public void setSeller(String fSeller) {
		this.fSeller = fSeller;
	}
	
	public String getCustomer() {
		return fCustomer;
	}
	public void setCustomer(String fCustomer) {
		this.fCustomer = fCustomer;
	}
	
	public String getShoeType() {
		return fShoeType;
	}
	public void setShoeType(String fShoeType) {
		this.fShoeType = fShoeType;
	}
	
	public Boolean getDiscount() {
		return fDiscount;
	}
	public void setDiscount(Boolean fDiscount) {
		this.fDiscount = fDiscount;
	}
	
	public int getIssuedTick() {
		return fIssuedTick;
	}
	public void setIssuedTick(int fIssuedTick) {
		this.fIssuedTick = fIssuedTick;
	}
	
	public int getRequestTick() {
		return fRequestTick;
	}
	public void setRequestTick(int fRequestTick) {
		this.fRequestTick = fRequestTick;
	}
	
	public int getAmountSold() {
		return fAmountSold;
	}
	public void setAmountSold(int fAmountSold) {
		this.fAmountSold = fAmountSold;
	}
	
	
}
