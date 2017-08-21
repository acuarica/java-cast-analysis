
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
return (Object)"Ciao";
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

Notice that around a 12% of methods contain a `checkcast` instruction.
Which means that it is used a lot.

But there are way less `instanceof` instructions than `checkcast`.
What does it mean?
A lot of `checkcast`s are unguarded.

## Target Class for `checkcast`

|  CN id | Class name                                         |   Count |
|--------|----------------------------------------------------|---------|
|      3 | java/lang/String                                   | 3509804 |
|    193 | [Ljava/lang/Object;                                | 1900928 |
|    759 | java/util/Map$Entry                                |  717424 |
|     33 | java/lang/Integer                                  |  580605 |
|    243 | java/util/List                                     |  525894 |
|  11496 | scala/Tuple2                                       |  511008 |
|  11480 | scala/collection/immutable/List                    |  489604 |
|  44201 | clojure/lang/IFn                                   |  382457 |
|    574 | java/util/Map                                      |  356934 |
|  11631 | scala/collection/Seq                               |  351292 |
|     46 | java/lang/Class                                    |  316641 |
|  44210 | clojure/lang/Var                                   |  299987 |
|     53 | java/lang/Long                                     |  295733 |
|    162 | [B                                                 |  292021 |
|     47 | java/lang/Boolean                                  |  291414 |
|   1234 | java/util/Collection                               |  275128 |
|    143 | [Ljava/lang/String;                                |  253887 |
|  11494 | scala/Option                                       |  251707 |
|   4443 | org/apache/xmlbeans/SimpleValue                    |  250821 |
|   2179 | java/lang/Number                                   |  242243 |
|     26 | java/lang/Throwable                                |  181986 |
|   1101 | java/lang/Double                                   |  171700 |
|     69 | java/lang/Character                                |  162980 |
|  11482 | scala/Some                                         |  155876 |
|   1271 | java/util/Set                                      |  151597 |
|  12803 | scala/Function1                                    |  150071 |
|  11530 | scala/collection/immutable/Map                     |  146670 |
|    216 | [I                                                 |  141794 |
|  11592 | scala/collection/immutable/$colon$colon            |  134436 |
|    854 | java/lang/Comparable                               |  131103 |
|  11483 | scala/collection/TraversableOnce                   |  124617 |
|  18137 | scala/reflect/api/Trees$TreeApi                    |  121295 |
|    105 | java/lang/Float                                    |  118790 |
|  12239 | com/google/protobuf/ByteString                     |  118745 |
| 216932 | scala/reflect/internal/Trees$Tree                  |  117508 |
|   5755 | [D                                                 |  114563 |
|  18260 | shapeless/$colon$colon                             |  111732 |
|  17329 | scala/reflect/api/Names$NameApi                    |  109965 |
|  37941 | org/codehaus/groovy/runtime/callsite/CallSiteArray |  106139 |
|     80 | java/io/File                                       |  104074 |
|  44212 | clojure/lang/AFn                                   |   93476 |
|  61359 | scala/scalajs/js/Dynamic                           |   93342 |
|   3243 | [C                                                 |   92569 |
|  11481 | scala/collection/TraversableLike                   |   92429 |
|   1839 | java/lang/Byte                                     |   92279 |
|   1100 | java/lang/Short                                    |   92100 |
|  11552 | scala/collection/immutable/Set                     |   90487 |
| 216921 | scala/reflect/internal/Symbols$Symbol              |   89980 |
|   3541 | [J                                                 |   85265 |
|  65610 | org/antlr/runtime/tree/CommonTree                  |   83708 |


## Target Class for `instanceof`

|   CN id | Class Name                                  |  Count |
|---------|---------------------------------------------|--------|
|       3 | java/lang/String                            | 370467 |
|   11482 | scala/Some                                  | 159547 |
|   11592 | scala/collection/immutable/$colon$colon     | 132527 |
|    2179 | java/lang/Number                            | 104804 |
|     759 | java/util/Map$Entry                         | 103969 |
|      46 | java/lang/Class                             |  90992 |
|     243 | java/util/List                              |  71285 |
|      69 | java/lang/Character                         |  68864 |
|      33 | java/lang/Integer                           |  67169 |
|    1234 | java/util/Collection                        |  65349 |
|     165 | java/lang/RuntimeException                  |  63283 |
|     574 | java/util/Map                               |  56721 |
|      47 | java/lang/Boolean                           |  54042 |
|      53 | java/lang/Long                              |  53438 |
|    1101 | java/lang/Double                            |  50870 |
|    5566 | java/lang/reflect/ParameterizedType         |  49994 |
|     162 | [B                                          |  42157 |
|     105 | java/lang/Float                             |  41424 |
|      58 | java/lang/Error                             |  31794 |
|      32 | java/io/IOException                         |  28602 |
|    5581 | java/lang/reflect/TypeVariable              |  28414 |
|    1100 | java/lang/Short                             |  28129 |
|    1839 | java/lang/Byte                              |  26136 |
|    5563 | java/lang/reflect/GenericArrayType          |  25962 |
|    1271 | java/util/Set                               |  25881 |
|    5580 | java/lang/reflect/WildcardType              |  25745 |
|     193 | [Ljava/lang/Object;                         |  23725 |
|   18350 | scala/util/Left                             |  19422 |
|   18351 | scala/util/Right                            |  19226 |
|    2201 | java/math/BigDecimal                        |  19145 |
|      38 | java/util/Date                              |  17207 |
|   21799 | antlr/LexerGrammar                          |  16365 |
|    3243 | [C                                          |  15666 |
|    3193 | java/math/BigInteger                        |  15145 |
|     222 | java/lang/reflect/InvocationTargetException |  14750 |
|   14919 | java/util/RandomAccess                      |  14685 |
| 5374112 | org/omg/CORBA/portable/ServantObjectExt     |  13500 |
|     216 | [I                                          |  13119 |
|    5321 | org/w3c/dom/Element                         |  12503 |
|      72 | java/lang/Exception                         |  12429 |
|  229914 | scala/reflect/internal/Trees$Select         |  12380 |
|    5755 | [D                                          |  12359 |
|   24855 | java/util/SortedSet                         |  12352 |
|    5758 | [F                                          |  12243 |
|       2 | java/lang/Object                            |  12150 |
|    3541 | [J                                          |  12114 |
|   21803 | antlr/TreeWalkerGrammar                     |  11974 |
|    3359 | [S                                          |  11919 |
|      94 | java/lang/reflect/Method                    |  11711 |
|    3160 | [Z                                          |  11406 |

Notice the rank of `java.lang.Number`, and how it is not present in `checkcast`.

## Sources Values for `checkcast`

|  Op | Opcode name     |  MR id | Full Method Name                                                                                                    |   Count |
|-----|-----------------|--------|---------------------------------------------------------------------------------------------------------------------|---------|
| 185 | invokeinterface |        |                                                                                                                     | 9245608 |
|  43 | aload_1         |        |                                                                                                                     | 7920092 |
|  44 | aload_2         |        |                                                                                                                     | 2314158 |
| 180 | getfield        |        |                                                                                                                     | 1441195 |
|  83 | aastore         |        |                                                                                                                     | 1322684 |
|  42 | aload_0         |        |                                                                                                                     | 1039779 |
|  45 | aload_3         |        |                                                                                                                     |  974959 |
|  25 | aload           |        |                                                                                                                     |  595487 |
| 182 | invokevirtual   |  47021 | scala/Option.get()Ljava/lang/Object;                                                                                |  526377 |
|  50 | aaload          |        |                                                                                                                     |  516058 |
| 184 | invokestatic    |  22857 | java/lang/Enum.valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;                                         |  441101 |
| 182 | invokevirtual   |  47025 | scala/Tuple2._2()Ljava/lang/Object;                                                                                 |  424207 |
| 182 | invokevirtual   |  47024 | scala/Tuple2._1()Ljava/lang/Object;                                                                                 |  415368 |
| 184 | invokestatic    | 154716 | org/codehaus/groovy/runtime/ScriptBytecodeAdapter.castToType(Ljava/lang/Object;Ljava/lang/Class;)Ljava/lang/Object; |  300929 |
| 184 | invokestatic    | 175307 | clojure/lang/RT.var(Ljava/lang/String;Ljava/lang/String;)Lclojure/lang/Var;                                         |  296335 |
|   1 | aconst_null     |        |                                                                                                                     |  250045 |
| 182 | invokevirtual   |   2582 | java/util/ArrayList.get(I)Ljava/lang/Object;                                                                        |  209668 |
| 182 | invokevirtual   |   1103 | java/util/HashMap.get(Ljava/lang/Object;)Ljava/lang/Object;                                                         |  209542 |
| 184 | invokestatic    | 160321 | com/google/common/base/Preconditions.checkNotNull(Ljava/lang/Object;)Ljava/lang/Object;                             |  193665 |
| 182 | invokevirtual   | 175314 | clojure/lang/Var.getRawRoot()Ljava/lang/Object;                                                                     |  193312 |
| 185 | invokeinterface |  54291 | scala/collection/Seq$.canBuildFrom()Lscala/collection/generic/CanBuildFrom;                                         |  164218 |
| 185 | invokeinterface |    759 | HTTPClient/BufferedInputStream.markForSearch()V                                                                     |  161817 |
|   0 | nop             | 175314 | clojure/lang/Var.getRawRoot()Ljava/lang/Object;                                                                     |  148123 |
| 182 | invokevirtual   |  12842 | java/lang/ref/SoftReference.get()Ljava/lang/Object;                                                                 |  142777 |
| 185 | invokeinterface |      3 | java/io/PrintStream.println(Ljava/lang/String;)V                                                                    |  136329 |
| 192 | checkcast       |    193 | HTTPClient/ParseException.<init>(Ljava/lang/String;)V                                                               |  113328 |
| 182 | invokevirtual   |  54241 | scala/Some.x()Ljava/lang/Object;                                                                                    |  108912 |
| 182 | invokevirtual   |  75788 | shapeless/$colon$colon.tail()Lshapeless/HList;                                                                      |  106315 |
| 182 | invokevirtual   |     67 | java/util/Hashtable.get(Ljava/lang/Object;)Ljava/lang/Object;                                                       |  100418 |
| 182 | invokevirtual   |   4937 | java/lang/ThreadLocal.get()Ljava/lang/Object;                                                                       |   99245 |
| 182 | invokevirtual   |    406 | java/util/Vector.elementAt(I)Ljava/lang/Object;                                                                     |   95545 |
| 182 | invokevirtual   |  47252 | scala/collection/immutable/$colon$colon.head()Ljava/lang/Object;                                                    |   94912 |
| 182 | invokevirtual   |  47335 | scala/Option.getOrElse(Lscala/Function0;)Ljava/lang/Object;                                                         |   90738 |
| 182 | invokevirtual   |  69835 | scala/Predef$.implicitly(Ljava/lang/Object;)Ljava/lang/Object;                                                      |   87142 |
| 183 | invokespecial   |    337 | java/lang/Object.clone()Ljava/lang/Object;                                                                          |   86293 |
|  25 | aload           |  11482 | org/apache/derby/iapi/services/io/FormatableHashtable.size()I                                                       |   85315 |
| 182 | invokevirtual   |  46980 | scala/collection/immutable/List.map(Lscala/Function1;Lscala/collection/generic/CanBuildFrom;)Ljava/lang/Object;     |   82727 |
| 182 | invokevirtual   |  72659 | scala/Some.get()Ljava/lang/Object;                                                                                  |   80702 |
| 182 | invokevirtual   |    612 | java/lang/Class.newInstance()Ljava/lang/Object;                                                                     |   79667 |
| 184 | invokestatic    | 175356 | clojure/lang/RT.map([Ljava/lang/Object;)Lclojure/lang/IPersistentMap;                                               |   78410 |
| 184 | invokestatic    | 170041 | org/codehaus/groovy/runtime/typehandling/ShortTypeHandling.castToString(Ljava/lang/Object;)Ljava/lang/String;       |   77265 |
| 192 | checkcast       |    162 | java/io/InputStream.read([BII)I                                                                                     |   76100 |
| 184 | invokestatic    | 175309 | clojure/lang/RT.keyword(Ljava/lang/String;Ljava/lang/String;)Lclojure/lang/Keyword;                                 |   74984 |
| 182 | invokevirtual   |  47119 | scala/collection/immutable/Map$.apply(Lscala/collection/Seq;)Lscala/collection/GenMap;                              |   72546 |
|   0 | nop             |        |                                                                                                                     |   71096 |

## Source Values for `instanceof`

|  Op | Opcode name     |    MR id | Full Method Name                                                                          |   Count |
|-----|-----------------|----------|-------------------------------------------------------------------------------------------|---------|
|  43 | aload_1         |          |                                                                                           | 3135273 |
|  44 | aload_2         |          |                                                                                           | 1222278 |
|  42 | aload_0         |          |                                                                                           |  758913 |
|  45 | aload_3         |          |                                                                                           |  700879 |
|  25 | aload           |          |                                                                                           |  669282 |
| 180 | getfield        |          |                                                                                           |  415667 |
|  50 | aaload          |          |                                                                                           |   80124 |
| 185 | invokeinterface |          |                                                                                           |   66216 |
|  25 | aload           |      711 | java/lang/Object.equals(Ljava/lang/Object;)Z                                              |   43367 |
|  25 | aload           |   155666 | scala/runtime/BoxesRunTime.equalsNumObject(Ljava/lang/Number;Ljava/lang/Object;)Z         |   22563 |
|  25 | aload           |    47253 | scala/collection/immutable/$colon$colon.tl$1()Lscala/collection/immutable/List;           |   20468 |
| 182 | invokevirtual   |    47253 | scala/collection/immutable/$colon$colon.tl$1()Lscala/collection/immutable/List;           |   20322 |
|  89 | dup             |          |                                                                                           |   16445 |
|  25 | aload           |    11494 | java/io/FilterInputStream.skip(J)J                                                        |   14387 |
| 196 | wide            |          |                                                                                           |   13060 |
| 182 | invokevirtual   |    47025 | scala/Tuple2._2()Ljava/lang/Object;                                                       |   10710 |
| 182 | invokevirtual   |    47024 | scala/Tuple2._1()Ljava/lang/Object;                                                       |    9831 |
| 182 | invokevirtual   |      919 | java/lang/reflect/InvocationTargetException.getTargetException()Ljava/lang/Throwable;     |    9516 |
|  25 | aload           |        3 | java/io/PrintStream.println(Ljava/lang/String;)V                                          |    9232 |
|  25 | aload           |   147488 | scala/collection/immutable/$colon$colon.tl$access$1()Lscala/collection/immutable/List;    |    7101 |
|  25 | aload           |     2179 | java/awt/Label.getText()Ljava/lang/String;                                                |    6803 |
|  25 | aload           |    11480 | org/apache/derby/iapi/services/io/FormatableLongHolder.<init>(J)V                         |    6628 |
|  25 | aload           |    46983 | scala/Some.<init>(Ljava/lang/Object;)V                                                    |    6493 |
|  25 | aload           |    47025 | scala/Tuple2._2()Ljava/lang/Object;                                                       |    5891 |
|  25 | aload           |    46724 | java/lang/Throwable.getCause()Ljava/lang/Throwable;                                       |    5422 |
|   0 | nop             |          |                                                                                           |    5140 |
| 182 | invokevirtual   | 18534406 | org/distributeme/core/interceptor/InterceptorResponse.getException()Ljava/lang/Exception; |    5065 |
|  25 | aload           |      831 | java/lang/StringBuilder.toString()Ljava/lang/String;                                      |    4931 |
| 182 | invokevirtual   |    48570 | java/lang/RuntimeException.getCause()Ljava/lang/Throwable;                                |    4510 |
|  25 | aload           |   216932 | javax/swing/JLabel.<init>(Ljava/lang/String;Ljavax/swing/Icon;I)V                         |    4498 |
|  25 | aload           |      919 | java/lang/reflect/InvocationTargetException.getTargetException()Ljava/lang/Throwable;     |    4247 |
|  25 | aload           |       88 | java/lang/String.equals(Ljava/lang/Object;)Z                                              |    4070 |
| 182 | invokevirtual   |    47021 | scala/Option.get()Ljava/lang/Object;                                                      |    3748 |
| 182 | invokevirtual   |   882068 | scala/reflect/internal/Trees$Select.qualifier()Lscala/reflect/internal/Trees$Tree;        |    3559 |
|  25 | aload           |    47021 | scala/Option.get()Ljava/lang/Object;                                                      |    3544 |
| 182 | invokevirtual   |    77684 | org/bouncycastle/asn1/ASN1Sequence.getObjectAt(I)Lorg/bouncycastle/asn1/ASN1Encodable;    |    3491 |
|  25 | aload           |      759 | HTTPClient/BufferedInputStream.markForSearch()V                                           |    3358 |
| 182 | invokevirtual   |   882175 | scala/reflect/internal/Trees$Apply.fun()Lscala/reflect/internal/Trees$Tree;               |    3351 |
|  25 | aload           |   205874 | org/apache/axis/client/Call.invoke([Ljava/lang/Object;)Ljava/lang/Object;                 |    3123 |
|  25 | aload           |        2 | java/lang/String.equalsIgnoreCase(Ljava/lang/String;)Z                                    |    3076 |
|  25 | aload           |    54241 | scala/Some.x()Ljava/lang/Object;                                                          |    2714 |
|  25 | aload           |    47023 | scala/Tuple2.<init>(Ljava/lang/Object;Ljava/lang/Object;)V                                |    2647 |
|  25 | aload           |       26 | java/awt/TextArea.<init>(II)V                                                             |    2576 |
| 182 | invokevirtual   |     5946 | java/lang/reflect/InvocationTargetException.getCause()Ljava/lang/Throwable;               |    2520 |
|  25 | aload           |     5946 | java/lang/reflect/InvocationTargetException.getCause()Ljava/lang/Throwable;               |    2499 |
| 182 | invokevirtual   |     2582 | java/util/ArrayList.get(I)Ljava/lang/Object;                                              |    2395 |
| 182 | invokevirtual   |     2019 | java/util/concurrent/ExecutionException.getCause()Ljava/lang/Throwable;                   |    2296 |
|  25 | aload           |   180297 | akka/actor/FSM$Event.event()Ljava/lang/Object;                                            |    2175 |
