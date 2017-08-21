
import java.util.ArrayList;

public class Generics {

	public static String method1() {
		ArrayList l = new ArrayList();
		l.add("Ciao");
		return (String)l.get(0);
	}

	public static String method2() {
		ArrayList<String> l = new ArrayList<String>();
		l.add("Ciao");
		return l.get(0);
	}

	public static void main(String[] args) {
		System.out.println(method1());
		System.out.println(method2());
	}
}
