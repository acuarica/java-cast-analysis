
public class Cond {

    public static String method(boolean arg) {
        Object s = "Ciao";
        Object t = "Hola";
        return (String)(arg ? s : t);
    }

}
