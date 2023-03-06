%{
	#include <stdio.h>
	#include <iostream>
	#include <string>
	#include <vector>
	#include <map>
	#include <unordered_set>
	#include <string.h>
	using namespace std;
	#include "y.tab.h"
	extern FILE *yyin;
	extern int yylex();
	void yyerror(string s);	
	extern int tabCounter;
	extern int linenumber;
	int tabCounterLast = 0;
	vector<string> errors;

	struct ifCounter{
        bool closed;
		int count;
		string type;
		bool full;
    };
	vector<ifCounter> ifvec;

	struct typeVec{
		string type;
		string name;
    };
    vector<typeVec> vec;

    struct declVec{
		string type;
		string name;
    };
	vector<declVec> var;

	int exp_tab = 1;

%}




%union
{
	int number;
	char * str;
}



%token<str> VARIABLE INTEGER MATHOP IF ELIF ELSE COMPARISON OPENPAR CLOSEPAR EQUAL COMMA COLON TAB NEWLINE FLOAT STRING
%type<str> value expression assignment statement program if_else 


%%	

program:
	statement
	{

		vector<string> floatv;
		vector<string> stringv;
		vector<string> intv;


		cout<<"}"<<endl;

		if (ifvec.empty() == 0) {
      		for (int i = ifvec.size() - 1; i >= 0; i--) {
        		if (ifvec[i].closed == false) {
          			for (int j = ifvec[i].count; j > 0; j--) {
            			cout << "\t";
          			}
          		cout << "}\n";
          		ifvec[i].closed = true;
        		}
        	}
      	}
      	
      	for(int i = 0; i<var.size(); i++)
      	{
      		if(var[i].type == "int")
      		{
      			string combined = var[i].name + "_" + var[i].type;
      			intv.push_back(combined);

      		}
      		else if(var[i].type == "flt")
      		{
      			string combined = var[i].name + "_" + var[i].type;
      			floatv.push_back(combined);

      		}
      		else if(var[i].type == "str")
      		{
      			string combined = var[i].name + "_" + var[i].type;
      			stringv.push_back(combined);

      		}

      	}

	
	}
	|
	statement program

    ;

statement:
	assignment
	{

		cout<<$$<<endl;
	}
	|
	if_else
	{

		cout<<$$;
	}
	|
	NEWLINE
	;



