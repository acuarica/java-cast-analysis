
public class Simple {

    public static String method1() {
        return (String)"Ciao";
    }

    public static String method2() {
        Object o = "Ciao";
        return (String)o;
    }

    public static String method3() {
        System.out.println("method3");
        Object o = "Ciao";
        return (String)o;
    }

    public static void main(String[] args) {
        System.out.println(method1());
        System.out.println(method2());
        System.out.println(method3());
    }

}
