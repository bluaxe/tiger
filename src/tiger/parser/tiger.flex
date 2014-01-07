/*
	  ______   _                         
	 /_  __/  (_)  ____ _   ___     _____
	  / /    / /  / __ `/  / _ \   / ___/
	 / /    / /  / /_/ /  /  __/  / /    
	/_/    /_/   \__, /   \___/  /_/     
	            /____/                   
 */

package tiger.parser;
import tiger.parser.sym;
import tiger.message.MsgQ;

%%

%class Tigerlex 
%cup
%char
%line
%function next_token
%standalone
%unicode
%state STRING STRINGNS COMMENT
%type java_cup.runtime.Symbol

%{
	int comment_num=0;
	StringBuffer string = new StringBuffer();

	public java_cup.runtime.Symbol tok(int kind, Object value) {
		return new java_cup.runtime.Symbol(kind, yychar, yychar+yylength(), value);
	}

	public void error(int line, int pos, String msg){
		messageQueue.error(line,pos,msg);
	}

	public void error(String msg){
		messageQueue.error(msg);
	}

	private MsgQ messageQueue = new MsgQ();
%}

%eofval{
	if (yystate()==STRING) error("'\"' doesn't match!");
	if (yystate()==STRINGNS) error("'\\' doesn't match!");
	if (yystate()==COMMENT) error("Comment symbol doesn't match!");
	return tok(sym.EOF,null);
%eofval}

Identifier = [:jletter:][:jletterdigit:]*
Decimal = [1-9][0-9]*
Octal = 0[0-7]*
Hex = 0x([0-9]|[A-F]|[a-f])+
Num = {Octal}|{Hex}|Decimal
LineTerminator = \r|\n|\r\n
Space = [ \t\f] | {LineTerminator}

%%

<YYINITIAL> {
	\" 			{ yybegin(STRING); string.setLength(0); }
	"/*" 		{ yybegin(COMMENT); comment_num+=1; }
	","			{ return tok(sym.COMMA,null); }
	":"			{ return tok(sym.COLON,null); }
	";"			{ return tok(sym.SEMICOLON,null); }
	"("			{ return tok(sym.LPAREN,null); }
	")"			{ return tok(sym.RPAREN,null); }
	"["			{ return tok(sym.LBRACK,null); }
	"]"			{ return tok(sym.RBRACK,null); }
	"{"			{ return tok(sym.LBRACE,null); }
	"}"			{ return tok(sym.RBRACE,null); }
	"."			{ return tok(sym.DOT,null); }
	"+"			{ return tok(sym.PLUS,null); }
	"-"			{ return tok(sym.MINUS,null); }
	"*"			{ return tok(sym.TIMES,null); }
	"/"			{ return tok(sym.DIVIDE,null); }
	"="			{ return tok(sym.EQ,null); }
	"<>"		{ return tok(sym.NEQ,null); }
	"<="		{ return tok(sym.LE,null); }
	">="		{ return tok(sym.GE,null); }
	"<"			{ return tok(sym.LT,null); }
	">"			{ return tok(sym.GT,null); }
	"&"			{ return tok(sym.AND,null); }
	"|"			{ return tok(sym.OR,null); }
	":="		{ return tok(sym.ASSIGN,null); }
	"array" 	{return tok(sym.ARRAY,null); }
	"break" 	{return tok(sym.BREAK,null); }
	"do" 		{return tok(sym.DO,null); }
	"if" 		{return tok(sym.IF,null); }
	"else" 		{return tok(sym.IF,null); }
	"end" 		{return tok(sym.END,null); }
	"for" 		{return tok(sym.FOR,null); }
	"function" 	{return tok(sym.FUNCTION,null); }
	"in" 		{return tok(sym.IN,null); }
	"let" 		{return tok(sym.LET,null); }
	"nil" 		{return tok(sym.NIL,null); }
	"of" 		{return tok(sym.OF,null); }
	"then" 		{return tok(sym.THEN,null); }
	"to" 		{return tok(sym.TO,null); }
	"type" 		{return tok(sym.TYPE,null); }
	"var" 		{return tok(sym.VAR,null); }
	"while"		{return tok(sym.WHILE,null); }
	{Num}		{return tok(sym.NUM,yytext()); }
	{LineTerminator}	{error("new line"); }
	{Space} 	{}
	{Identifier} { return tok(sym.ID,yytext()); }
	[^] 		{ error(yyline,yychar,"Unexpected char"+yytext()); }
		
}

<STRING> {
	\"	 	{ yybegin(YYINITIAL); return tok(sym.STRING,string); }
	"\\n"	{ string.append("\n"); }
	"\\t"	{ string.append("\t"); }
	"\\\""	{ string.append("\""); }
	"\\\\"	{ string.append("\\"); }
	"\\"[0-9]{3} {	int ascii=Integer.parseInt(yytext().substring(1,4));
					if (ascii>255) error("Error: ASCII code exceed 255.");
					else string.append((char)ascii); }
	"\\\^"[@A-Z\[\]\\\^_] { 
					int ascii = yytext().charAt(2);
					string.append((char)(ascii-64)); }
	"\\"	{ yybegin(STRINGNS); }
	[^] 	{ string.append(yytext());}
}

<STRINGNS> {
	"\\" 	{ yybegin(STRING); }
	{Space} {}
	"\""	{ error(yyline, yychar, "Error: '\\' doesn't match!"); }
	[^] 	{ string.append(yytext());}
}

<COMMENT> {
	"/*" 	{ comment_num+=1;}
	"*/"	{ comment_num-=1; if(comment_num==0) yybegin(YYINITIAL); }
	[^] {}
}