if_else:
	IF VARIABLE COMPARISON VARIABLE COLON 
	{
		string combined = "";
		exp_tab++;

		if(ifvec.empty() == 0){
			for(int i = ifvec.size()-1; i>=0; i--){
				if(ifvec[i].closed == false && ifvec[i].count>=tabCounter){
					for(int j = ifvec[i].count; j>0; j--){
						combined.append("\t");
					}
					combined.append("}\n");
					ifvec[i].closed = true;
				}
			}
		}





		ifCounter tmp;
		tmp.count = tabCounter;
		tmp.closed = false;
		tmp.type = "if";
		ifvec.push_back(tmp);

		for(int i=0; i<tabCounter; i++){
			combined += ("\t");
		}

		combined += (string($1) +" (" + string($2)+string($3)+string($4)+")\n");

		for(int i=0; i<tabCounter; i++){
			combined+="\t";
		}

		combined+="{\n";
		$$ = strdup(combined.c_str());
		//cout<<$$;

		tabCounter = 1;
		
	}
	|
	IF VARIABLE COMPARISON INTEGER COLON 
	{
		string combined = "";
		exp_tab++;

		if(ifvec.empty() == 0){
			for(int i = ifvec.size()-1; i>=0; i--){
				if(ifvec[i].closed == false && ifvec[i].count>=tabCounter){
					for(int j = ifvec[i].count; j>0; j--){
						combined.append("\t");
					}
					combined.append("}\n");
					ifvec[i].closed = true;
				}
			}
		}

		ifCounter tmp;
		tmp.count = tabCounter;
		tmp.closed = false;
		tmp.type = "if";
		ifvec.push_back(tmp);

		for(int i=0; i<tabCounter; i++){
			combined += ("\t");
		}

		combined += (string($1) +" (" + string($2)+string($3)+string($4)+")\n");

		for(int i=0; i<tabCounter; i++){
			combined+="\t";
		}

		combined+="{\n";
		$$ = strdup(combined.c_str());
		//cout<<$$;

		tabCounter = 1;
		
	}
	|
	ELIF VARIABLE COMPARISON VARIABLE COLON
	{
		string combined = "";
		exp_tab++;
		bool itr = 0;

		if(ifvec.empty() == 0){
			for(int i = ifvec.size()-1; i>=0; i--){
				if(ifvec[i].closed == false && ifvec[i].count==tabCounter && (ifvec[i].type== "if" || ifvec[i].type== "elif")){
					itr = 1;
				}
			}
		}

		if (itr==0){
			cout<<"elif before if in line" << linenumber<<endl;
			exit(0);
		}



		if(ifvec.empty() == 0){
			for(int i = ifvec.size()-1; i>=0; i--){
				if(ifvec[i].closed == false && ifvec[i].count>=tabCounter){
					for(int j = ifvec[i].count; j>0; j--){
						combined.append("\t");
					}
					combined+=("}\n");
					ifvec[i].closed = true;
				}
			}
		}

		ifCounter tmp;
		tmp.count = tabCounter;
		tmp.closed = false;
		tmp.type = "elif";
		ifvec.push_back(tmp);

		for(int i=0; i<tabCounter; i++){
			combined+=("\t");
		}

		combined.append("else if (" + string($2)+string($3)+string($4)+")\n");

		for(int i=0; i<tabCounter; i++){
			combined+=("\t");
		}

		combined+=("{\n");
		$$ = strdup(combined.c_str());
		//cout<<$$;

		tabCounter = 1;
		
	}
	|
	ELIF VARIABLE COMPARISON INTEGER COLON
	{
		string combined = "";
		exp_tab++;
		bool itr = 0;

		if(ifvec.empty() == 0){
			for(int i = ifvec.size()-1; i>=0; i--){
				if(ifvec[i].closed == false && ifvec[i].count==tabCounter && (ifvec[i].type== "if" || ifvec[i].type== "elif")){
					itr = 1;
				}
			}
		}

		if (itr==0){
			cout<<"elif after else in line" << linenumber<<endl;
			exit(0);
		}



		if(ifvec.empty() == 0){
			for(int i = ifvec.size()-1; i>=0; i--){
				if(ifvec[i].closed == false && ifvec[i].count>=tabCounter){
					for(int j = ifvec[i].count; j>0; j--){
						combined.append("\t");
					}
					combined+=("}\n");
					ifvec[i].closed = true;
				}
			}
		}

		ifCounter tmp;
		tmp.count = tabCounter;
		tmp.closed = false;
		tmp.type = "elif";
		ifvec.push_back(tmp);

		for(int i=0; i<tabCounter; i++){
			combined+=("\t");
		}

		combined.append("else if (" + string($2)+string($3)+string($4)+")\n");

		for(int i=0; i<tabCounter; i++){
			combined+=("\t");
		}

		combined+=("{\n");
		$$ = strdup(combined.c_str());
		//cout<<$$;

		tabCounter = 1;
		
	}
	|
	ELSE COLON
	{
		string combined = "";
		exp_tab++;
		bool flag = 0;


		if(ifvec.empty() == 0){
			for(int i = ifvec.size()-1; i>=0; i--){
				if(ifvec[i].closed == false && ifvec[i].count==tabCounter && (ifvec[i].type== "if" || ifvec[i].type== "elif")){
					flag = 1;
				}
			}
		}

		if (flag==0){

				cout<<"else without if in line " << linenumber;
				return 0;
		}


		if(ifvec.empty() == 0){
			for(int i = ifvec.size()-1; i>=0; i--){
				if(ifvec[i].closed == false && ifvec[i].count>=tabCounter){
					for(int j = ifvec[i].count; j>0; j--){
						combined+=("\t");
					}
					combined+=("}\n");
					ifvec[i].closed = true;

				}
			}
		}



		ifCounter tmp;
		tmp.count = tabCounter;
		tmp.closed = false;
		tmp.type = "else";
		ifvec.push_back(tmp);

		for(int i=0; i<tabCounter; i++){
			combined.append("\t");
		}

		combined.append(string($1)+ "\n");

		for(int i=0; i<tabCounter; i++){
			combined.append("\t");
		}




		combined.append("{\n");
		$$ = strdup(combined.c_str());
		//cout<<$$;

		tabCounter = 1;
	}
	|
	TAB if_else
	{
		
		$$ = strdup($2);
	}
	;

