
# Java Cast Analysis

## Introduction

Java cast analysis in the wild.


## Preliminary considerations.

The analysis is being performed on Java bytecode.
This is why we need to take the following preliminary considerations.

### Generics vs. Non-generics

The following two Java snippets get compiled to the same bytecode instructions
as showed below.
Notice that the two snippets only differ in the use of Generics.

```java
ArrayList l = new ArrayList();
l.add("Ciao");
return (String)l.get(0);
```

```java
ArrayList<String> l = new ArrayList<String>();
l.add("Ciao");
return l.get(0);
```

```
 0: new           #2        // class java/util/ArrayList
 3: dup
 4: invokespecial #3        // Method java/util/ArrayList."<init>":()V
 7: astore_0
 8: aload_0
 9: ldc           #4        // String Ciao
11: invokevirtual #5        // Method java/util/ArrayList.add:(Ljava/lang/Object;)Z
14: pop
15: aload_0
16: iconst_0
17: invokevirtual #6        // Method java/util/ArrayList.get:(I)Ljava/lang/Object;
20: checkcast     #7        // class java/lang/String
23: areturn
```

### Upcast

The following snippet shows how even in the presence of a cast in the source code,
no actual `checkcast` is emitted.

```java
return (Object)"Foo";
```

```
0: ldc           #2                  // String Ciao
2: areturn
```

### Conditional Operator

Using the conditional operator produces the following bytecode.
Note the double use of `checkcast`.
This is possible given that the `checkcast` instruction is idempotent.

```java
Object s = "Ciao";
Object t = "Hola";
return (String)(arg ? s : t);
```

```
 0: ldc           #2                  // String Ciao
 2: astore_1
 3: ldc           #3                  // String Hola
 5: astore_2
 6: iload_0
 7: ifeq          14
10: aload_1
11: goto          15
14: aload_2
15: checkcast     #4                  // class java/lang/String
18: checkcast     #4                  // class java/lang/String
21: areturn
```


## Stats

Stats under the Maven repository.
These stats were collected using the Maven Bytecode Dataset.

| Description                         | Value         |
|-------------------------------------|---------------|
| `.jar`s size                        | 88GB          |
| Number of `.jar`                    | 134,156       |
| Number of `.jar` w/ classes         | 114,495       |
| Number of classes                   | 24,109,857    |
| Number of methods                   | 222,492,323   |
| Number of bytecode instructions     | 4,421,391,470 |
|-------------------------------------|---------------|
| Number of `checkcast` instructions  | 47,622,853    |
| Number of `instanceof` instructions | 8,411,639     |
| Number of methods w/ `checkcast`    | 27,019,431    |
| Number of methods w/ `instanceof`   | 5,267,707     |
|                                     |               |



