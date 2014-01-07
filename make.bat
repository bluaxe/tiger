cd src
java java_cup.Main -parser Tigerparser -expect 2 tiger\parser\tiger.cup
mv sym.java tiger/parser/sym.java
mv Tigerparser.java tiger/parser/Tigerparser.java
cd tiger/parser
jflex tiger.flex & cd ../../..