assignment:
	VARIABLE EQUAL expression
	{
		string combined = "";
		if(exp_tab < tabCounter){
			cout<<"tab inconsistency in line"<<linenumber<<endl;
			exit(0);
		}

		bool itr = 0;
		string tmpo = vec[0].type;
		if(vec.empty() == 0)
		{
			for(int i = 1; i < vec.size(); i++)
			{
				if(tmpo != vec[i].type){
					if((tmpo == "int" && vec[i].type == "flt") || (tmpo == "flt" && vec[i].type == "int") )
					{
						tmpo = "flt";
						
					} 
					else
					{
						itr = 1;
					}
				}
			}
		}
		if(itr == 1)
		{
			cout<<"type mismatch in line "<<linenumber<<endl;
			exit(0);
		}

		vec.clear();



		if(ifvec.empty() == 0){
			for(int i = ifvec.size()-1; i>=0; i--){
				if(ifvec[i].closed == false && ifvec[i].count>=tabCounter){
					for(int j = ifvec[i].count; j>0; j--){
						combined+=("\t");
					}
					combined.append("}\n");
					ifvec[i].closed = true;
				}

			}
		}

		ifCounter tmp;
		tmp.count = tabCounter;
		tmp.closed = true;
		tmp.type = "assignment";
		ifvec.push_back(tmp);

		declVec temp;
		temp.name = string($1);
		var.push_back(temp);	

		for(int i=0; i<tabCounter; i++){
			combined+=("\t");
		}
		
		combined+=string($1)+"="+string($3)+";";
		$$=strdup(combined.c_str());
		tabCounter = 1;
	}
	|
	TAB assignment
	{
		$$ = strdup($2);
	}
    ;

expression:
	value 
	{
		$$=strdup($1);
	}
    |
	expression MATHOP  value    
	{

		string combined=string($1)+string($2)+string($3);
		$$=strdup(combined.c_str());
	}
    ;

value:
	INTEGER	
	{ 
		typeVec tmp;
		tmp.type = "int";
		vec.push_back(tmp);

		declVec temp;
		temp.type = "int";
		var.push_back(temp);		

		string combined=string($1);
		$$=strdup(combined.c_str());

	}
	|
	FLOAT
	{
		typeVec tmp;
		tmp.type = "flt";
		vec.push_back(tmp);

		declVec temp;
		temp.type = "flt";
		var.push_back(temp);	

		string combined=string($1);
		$$=strdup(combined.c_str());
	}
	|
	STRING
	{
		typeVec tmp;
		tmp.type = "str";
		vec.push_back(tmp);

		declVec temp;
		temp.type = "str";
		var.push_back(temp);	

		string combined=string($1);
		$$=strdup(combined.c_str());
	}
	|
	VARIABLE   
	{
		$$=strdup($1);
	}
	|
	OPENPAR expression CLOSEPAR      {
		string combined="("+string($2)+")";
		$$=strdup(combined.c_str());
	}	
	;



%%
void yyerror(string s){
	cerr<<"Error..."<<endl;
}
int yywrap(){
	return 1;
}
int main(int argc, char *argv[])
{
    /* Call the lexer, then quit. */
    string combined = "void main()\n{ \n";
		cout<<combined;
    yyin=fopen(argv[1],"r");
    yyparse();
    fclose(yyin);
    return 0;
}