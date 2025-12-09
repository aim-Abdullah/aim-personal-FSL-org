public class AppearException extends Exception {
	public String AppearErrorMsg = null;
	public AppearException(string message,string appearMsg){
		AppearErrorMsg = appearMsg;
	}
}