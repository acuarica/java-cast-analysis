
public class Simple {

    public static String method1() {
        Object o = "Ciao";
        return (String)o;
    }

    public static String method2() {
        System.out.println("method2");
        Object o = "Ciao";
        return (String)o;
    }

    public static void main(String[] args) {
        System.out.println(method1());
        System.out.println(method2());
    }
}
