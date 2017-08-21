
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
ldc           "Foo"
areturn
```
