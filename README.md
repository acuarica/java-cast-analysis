
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

### Simple cast

```java
Object o = "Ciao";
return (String)o;
```

```
0: ldc           #2                  // String Ciao
2: astore_0
3: aload_0
4: checkcast     #3                  // class java/lang/String
7: areturn
```

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

Same as target class for `checkcast`.

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


Notice the use of `aconst_null` as a source value for `checkcast`.
Why would you cast on `null`?

## Source Values for `instanceof`

Same as Source Values for `checkcast`.


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

[MavenDS](https://bitbucket.org/acuarica/mavends)

[JNIF](https://bitbucket.org/acuarica/jnif)

### Queries

To retrieve the stats showed above,
we have used SQL queries against the bytecode database.
Each individual query is aimed to answer a precise question.
The following list presents all the SQL queries used to retrieve the stats,
and its respective answer (after the `;`).

* [How many checkcast instructions?](sql/checkcast-count.out)
* [`checkcast` most used arguments](sql/checkcast-most-used-args.out)
* [`checkcast` most used targets](sql/checkcast-most-used-target.out)
* [How many classes?](sql/class-count.out)
* [How many bytecode instructions?](sql/code-count.out)
* [How many `equals` methods?](sql/equals-method-count.out)
* [How many `equals` methods with `checkcast`?](sql/equals-method-w-checkcast-count.out)
* [How many `equals` methods with `instanceof`?](sql/equals-method-w-instanceof-count.out)
* [How many `instanceof` instructions?](sql/instanceof-count.out)
* [`instanceof` most used arguments](sql/instanceof-most-used-args.out)
* [`instanceof` most used targets](sql/instanceof-most-used-target.out)
* [How many `.jar` files?](sql/jar-count.out)
* [How many `.jar` files with classes?](sql/jar-w-classes-count.out)
* [How many methods?](sql/method-count.out)
* [How many methods with `checkcast` instruction?](sql/method-w-checkcast-count.out)
* [How many methods with `instanceof` instruction?](sql/method-w-instanceof-count.out)
* [How many methods with signature?](sql/methods-w-signature.out)

## Complex Analysis

Now the following problem comes: How to extract code patterns?
The database itself is not enough, and it faces scalability problems.

**The idea would be to use method slicing, both backward and forward.
In this way we can see how the casting are being used.**

After the slicing, we could implement some sort of method equivalence to detect
different patterns.