185|invokeinterface|||9245608
43|aload_1|||7920092
44|aload_2|||2314158
180|getfield|||1441195
83|aastore|||1322684
42|aload_0|||1039779
45|aload_3|||974959
25|aload|||595487
182|invokevirtual|47021|scala/Option.get(Lorg/dom4j/Node;)V|526377
50|aaload|||516058
184|invokestatic|22857|java/lang/Enum.valueOf(I)Ljava/sql/SQLException;|441101
182|invokevirtual|47025|scala/Tuple2._2(Lorg/dom4j/Element;)V|424207
182|invokevirtual|47024|scala/Tuple2._1(Lorg/dom4j/Element;)V|415368
184|invokestatic|154716|org/codehaus/groovy/runtime/ScriptBytecodeAdapter.castToType()Lorg/apache/ws/jaxme/xs/xml/XsEDocumentation;|300929
184|invokestatic|175307|clojure/lang/RT.var(Lorg/aspectj/org/eclipse/jdt/internal/compiler/codegen/CodeStream;)V|296335
1|aconst_null|||250045
182|invokevirtual|2582|java/util/ArrayList.get(Ljava/lang/Object;I)V|209668
182|invokevirtual|1103|java/util/HashMap.get(LHTTPClient/Cookie;Ljava/lang/Object;)V|209542
184|invokestatic|160321|com/google/common/base/Preconditions.checkNotNull(Lorg/apache/spark/ml/param/Params;Lorg/apache/spark/ml/util/DefaultParamsReader$Metadata;)V|193665
182|invokevirtual|175314|clojure/lang/Var.getRawRoot(Lorg/aspectj/org/eclipse/jdt/internal/compiler/codegen/Label;)V|193312
185|invokeinterface|54291|scala/collection/Seq$.canBuildFrom(Lcom/sun/tools/xjc/generator/unmarshaller/AutomatonBuilder;Lcom/sun/tools/xjc/grammar/ClassItem;)Lcom/sun/tools/xjc/generator/unmarshaller/automaton/Automaton;|164218
185|invokeinterface|759|HTTPClient/BufferedInputStream.markForSearch(C)Z|161817
0|nop|175314|clojure/lang/Var.getRawRoot(Lorg/aspectj/org/eclipse/jdt/internal/compiler/codegen/Label;)V|148123
182|invokevirtual|12842|java/lang/ref/SoftReference.get(Lorg/activemq/service/impl/SubscriptionImpl;Lorg/activemq/service/impl/MessagePointer;)V|142777
185|invokeinterface|3|java/io/PrintStream.println(I)V|136329
192|checkcast|193|HTTPClient/ParseException.<init>()LHTTPClient/URI;|113328
182|invokevirtual|54241|scala/Some.x(Ljava/lang/String;Ljava/lang/String;Z)Ljava/lang/String;|108912
182|invokevirtual|75788|shapeless/$colon$colon.tail()Lorg/w3c/dom/html/HTMLDOMImplementation;|106315
182|invokevirtual|67|java/util/Hashtable.get(Ljava/lang/String;)[Ljava/lang/String;|100418
182|invokevirtual|4937|java/lang/ThreadLocal.get(Labbot/script/Resolver;Ljava/awt/Component;)V|99245
182|invokevirtual|406|java/util/Vector.elementAt()Ljava/util/Calendar;|95545
182|invokevirtual|47252|scala/collection/immutable/$colon$colon.head()Lcom/sun/xml/bind/v2/model/core/EnumLeafInfo;|94912
182|invokevirtual|47335|scala/Option.getOrElse(Lorg/dom4j/Node;)V|90738
182|invokevirtual|69835|scala/Predef$.implicitly(Ljavax/activation/DataHandler;)Ljava/lang/String;|87142
183|invokespecial|337|java/lang/Object.clone(Ljava/lang/String;)Z|86293
25|aload|11482|org/apache/derby/iapi/services/io/FormatableHashtable.size(Lorg/activemq/message/Packet;Lorg/activemq/message/ActiveMQDestination;)Lorg/activemq/message/ActiveMQMessage;|85315
182|invokevirtual|46980|scala/collection/immutable/List.map(Ljava/io/Writer;Ljava/lang/String;)V|82727
182|invokevirtual|72659|scala/Some.get(Ljava/lang/String;Ljava/lang/String;Z)Ljava/lang/String;|80702
182|invokevirtual|612|java/lang/Class.newInstance()Ljava/util/Enumeration;|79667
184|invokestatic|175356|clojure/lang/RT.map(Lorg/aspectj/org/eclipse/jdt/internal/compiler/codegen/CodeStream;)V|78410
184|invokestatic|170041|org/codehaus/groovy/runtime/typehandling/ShortTypeHandling.castToString(Lorg/aspectj/compiler/base/parser/JavaParser;Lorg/aspectj/compiler/base/ast/Expr;Ljava/lang/String;)Lorg/aspectj/compiler/base/ast/TypeD;|77265
192|checkcast|162|java/io/InputStream.read(Ljava/util/Date;)Ljava/lang/String;|76100
184|invokestatic|175309|clojure/lang/RT.keyword(Lorg/aspectj/org/eclipse/jdt/internal/compiler/codegen/CodeStream;)V|74984
182|invokevirtual|47119|scala/collection/immutable/Map$.apply()Lcom/sun/xml/bind/v2/model/core/ErrorHandler;|72546
0|nop|||71096
184|invokestatic|1099004|org/apache/hadoop/yarn/webapp/hamlet/HamletImpl.setSelector(Lorg/hl7/fhir/instance/model/api/IBaseResource;)Lca/uhn/fhir/validation/ValidationResult;|68601
25|aload|11592|org/apache/derby/iapi/types/DataTypeDescriptor.isExactTypeAndLengthMatch(Lorg/activemq/store/PersistenceAdapter;)V|68475
182|invokevirtual|72669|scala/reflect/api/Names$TermNameExtractor.apply(Lcom/sun/org/apache/xml/internal/utils/QName;)Lcom/sun/org/apache/xalan/internal/templates/ElemVariable;|67166
182|invokevirtual|53946|scala/collection/Seq$.apply(Lcom/sun/tools/xjc/generator/unmarshaller/AutomatonBuilder;Lcom/sun/tools/xjc/grammar/ClassItem;)Lcom/sun/tools/xjc/generator/unmarshaller/automaton/Automaton;|65481
185|invokeinterface|3223589|org/jvnet/jaxb2_commons/locator/util/LocatorUtils.property(Ljava/lang/Object;)Lcom/appdynamics/repackaged/asm/Item;|65434
