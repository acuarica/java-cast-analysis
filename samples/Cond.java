
public class Cond {

    public static String method1(boolean arg) {
        Object s = "Ciao";
        Object t = "Hola";
        return (String)(arg ? s : t);
    }

    public static Number method2(boolean arg) {
        Object s = 4;
        Object t = 2.3;
        return arg ? (Integer)s : (Double)t;
    }

    public static void main(String[] args) {
        System.out.println(method1(true));
        System.out.println(method2(false));
    }

}
