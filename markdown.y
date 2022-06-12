%{
    #include<stdio.h>
    #include<string.h>
    #include "node.h"
    int yylex();
    int yyerror(const char *s);
    int success = 1;

     

    void tag_gen(struct node* p_node,char* content, char* tag_name);
    void str_concat(struct node* p_node, char* str1, char* str2);


%}

%union {
   struct node p_node;
}

%token  NEWLINE H1 H2 H3 UNORDEREDLIST 
%token <p_node> TEXT ITALIC BOLD UNDERLINE
%type <p_node> inline inlines ulline ullines line lines


%%

markdown:{$1.count = 1}lines {
    printf("\n<body>\n%s</body>\n", $1.text);
};


lines: line lines { str_concat(&$$, $1.text,$2.text);} | line {$$.text = strdup($1.text);};


line: H1 inlines NEWLINE { tag_gen(&$$, $2.text, "h1"); }
    | H2 inlines NEWLINE { tag_gen(&$$, $2.text, "h2"); }
    | H3 inlines NEWLINE { tag_gen(&$$, $2.text, "h3"); } 
    | inlines NEWLINE { tag_gen(&$$, $1.text, "p");}
    | ullines {tag_gen(&$$, $$.text, "ul");};

ullines: ulline ullines { str_concat(&$$, $1.text, $2.text);} 
        | ulline {$$.text = strdup($1.text);};

ulline: UNORDEREDLIST inlines NEWLINE {tag_gen(&$$, $2.text, "li");}
  
inlines: inline inlines {str_concat(&$$,$1.text," "); str_concat(&$$,$$.text, $2.text);} | inline {$$.text = strdup($1.text);};

inline: 
    BOLD {
        tag_gen(&$$, $1.text, "b");
    } 
    | ITALIC {
        tag_gen(&$$, $1.text, "i");
    }
    | UNDERLINE {
        tag_gen(&$$, $1.text, "u");
    } |
     TEXT {
         $$.text = strdup($1.text);
    };

%%

int main(int argc, char** argv)
{
    yyparse();
    if(success)
        printf("Parsing Successful\n");
    return 0;
}

int yyerror(const char *msg)
{
    extern int yylineno;
    printf("Parsing Failed: %s\n", msg);
    success = 0;
    return 0;
}

void tag_gen(struct node* p_node,char* content, char* tag_name)
{
    p_node->text = malloc(strlen(content)+strlen(tag_name)+6);
    sprintf(p_node->text, "<%s>%s</%s>\n", tag_name, content, tag_name);
}

void str_concat(struct node* p_node, char* str1, char* str2)
{
    p_node->text = malloc(strlen(str1)+strlen(str2));
    sprintf(p_node->text, "%s%s", str1, str2);
}
