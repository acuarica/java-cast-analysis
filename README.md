
# Java Cast Analysis

## Introduction

Java Cast Analysis in the Wild.

We carry out our analysis at the bytecode level on the Maven Repository.
Since we are not interested in the artifacts evolution,
for our analysis we used the last version of each artifact.
In total we have analysed *88GB* of compressed `.jar` files.

## Preliminary Considerations

For the bytecode analysis,
we need to take into consideration certain code is being compiled.
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
| Number of `checkcast` instructions  | 47,622,853    |
| Number of `instanceof` instructions | 8,411,639     |
| Number of methods w/ `checkcast`    | 27,019,431    |
| Number of methods w/ `instanceof`   | 5,267,707     |

Notice that around a 12% of methods contain a `checkcast` instruction.
Which means that it is used a lot.

But there are way less `instanceof` instructions than `checkcast`.
What does it mean?
A lot of `checkcast`s are unguarded.

## Target Class for `checkcast`

The `checkcast` instruction takes one argument,
the class to be casted to.

The following table shows which are the most used classes that are being casted to.

| Class name                                         |   Count |
|----------------------------------------------------|---------|
| java/lang/String                                   | 3509804 |
| [Ljava/lang/Object;                                | 1900928 |
| java/util/Map$Entry                                |  717424 |
| java/lang/Integer                                  |  580605 |
| java/util/List                                     |  525894 |
| scala/Tuple2                                       |  511008 |
| scala/collection/immutable/List                    |  489604 |
| clojure/lang/IFn                                   |  382457 |
| java/util/Map                                      |  356934 |
| scala/collection/Seq                               |  351292 |
| java/lang/Class                                    |  316641 |
| clojure/lang/Var                                   |  299987 |
| java/lang/Long                                     |  295733 |
| [B                                                 |  292021 |
| java/lang/Boolean                                  |  291414 |
| java/util/Collection                               |  275128 |
| [Ljava/lang/String;                                |  253887 |
| scala/Option                                       |  251707 |
| org/apache/xmlbeans/SimpleValue                    |  250821 |
| java/lang/Number                                   |  242243 |
| java/lang/Throwable                                |  181986 |
| java/lang/Double                                   |  171700 |
| java/lang/Character                                |  162980 |
| scala/Some                                         |  155876 |
| java/util/Set                                      |  151597 |
| scala/Function1                                    |  150071 |
| scala/collection/immutable/Map                     |  146670 |
| [I                                                 |  141794 |
| scala/collection/immutable/$colon$colon            |  134436 |
| java/lang/Comparable                               |  131103 |
| scala/collection/TraversableOnce                   |  124617 |
| scala/reflect/api/Trees$TreeApi                    |  121295 |
| java/lang/Float                                    |  118790 |
| com/google/protobuf/ByteString                     |  118745 |
| scala/reflect/internal/Trees$Tree                  |  117508 |
| [D                                                 |  114563 |
| shapeless/$colon$colon                             |  111732 |
| scala/reflect/api/Names$NameApi                    |  109965 |
| org/codehaus/groovy/runtime/callsite/CallSiteArray |  106139 |
| java/io/File                                       |  104074 |
| clojure/lang/AFn                                   |   93476 |
| scala/scalajs/js/Dynamic                           |   93342 |
| [C                                                 |   92569 |
| scala/collection/TraversableLike                   |   92429 |
| java/lang/Byte                                     |   92279 |
| java/lang/Short                                    |   92100 |
| scala/collection/immutable/Set                     |   90487 |
| scala/reflect/internal/Symbols$Symbol              |   89980 |
| [J                                                 |   85265 |
| org/antlr/runtime/tree/CommonTree                  |   83708 |


## Target Class for `instanceof`

Same as target class for `checkcast`.

| Class Name                                  |  Count |
|---------------------------------------------|--------|
| java/lang/String                            | 370467 |
| scala/Some                                  | 159547 |
| scala/collection/immutable/$colon$colon     | 132527 |
| java/lang/Number                            | 104804 |
| java/util/Map$Entry                         | 103969 |
| java/lang/Class                             |  90992 |
| java/util/List                              |  71285 |
| java/lang/Character                         |  68864 |
| java/lang/Integer                           |  67169 |
| java/util/Collection                        |  65349 |
| java/lang/RuntimeException                  |  63283 |
| java/util/Map                               |  56721 |
| java/lang/Boolean                           |  54042 |
| java/lang/Long                              |  53438 |
| java/lang/Double                            |  50870 |
| java/lang/reflect/ParameterizedType         |  49994 |
| [B                                          |  42157 |
| java/lang/Float                             |  41424 |
| java/lang/Error                             |  31794 |
| java/io/IOException                         |  28602 |
| java/lang/reflect/TypeVariable              |  28414 |
| java/lang/Short                             |  28129 |
| java/lang/Byte                              |  26136 |
| java/lang/reflect/GenericArrayType          |  25962 |
| java/util/Set                               |  25881 |
| java/lang/reflect/WildcardType              |  25745 |
| [Ljava/lang/Object;                         |  23725 |
| scala/util/Left                             |  19422 |
| scala/util/Right                            |  19226 |
| java/math/BigDecimal                        |  19145 |
| java/util/Date                              |  17207 |
| antlr/LexerGrammar                          |  16365 |
| [C                                          |  15666 |
| java/math/BigInteger                        |  15145 |
| java/lang/reflect/InvocationTargetException |  14750 |
| java/util/RandomAccess                      |  14685 |
| org/omg/CORBA/portable/ServantObjectExt     |  13500 |
| [I                                          |  13119 |
| org/w3c/dom/Element                         |  12503 |
| java/lang/Exception                         |  12429 |
| scala/reflect/internal/Trees$Select         |  12380 |
| [D                                          |  12359 |
| java/util/SortedSet                         |  12352 |
| [F                                          |  12243 |
| java/lang/Object                            |  12150 |
| [J                                          |  12114 |
| antlr/TreeWalkerGrammar                     |  11974 |
| [S                                          |  11919 |
| java/lang/reflect/Method                    |  11711 |
| [Z                                          |  11406 |

Notice the rank of `java.lang.Number`, and how it is not present in `checkcast`.

## Sources Values for `checkcast`

The `checkcast` instruction, besides the formal argument,
takes the object reference on the top of the stack to be casted.

The following table describes which are the most used source
values for `checkcast`.

The methodology to retrieve this value is to look at the instruction
previous to `checkcast`.
This might not be 100% accurate, but it provides a very good approximation.

*The argument for `invokeinterface` is incomplete*

|  Op | Opcode name     | Full Method Name                                                                                                    |   Count |
|-----|-----------------|---------------------------------------------------------------------------------------------------------------------|---------|
| 185 | invokeinterface |                                                                                                                     | 9245608 |
|  43 | aload_1         |                                                                                                                     | 7920092 |
|  44 | aload_2         |                                                                                                                     | 2314158 |
| 180 | getfield        |                                                                                                                     | 1441195 |
|  83 | aastore         |                                                                                                                     | 1322684 |
|  42 | aload_0         |                                                                                                                     | 1039779 |
|  45 | aload_3         |                                                                                                                     |  974959 |
|  25 | aload           |                                                                                                                     |  595487 |
| 182 | invokevirtual   | scala/Option.get()Ljava/lang/Object;                                                                                |  526377 |
|  50 | aaload          |                                                                                                                     |  516058 |
| 184 | invokestatic    | java/lang/Enum.valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;                                         |  441101 |
| 182 | invokevirtual   | scala/Tuple2._2()Ljava/lang/Object;                                                                                 |  424207 |
| 182 | invokevirtual   | scala/Tuple2._1()Ljava/lang/Object;                                                                                 |  415368 |
| 184 | invokestatic    | org/codehaus/groovy/runtime/ScriptBytecodeAdapter.castToType(Ljava/lang/Object;Ljava/lang/Class;)Ljava/lang/Object; |  300929 |
| 184 | invokestatic    | clojure/lang/RT.var(Ljava/lang/String;Ljava/lang/String;)Lclojure/lang/Var;                                         |  296335 |
|   1 | aconst_null     |                                                                                                                     |  250045 |
| 182 | invokevirtual   | java/util/ArrayList.get(I)Ljava/lang/Object;                                                                        |  209668 |
| 182 | invokevirtual   | java/util/HashMap.get(Ljava/lang/Object;)Ljava/lang/Object;                                                         |  209542 |
| 184 | invokestatic    | com/google/common/base/Preconditions.checkNotNull(Ljava/lang/Object;)Ljava/lang/Object;                             |  193665 |
| 182 | invokevirtual   | clojure/lang/Var.getRawRoot()Ljava/lang/Object;                                                                     |  193312 |
| 185 | invokeinterface | scala/collection/Seq$.canBuildFrom()Lscala/collection/generic/CanBuildFrom;                                         |  164218 |
| 185 | invokeinterface | HTTPClient/BufferedInputStream.markForSearch()V                                                                     |  161817 |
|   0 | nop             | clojure/lang/Var.getRawRoot()Ljava/lang/Object;                                                                     |  148123 |
| 182 | invokevirtual   | java/lang/ref/SoftReference.get()Ljava/lang/Object;                                                                 |  142777 |
| 185 | invokeinterface | java/io/PrintStream.println(Ljava/lang/String;)V                                                                    |  136329 |
| 192 | checkcast       | HTTPClient/ParseException.<init>(Ljava/lang/String;)V                                                               |  113328 |
| 182 | invokevirtual   | scala/Some.x()Ljava/lang/Object;                                                                                    |  108912 |
| 182 | invokevirtual   | shapeless/$colon$colon.tail()Lshapeless/HList;                                                                      |  106315 |
| 182 | invokevirtual   | java/util/Hashtable.get(Ljava/lang/Object;)Ljava/lang/Object;                                                       |  100418 |
| 182 | invokevirtual   | java/lang/ThreadLocal.get()Ljava/lang/Object;                                                                       |   99245 |
| 182 | invokevirtual   | java/util/Vector.elementAt(I)Ljava/lang/Object;                                                                     |   95545 |
| 182 | invokevirtual   | scala/collection/immutable/$colon$colon.head()Ljava/lang/Object;                                                    |   94912 |
| 182 | invokevirtual   | scala/Option.getOrElse(Lscala/Function0;)Ljava/lang/Object;                                                         |   90738 |
| 182 | invokevirtual   | scala/Predef$.implicitly(Ljava/lang/Object;)Ljava/lang/Object;                                                      |   87142 |
| 183 | invokespecial   | java/lang/Object.clone()Ljava/lang/Object;                                                                          |   86293 |
|  25 | aload           | org/apache/derby/iapi/services/io/FormatableHashtable.size()I                                                       |   85315 |
| 182 | invokevirtual   | scala/collection/immutable/List.map(Lscala/Function1;Lscala/collection/generic/CanBuildFrom;)Ljava/lang/Object;     |   82727 |
| 182 | invokevirtual   | scala/Some.get()Ljava/lang/Object;                                                                                  |   80702 |
| 182 | invokevirtual   | java/lang/Class.newInstance()Ljava/lang/Object;                                                                     |   79667 |
| 184 | invokestatic    | clojure/lang/RT.map([Ljava/lang/Object;)Lclojure/lang/IPersistentMap;                                               |   78410 |
| 184 | invokestatic    | org/codehaus/groovy/runtime/typehandling/ShortTypeHandling.castToString(Ljava/lang/Object;)Ljava/lang/String;       |   77265 |
| 192 | checkcast       | java/io/InputStream.read([BII)I                                                                                     |   76100 |
| 184 | invokestatic    | clojure/lang/RT.keyword(Ljava/lang/String;Ljava/lang/String;)Lclojure/lang/Keyword;                                 |   74984 |
| 182 | invokevirtual   | scala/collection/immutable/Map$.apply(Lscala/collection/Seq;)Lscala/collection/GenMap;                              |   72546 |
|   0 | nop             |                                                                                                                     |   71096 |

Notice the use of `aconst_null` as a source value for `checkcast`.
Why would you cast on `null`?

## Source Values for `instanceof`

Same as Source Values for `checkcast`.

|  Op | Opcode name     | Full Method Name                                                                          |   Count |
|-----|-----------------|-------------------------------------------------------------------------------------------|---------|
|  43 | aload_1         |                                                                                           | 3135273 |
|  44 | aload_2         |                                                                                           | 1222278 |
|  42 | aload_0         |                                                                                           |  758913 |
|  45 | aload_3         |                                                                                           |  700879 |
|  25 | aload           |                                                                                           |  669282 |
| 180 | getfield        |                                                                                           |  415667 |
|  50 | aaload          |                                                                                           |   80124 |
| 185 | invokeinterface |                                                                                           |   66216 |
|  25 | aload           | java/lang/Object.equals(Ljava/lang/Object;)Z                                              |   43367 |
|  25 | aload           | scala/runtime/BoxesRunTime.equalsNumObject(Ljava/lang/Number;Ljava/lang/Object;)Z         |   22563 |
|  25 | aload           | scala/collection/immutable/$colon$colon.tl$1()Lscala/collection/immutable/List;           |   20468 |
| 182 | invokevirtual   | scala/collection/immutable/$colon$colon.tl$1()Lscala/collection/immutable/List;           |   20322 |
|  89 | dup             |                                                                                           |   16445 |
|  25 | aload           | java/io/FilterInputStream.skip(J)J                                                        |   14387 |
| 196 | wide            |                                                                                           |   13060 |
| 182 | invokevirtual   | scala/Tuple2._2()Ljava/lang/Object;                                                       |   10710 |
| 182 | invokevirtual   | scala/Tuple2._1()Ljava/lang/Object;                                                       |    9831 |
| 182 | invokevirtual   | java/lang/reflect/InvocationTargetException.getTargetException()Ljava/lang/Throwable;     |    9516 |
|  25 | aload           | java/io/PrintStream.println(Ljava/lang/String;)V                                          |    9232 |
|  25 | aload           | scala/collection/immutable/$colon$colon.tl$access$1()Lscala/collection/immutable/List;    |    7101 |
|  25 | aload           | java/awt/Label.getText()Ljava/lang/String;                                                |    6803 |
|  25 | aload           | org/apache/derby/iapi/services/io/FormatableLongHolder.<init>(J)V                         |    6628 |
|  25 | aload           | scala/Some.<init>(Ljava/lang/Object;)V                                                    |    6493 |
|  25 | aload           | scala/Tuple2._2()Ljava/lang/Object;                                                       |    5891 |
|  25 | aload           | java/lang/Throwable.getCause()Ljava/lang/Throwable;                                       |    5422 |
|   0 | nop             |                                                                                           |    5140 |
| 182 | invokevirtual   | org/distributeme/core/interceptor/InterceptorResponse.getException()Ljava/lang/Exception; |    5065 |
|  25 | aload           | java/lang/StringBuilder.toString()Ljava/lang/String;                                      |    4931 |
| 182 | invokevirtual   | java/lang/RuntimeException.getCause()Ljava/lang/Throwable;                                |    4510 |
|  25 | aload           | javax/swing/JLabel.<init>(Ljava/lang/String;Ljavax/swing/Icon;I)V                         |    4498 |
|  25 | aload           | java/lang/reflect/InvocationTargetException.getTargetException()Ljava/lang/Throwable;     |    4247 |
|  25 | aload           | java/lang/String.equals(Ljava/lang/Object;)Z                                              |    4070 |
| 182 | invokevirtual   | scala/Option.get()Ljava/lang/Object;                                                      |    3748 |
| 182 | invokevirtual   | scala/reflect/internal/Trees$Select.qualifier()Lscala/reflect/internal/Trees$Tree;        |    3559 |
|  25 | aload           | scala/Option.get()Ljava/lang/Object;                                                      |    3544 |
| 182 | invokevirtual   | org/bouncycastle/asn1/ASN1Sequence.getObjectAt(I)Lorg/bouncycastle/asn1/ASN1Encodable;    |    3491 |
|  25 | aload           | HTTPClient/BufferedInputStream.markForSearch()V                                           |    3358 |
| 182 | invokevirtual   | scala/reflect/internal/Trees$Apply.fun()Lscala/reflect/internal/Trees$Tree;               |    3351 |
|  25 | aload           | org/apache/axis/client/Call.invoke([Ljava/lang/Object;)Ljava/lang/Object;                 |    3123 |
|  25 | aload           | java/lang/String.equalsIgnoreCase(Ljava/lang/String;)Z                                    |    3076 |
|  25 | aload           | scala/Some.x()Ljava/lang/Object;                                                          |    2714 |
|  25 | aload           | scala/Tuple2.<init>(Ljava/lang/Object;Ljava/lang/Object;)V                                |    2647 |
|  25 | aload           | java/awt/TextArea.<init>(II)V                                                             |    2576 |
| 182 | invokevirtual   | java/lang/reflect/InvocationTargetException.getCause()Ljava/lang/Throwable;               |    2520 |
|  25 | aload           | java/lang/reflect/InvocationTargetException.getCause()Ljava/lang/Throwable;               |    2499 |
| 182 | invokevirtual   | java/util/ArrayList.get(I)Ljava/lang/Object;                                              |    2395 |
| 182 | invokevirtual   | java/util/concurrent/ExecutionException.getCause()Ljava/lang/Throwable;                   |    2296 |
|  25 | aload           | akka/actor/FSM$Event.event()Ljava/lang/Object;                                            |    2175 |

## Methodology

### First approach: Java/ASM

To be able to do this kind of analysis,
we have dumped every bytecode in every `.jar` file in a SQLite database.
The size of the database currently is *157GB*.

The first approach was to use **ASM** for Java.
This approach did not work properly.
It seems that there is a memory leak either with the SQLite API
for Java or in **ASM**, because after have analyzed around 7,000 `.jar` files,
it throws a `OutOfMemoryError`.

### Second Approach: C++/JNIF

We finally have used the bytecode rewrite library **JNIF**
to extract every bytecode into a database.

The database is built in another repo, *mavends*.

[https://bitbucket.org/acuarica/mavends]

[https://bitbucket.org/acuarica/jnif]

## Complex Analysis

Now the following problem comes: How to extract code patterns?
The database itself is not enough, and it faces scalability problems.

The idea would be to use method slicing, both backward and forward.
In this way we can see how the casting are being used.

After the slicing, we could implement some sort of method equivalence to detect
different patterns.
