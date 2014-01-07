package tiger.message;

public class MsgQ {
	public int msgNum = 0;
	private List msgListHead = new List(0,0,null);
	private List current = msgListHead;
	
	public void append(int line, int pos, String msg){
		current.next = new List(line,pos,msg);
		current = current.next;
	}
	
	public void error(int line, int pos, String msg){
		print(line, pos, msg);
		append(line, pos, msg);
	}
	
	public void print(int line, int pos, String msg){
		if (line==0 && pos ==0 )
			System.out.println(msg);
		else 
			System.out.println("At (" + String.valueOf(line) + "," + String.valueOf(pos) + ")  " + msg);
	}
	
	public void error(String msg){
		error(0,0,msg);
	}
	
	public void dump(){
		List p = new List();
		p = msgListHead;
		while(p!=current){
			print(p.line, p.pos, p.msg);
			p = p.next;
		}
	}
	
}

class List{
	List next;
	String msg;
	int line;
	int pos;
	List(int l,int p,String m){
		line = l;
		pos = p;
		msg = m;
	}
	List(){};
	
}