package jsp.oracle.util;

import java.util.Vector;
/*
 * This Class is designed to split one string, given one delimiter,
 * or two strings at the same time, which have special relationships.
 * It is frequently used to read one string that contains many specific substrings
 * In this application, it might be used during accquiring statistics of votes,
 *  reading file attachments, obtaining adminuser's authorized columns,etc.
 *  This Class has three constructors,the second is defaulted to split
 *  file attachments,and has three parameters, while the third one can
 *  be used in computing statistics.
 */


public class ParseString {
	
	private int size;
	
	private int edge;
	
	private Vector stringVector=null;
	
	private Vector fileVector=null;
	
	private Vector descriptionVector=null;
	
	public int getEdge() {
		return edge;
	}
	public void setEdge(int edge) {
		this.edge = edge;
	}
	public Vector getDescriptionVector() {
		return descriptionVector;
	}
	public void setDescriptionVector(Vector descriptionVector) {
		this.descriptionVector = descriptionVector;
	}
	public Vector getFileVector() {
		return fileVector;
	}
	public void setFileVector(Vector fileVector) {
		this.fileVector = fileVector;
	}
	public int getSize() {
		return size;
	}
	public void setSize(int size) {
		this.size = size;
	}
	public Vector getStringVector() {
		return stringVector;
	}
	public void setStringVector(Vector stringVector) {
		this.stringVector = stringVector;
	}
	public ParseString(){
		size=0;
		stringVector=null;
		fileVector=null;
		descriptionVector=null;
		
	}
	
	/*********String.split()**************
	 * The string "boo:and:foo", for example, yields the following results
	 *  with these expressions: 

           Regex Result 
              : { "boo", "and", "foo" } 
              o { "b", "", ":and:f" }    //no "" in the end
              
              (200504242024230)3fe9bea129c3cd53.bmp|
              
              | {"(200504242024230)3fe9bea129c3cd53.bmp"}  
              
              (200504271744570)3fee2b5b0c33b406.doc|(200504271744571)3fd3c7ae40604518.jpg|
              
              |{"(200504271744570)3fee2b5b0c33b406.doc","(200504271744571)3fd3c7ae40604518.jpg"}


	 */
	
	//@param  String str: filePathName
	//@param  String str2: fileDescription
	//@param  int k: not used, to be different from the third constructor
	public ParseString(String str, String str2, int k) {
		fileVector=new Vector();
		descriptionVector=new Vector();
		String [] imgType={"jpg","gif","bmp","emf","png"};
		int flag=0;
		if(str!=null&&!str.equals("")&&str2!=null&&!str2.equals(""))
		{
			String [] temp=str.split("\\|");
			String [] temp2=str2.split("\\|");
			for (int i=0;i<temp.length&&i<temp2.length;i++) {
				//System.out.println(temp[i]);
				//System.out.println(temp2[i]);
				
				for(int j=0;j<imgType.length;j++)
				{
				if(temp[i].indexOf(imgType[j])!=-1)
					flag=1;//this attachment is an image
				}
				if(flag==0)//not an image, add to vector first
				{
					fileVector.add(temp[i]);
					descriptionVector.add(temp2[i]);
				}
				
			}
			
			edge=fileVector.size();
			
			for (int i=0;i<temp.length&&i<temp2.length;i++)
			{
				for(int j=0;j<imgType.length;j++)
				{
				if(temp[i].indexOf(imgType[j])!=-1)
					flag=1;//this attachment is an image
				}
				if(flag==1)//is an image, add to vector now
				{
					fileVector.add(temp[i]);
					descriptionVector.add(temp2[i]);
				}
			}
			size=fileVector.size();		
		}
		else
		{
			size=0;
			fileVector=null;
			descriptionVector=null;
		}

	}
	
	public ParseString(String str,String delimiter) {
		
		stringVector=new Vector();
		if(str!=null&&!str.equals("")&&delimiter!=null&&!delimiter.equals(""))
		{
			String [] temp=str.split(delimiter);
			for (int i=0;i<temp.length;i++) {
				stringVector.add(temp[i]);
				
			}
			size=stringVector.size();		
		}
		else
		{
			size=0;
			stringVector=null;
		}

	}
	
	
	
	
	

}
