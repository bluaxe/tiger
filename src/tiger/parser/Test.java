package tiger.parser;

import java_cup.runtime.Symbol;
import java.io.*;

import tiger.Absyn.*;
import tiger.parser.Tigerlex;
import tiger.parser.sym;
import tiger.parser.Tigerparser;

public class Test {

	/**
	 * @param args
	 */
	public static void main(String[] args) throws IOException {
		// TODO Auto-generated method stub
		String my = new String("res/test.in");
		String good = new String("res/Good/queens.tig");
		String inputfile = new String("res/Bad/test10.tig");
		PrintStream out = new PrintStream("res/tiger.abs");
		//lexcialTest(inputfile);
		cupTest(inputfile,out);
	}
	
	public static void cupTest(String filename,PrintStream out) throws IOException {
		Tigerlex scanner = null;
		try {
            scanner = new Tigerlex( new java.io.FileReader(filename));
            
            Tigerparser tigerparser= new Tigerparser(scanner);
    		try {
    			tigerparser.parse();
    			Print print= new Print(out);
    			print.prExp(tigerparser.parseResult, 0);
    			System.out.print("OK!");
    		} catch (Exception e) {
    			// TODO Auto-generated catch block
    			e.printStackTrace();
    		}
        }
        catch (java.io.FileNotFoundException e) {
            System.out.println("File not found ");
        }
        catch (java.io.IOException e) {
            System.out.println("IO error scanning file ");
            System.out.println(e);
        }
        catch (Exception e) {
            System.out.println("Unexpected exception:");
            e.printStackTrace();
        }
		
	}

	public static void lexcialTest(String filename) throws IOException	 {
		Symbol tok;
		
		Tigerlex scanner = null;
        try {
            scanner = new Tigerlex( new java.io.FileReader(filename));
            //while ( !scanner.zzAtEOF ) scanner.next_token();
            do {
  			  tok = scanner.next_token();
  			  System.out.println(symnames[tok.sym] + " " + (tok.value==null?"":tok.value));
  		    } while(tok.sym != sym.EOF);
        }
        catch (java.io.FileNotFoundException e) {
            System.out.println("File not found ");
        }
        catch (java.io.IOException e) {
            System.out.println("IO error scanning file ");
            System.out.println(e);
        }
        catch (Exception e) {
            System.out.println("Unexpected exception:");
            e.printStackTrace();
        }
	}
	public static String symnames[] = new String[100];
	static {

		symnames[sym.FUNCTION] = "FUNCTION";
		symnames[sym.EOF] = "EOF";
		symnames[sym.INT] = "INT";
		symnames[sym.GT] = "GT";
		symnames[sym.DIVIDE] = "DIVIDE";
		symnames[sym.COLON] = "COLON";
		symnames[sym.ELSE] = "ELSE";
		symnames[sym.OR] = "OR";
		symnames[sym.NIL] = "NIL";
		symnames[sym.DO] = "DO";
		symnames[sym.GE] = "GE";
		symnames[sym.error] = "error";
		symnames[sym.LT] = "LT";
		symnames[sym.OF] = "OF";
		symnames[sym.MINUS] = "MINUS";
		symnames[sym.ARRAY] = "ARRAY";
		symnames[sym.TYPE] = "TYPE";
		symnames[sym.NUM] = "NUM";
		symnames[sym.FOR] = "FOR";
		symnames[sym.TO] = "TO";
		symnames[sym.TIMES] = "TIMES";
		symnames[sym.COMMA] = "COMMA";
		symnames[sym.LE] = "LE";
		symnames[sym.IN] = "IN";
		symnames[sym.END] = "END";
		symnames[sym.ASSIGN] = "ASSIGN";
		symnames[sym.STRING] = "STRING";
		symnames[sym.DOT] = "DOT";
		symnames[sym.LPAREN] = "LPAREN";
		symnames[sym.RPAREN] = "RPAREN";
		symnames[sym.IF] = "IF";
		symnames[sym.SEMICOLON] = "SEMICOLON";
		symnames[sym.ID] = "ID";
		symnames[sym.WHILE] = "WHILE";
		symnames[sym.LBRACK] = "LBRACK";
		symnames[sym.RBRACK] = "RBRACK";
		symnames[sym.NEQ] = "NEQ";
		symnames[sym.VAR] = "VAR";
		symnames[sym.BREAK] = "BREAK";
		symnames[sym.AND] = "AND";
		symnames[sym.PLUS] = "PLUS";
		symnames[sym.LBRACE] = "LBRACE";
		symnames[sym.RBRACE] = "RBRACE";
		symnames[sym.LET] = "LET";
		symnames[sym.THEN] = "THEN";
		symnames[sym.EQ] = "EQ";
	}
}
